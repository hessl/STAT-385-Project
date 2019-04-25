print("Starting global.R script.")
# global.R loads before ui.R and server.R
library(shiny)

# This is where packages are loaded into the global environment.
library(ggplot2)
library(leaflet)
library(rvest)
library(geojsonio)
library(stringr)
library(tidyr)

# Global variables.
states = geojson_read("https://raw.githubusercontent.com/PublicaMundi/MappingAPI/master/data/geojson/us-states.json", what = "sp")
selected_state = NULL

## Political affiliation data frame.
df_PA = data.frame()

# This is where we should do scraping. Load data into global variables.
## Political affiliation loading
download.file("https://www.pewforum.org/religious-landscape-study/compare/party-affiliation/by/state/", destfile = "poliAffil.html")
poliAffil = read_html("poliAffil.html")
PA_states = poliAffil %>% html_nodes("tbody .left-aligned") %>% html_text()
PA_rep = poliAffil %>% html_nodes(".left-aligned+ td") %>% html_text() %>% str_replace(., "%", "") %>% as.integer()
PA_dem = poliAffil %>% html_nodes("td:nth-child(4)") %>% html_text() %>% str_replace(., "%", "") %>% as.integer()

df_PA = data.frame("State" = PA_states, "Democrat" = PA_dem, "Other" = 100 - PA_rep - PA_dem, "Republican" = PA_rep) %>% gather("Affiliation", "value", Democrat:Republican)

print("Global script ran successfully.")