# Define server logic
shinyServer(function(input, output) {
  
  # Create the map with global 'states' variable.
  g = leaflet(states) %>%
    # Center the view on the continental 48 states.
    setView(-96, 37.8, 4, zoom = 4.2) %>%
    # Add the state outlines. 'weight' changes outline thickness.
    addPolygons(weight = 1)
  
  # Set the output.
  output$map = renderLeaflet(g)
})
