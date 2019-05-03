
# Define server logic
shinyServer(function(input, output, session) {
  
  
  pct_grn = eventReactive({
    input$search
  },{
    wt_pa = as.numeric(input$weight_pa)
    wt_temp = as.numeric(input$weight_temp)
    wt_dens = as.numeric(input$weight_dens)
    wt_col = as.numeric(input$weight_col)
    wt_medi = as.numeric(input$weight_medi)
    wt_school = as.numeric(input$weight_school)
    n = wt_col + wt_dens + wt_pa + wt_temp + wt_medi + wt_school
    
    dem = ifelse(input$poli_affil == "Democrat", 1, -1)
    pa_pct = (df_master$Democrat - df_master$Republican) * dem > 0
    
    temp_pct = df_master$Average.Temperature < input$temp[2] & df_master$Average.Temperature > input$temp[1]
    
    dens_pct = df_master$dens < input$popdens[2] & df_master$dens > input$popdens[1]
    
    col_pct = df_master$COL.Index < input$col[2] & df_master$COL.Index > input$col[1]
    
    medi_pct = df_master$Median.Income < input$medincome[2] & df_master$Median.Income > input$medincome[1]
    
    school_pct = df_master$School.Rank <= input$school[2] & df_master$School.Rank >= input$school[1]
    
    if (n > 0) {
      # Return a weighted average between 0-1. To make higher values appear more luminous, square the average to reduce intensity of less fitting states.
      return( (( pa_pct*wt_pa +  temp_pct*wt_temp + dens_pct*wt_dens + col_pct*wt_col + medi_pct*wt_medi + school_pct*wt_school ) / n ) ^ 2)
    } else {
      return(0)
    }
  })
  
  # Create the map with global 'states' variable.
  output$map <- renderLeaflet({
    leaflet(states) %>%
      # Center the view on the continental 48 states.
      setView(-96, 37.8, 4, zoom = 4.2) %>%
      # Add the state outlines. JavaScript reactive implementation here too.
      addPolygons(
        layerId = df_master$State,
        weight = 1,
        dashArray = 2,
        fillColor = rgb(0, 0, 0, 1),
        color = "white",
        highlight = highlightOptions(
          weight = 2,
          opacity = 1,
          bringToFront = TRUE,
          dashArray = ""
        )
      )
  }) # End render leaflet.
  
  # Listen for click on a state.
  observeEvent(input$map_shape_click, {
    click <- input$map_shape_click
    selected_state = click$id
    state_data = df_master[df_master$State == selected_state,]
    
    output$sel_state_name = renderText(click$id)
  
    output$plot_PA = renderPlot({
      a = df_PA %>% gather("Affiliation", "value", Democrat:Republican)
      ggplot(a[a$State == click$id,]) +
        aes(x = State, y = value, fill = Affiliation) +
        geom_bar(stat = "identity") + coord_flip() +
        theme_void() + scale_fill_manual(values = c("dodgerblue2", "gray", "firebrick2")) +
        geom_text(aes(label = paste0(value, "%")), position = position_stack(vjust = 0.5), size = 4)
    })
    
    # Avg. temp. gauge
    output$sel_state_temp = renderGauge({
      gauge(state_data$Average.Temperature, 25, 75, symbol = "°F")
    })
    
    # Density gauge
    output$sel_state_dens = renderGauge({
      gauge(state_data$dens, 0, 1000)
    })
    
    # Cost of living gauge
    output$sel_state_col = renderGauge({
      gauge(state_data$COL.Index, 80, 200)
    })
    
    # Median income gauge
    output$sel_state_medi = renderGauge({
      gauge(round(state_data$Median.Income, 1), 35, 80, symbol = "$")
    })
    
    output$sel_state_schoolrank = renderGauge({
      gauge(state_data$School.Rank, 1, 50)
    })
    
    # Switch to details tab.
    updateTabsetPanel(session, inputId = "tabs", selected = "detailsTab")
  })
  
  # Search parameter change observer.
  observe({
    pct = pct_grn()
    
    # Must use leaflet proxy to update pre-existing map.
    leafletProxy("map", data = states) %>% clearShapes() %>%
      addPolygons(
        layerId = df_master$State,
        weight = 1,
        dashArray = 2,
        fillColor = rgb(0, pct, 0, 1),
        color = "white",
        highlight = highlightOptions(
          weight = 2,
          opacity = 1,
          bringToFront = TRUE,
          dashArray = ""
        )
      )
  })
  
})
