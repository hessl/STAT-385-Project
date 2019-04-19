# Define server logic
shinyServer(function(input, output, session) {
  
  
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
        fillColor = "green",
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
    
    # Switch to details tab.
    updateTabsetPanel(session, inputId = "tabs", selected = "detailsTab")
  })
})
