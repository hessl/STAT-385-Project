# Global UI variables
weight_opt = c(0, 1, 2)

# Define UI for application
shinyUI(fluidPage(
    h2("The Perfect Fit"),
    # Row layout so we can have uneven columns.
    sidebarLayout(
        
        # The sidebar panel will have all of the information as listed in the project proposal.
        sidebarPanel(style = "overflow-y:scroll;max-height:800px;width=400px",
            # The sidebar is split into 'Search' and 'Details' tabs.
            tabsetPanel(id = "tabs",
                tabPanel("Search", value = "searchTab", verticalLayout(
                        h4("Search Parameters"),
                        wellPanel( selectizeInput("poli_affil", "Political Affiliation", choices = c("Choose one" = "", "Democrat", "Republican")),
                                    selectInput("weight_pa", "Weight", weight_opt)),
                        wellPanel( sliderInput("temp", "Average Temperature", min = 20, max = 80, value = c(30,50), step = 5),
                                   selectInput("weight_temp", "Weight", weight_opt)),
                        wellPanel( sliderInput("popdens", "Population Density", min = 0, max = 1200, value = c(0,400), step = 25),
                                    selectInput("weight_dens", "Weight", weight_opt)),
                        wellPanel( sliderInput("col", "Cost of Living", min = 0, max = 10, value = c(0,5)),
                                    selectInput("weight_col", "Weight", weight_opt)),
                        wellPanel( sliderInput("medincome", "Median Household Income (thousands)", min = 35, max = 80, value = c(40, 50)),
                                    selectInput("weight_medi", "Weight", weight_opt)),
                        wellPanel( sliderInput("school", "School Rank", min = 1, max = 50, value = c(1, 10)),
                                    selectInput("weight_school", "Weight", weight_opt)),
                        actionButton("search", "Search")
                )),
                tabPanel("Details", value = "detailsTab",
                        textOutput("sel_state_name", container = h4),
                        plotOutput("plot_PA", height = "200px")
                )
            )
        ),
        
        
        # Main panel will be the map of the United States. The plot will be made on the server.
        mainPanel(leafletOutput("map", width = "100%", height = 800)),
        
        position = "right"
    )
))
