# Define UI for application
shinyUI(fluidPage(
    # Sidebar layout
    sidebarLayout(
        # The sidebar panel will have all of the information as listed in the project proposal.
        sidebarPanel(
            # The sidebar is split into 'Search' and 'Details' tabs.
            tabsetPanel(id = "tabs",
                tabPanel("Search", value = "searchTab", verticalLayout(
                        h4("Search Parameters"),
                        selectInput("poli_affil", "Political Affiliation", choices = c("No preference", "Democrat", "Republican")),
                        sliderInput("temp", "Average Temperature:", min = 0, max = 80, value = c(20,60)),
                        sliderInput("crime", "Max Crime Rate:", min = 0, max = 10, value = c(0,5)),
                        sliderInput("popdens", "Population Density:", min = 1, max = 50, value = c(10,30))
                )),
                tabPanel("Details", value = "detailsTab",
                        textOutput("sel_state_name", container = h4)
                )
            )
        ),
        
        # Main panel will be the map of the United States. The plot will be made on the server.
        mainPanel(leafletOutput("map", width = "100%", height = 800)),
        
        # Put the sidebar on the right.
        position = "right"
    )
))
