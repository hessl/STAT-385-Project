# Define UI for application
shinyUI(fluidPage(

    # Application title
    titlePanel("The Perfect Fit"),

    # Sidebar layout
    sidebarLayout(
        # Main panel will be the map of the United States. The plot will be made on the server side with ggplot2.
        mainPanel(
            leafletOutput("map", height = 1000)
        ),
        
        # The sidebar panel will have all of the information as listed in the project proposal.
        sidebarPanel(
            # Our sidebar has two tabs, search, and details.
            tabsetPanel(
                
                # First tab, search bar
                tabPanel("Search",
                         verticalLayout(
                             h4("Search Parameters"),
                             sliderInput("temp",
                                         "Average Temperature:",
                                         min = 0,
                                         max = 80,
                                         value = c(20,60)),
                             sliderInput("crime",
                                         "Max Crime Rate:",
                                         min = 0,
                                         max = 10,
                                         value = c(0,5)),
                             sliderInput("popdens",
                                         "Population Density:",
                                         min = 1,
                                         max = 50,
                                         value = c(10,30)),
                             submitButton("Search")
                         )
                ), # End tab 1
                
                # Second tab, details
                tabPanel("Details",
                         verticalLayout(
                             h4("Selected State")
                         )
                )
            )
        )
    )
))
