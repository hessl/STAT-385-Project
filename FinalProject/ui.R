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
                        sliderInput("popdens", "Population Density:", min = 0, max = 1000, value = c(0,400), step = 25),
                        sliderInput("temp", "Average Temperature:", min = 0, max = 80, value = c(20,60), step = 5),
                        sliderInput("crime", "Max Crime Rate:", min = 0, max = 10, value = c(0,5))
                )),
                tabPanel("Details", value = "detailsTab",
                        textOutput("sel_state_name", container = h4),
                        plotOutput("plot_PA", height = "200px")
                )
            )
        ),
        
        # Main panel will be the map of the United States. The plot will be made on the server.
        mainPanel(leafletOutput("map", width = "100%", height = 800)),
        
        # Put the sidebar on the right.
        position = "right"
    )
))
