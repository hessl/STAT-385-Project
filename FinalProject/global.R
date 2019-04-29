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


## Average annual temperature
download.file("https://www.currentresults.com/Weather/US/average-annual-state-temperatures.php", destfile = "avgtemp.html")
avgtemp = read_html("avgtemp.html")
at_states = avgtemp %>% html_nodes(".tablecol-1-left a") %>% html_text()
at_degf = avgtemp %>% html_nodes("td:nth-child(2)") %>% html_text() %>% as.numeric()
at_degc = avgtemp %>% html_nodes("td:nth-child(3)") %>% html_text() %>% as.numeric()

df_at = data.frame("State" = at_states, "Average Temperature(F)" = at_degf, "Average Temperature(C)" = at_degc) 

## Median Household Income
download.file("http://money.com/money/5177566/average-income-every-state-real-value/", destfile = "medincome.html")
medincome = read_html("medincome.html")
medincome_states = medincome %>% html_nodes(".padded > h3") %>% html_text()
medincome_val = medincome %>% html_nodes("#article-body li:nth-child(1)") %>% html_text() %>% 
  str_extract(., "[0-9]{2},[0-9]{3}+") %>% str_replace(., ",", "") %>% as.numeric()

df_medincome = data.frame("State" = medincome_states, "Median Income" = medincome_val)

## School Rankings
download.file("https://www.schooldigger.com/stateuserrankings.aspx", "schoolrank.html")
schoolrank = read_html("schoolrank.html")
schoolrank_states = schoolrank %>% html_nodes("td:nth-child(2)") %>% html_text()
schoolrank_rate = schoolrank %>% html_nodes(".center:nth-child(3)") %>% html_text() %>% as.numeric()
schoolrank_rank = schoolrank %>% html_nodes(".center:nth-child(1)") %>% html_text() %>% as.integer()

df_schoolrank = data.frame("State" = schoolrank_states, "Rank" = schoolrank_rank, "Average Rating" = schoolrank_rate)

## Cost of Living
download.file("https://www.missourieconomy.org/indicators/cost_of_living/", "costofliv.html")
costofliv_states = costofliv %>% html_nodes(".excel147 , .excel143") %>% html_text()
costofliv_rank = costofliv %>% html_nodes(".excel148 , .excel139") %>% html_text() %>% as.integer()
costofliv_index = costofliv %>% html_nodes(".excel148+ .excel149 , .excel139+ .excel140") %>% html_text() %>% as.numeric()

df_costofliv = data.frame("State" = costofliv_states, "Rank" = costofliv_rank, "Index" = costofliv_index)

print("Global script ran successfully.")


