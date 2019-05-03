
# Define server logic
shinyServer(function(input, output, session) {
  
  
  pct_grn = eventReactive({
    input$search
  },{
    n = as.numeric(input$weight_col) + as.numeric(input$weight_dens) + as.numeric(input$weight_pa) + as.numeric(input$weight_temp) + as.numeric(input$weight_medi) + as.numeric(input$weight_school)
    print(n)
    runif(50)
  })
  
  # Create the map with global 'states' variable.
  output$map <- renderLeaflet({
    leaflet(states) %>%
      # Center the view on the continental 48 states.
      setView(-96, 37.8, 4, zoom = 4.2) %>%
      # Add the state outlines. JavaScript reactive implementation here too.
      addPolygons(
        layerId = states$name,
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
    output$sel_state_name = renderText(click$id)
  
    output$plot_PA = renderPlot({
      ggplot(df_PA[df_PA$State == click$id,]) +
        aes(x = State, y = value, fill = Affiliation) +
        geom_bar(stat = "identity") + coord_flip() +
        theme_void() + scale_fill_manual(values = c("dodgerblue2", "gray", "firebrick2")) +
        geom_text(aes(label = paste0(value, "%")), size = 3.5)
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
        layerId = states$name,
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
