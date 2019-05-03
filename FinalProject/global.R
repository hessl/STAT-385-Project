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
library(dplyr)
#library(shinydashboard)
library(flexdashboard)

# Global variables.
states = geojson_read("https://raw.githubusercontent.com/PublicaMundi/MappingAPI/master/data/geojson/us-states.json", what = "sp")
states = states[states$name != "District of Columbia" & states$name != "Puerto Rico",]
selected_state = NULL

# This is where we should do scraping. Load data into global variables.

## Political affiliation loading
download.file("https://www.pewforum.org/religious-landscape-study/compare/party-affiliation/by/state/", destfile = "poliAffil.html")
poliAffil = read_html("poliAffil.html")
PA_states = poliAffil %>% html_nodes("tbody .left-aligned") %>% html_text()
PA_rep = poliAffil %>% html_nodes(".left-aligned+ td") %>% html_text() %>% str_replace(., "%", "") %>% as.integer()
PA_dem = poliAffil %>% html_nodes("td:nth-child(4)") %>% html_text() %>% str_replace(., "%", "") %>% as.integer()

df_PA = data.frame("State" = PA_states[-9], "Democrat" = PA_dem[-9], "Other" = 100 - PA_rep[-9] - PA_dem[-9], "Republican" = PA_rep[-9]) #%>% gather("Affiliation", "value", Democrat:Republican)


## Average annual temperature
download.file("https://www.currentresults.com/Weather/US/average-annual-state-temperatures.php", destfile = "avgtemp.html")
avgtemp = read_html("avgtemp.html")
at_states = avgtemp %>% html_nodes(".tablecol-1-left a") %>% html_text()
at_degf = avgtemp %>% html_nodes("td:nth-child(2)") %>% html_text() %>% as.numeric()

df_at = data.frame("State" = at_states, "Average Temperature" = at_degf) 

## Median Household Income
download.file("http://money.com/money/5177566/average-income-every-state-real-value/", destfile = "medincome.html")
medincome = read_html("medincome.html")
medincome_states = medincome %>% html_nodes(".padded > h3") %>% html_text()
medincome_val = medincome %>% html_nodes("#article-body li:nth-child(1)") %>% html_text() %>% 
  str_extract(., "[0-9]{2},[0-9]{3}+") %>% str_replace(., ",", "") %>% as.numeric()

df_medincome = data.frame("State" = medincome_states[-9], "Median Income" = (medincome_val/1000)[-9])

## School Rankings
download.file("https://www.schooldigger.com/stateuserrankings.aspx", "schoolrank.html")
schoolrank = read_html("schoolrank.html")
schoolrank_states = schoolrank %>% html_nodes("td:nth-child(2)") %>% html_text()
schoolrank_rate = schoolrank %>% html_nodes(".center:nth-child(3)") %>% html_text() %>% as.numeric()
schoolrank_rank = schoolrank %>% html_nodes(".center:nth-child(1)") %>% html_text() %>% as.integer()

df_schoolrank = data.frame("State" = schoolrank_states[-51], "School Rank" = schoolrank_rank[-51], "Average School Rating" = schoolrank_rate[-51])

## Cost of Living
download.file("https://www.missourieconomy.org/indicators/cost_of_living/", "costofliv.html")
costofliv = read_html("costofliv.html")
costofliv_states = costofliv %>% html_nodes(".excel147 , .excel143") %>% html_text()
costofliv_rank = costofliv %>% html_nodes(".excel148 , .excel139") %>% html_text() %>% as.integer()
costofliv_index = costofliv %>% html_nodes(".excel148+ .excel149 , .excel139+ .excel140") %>% html_text() %>% as.numeric()

df_costofliv = data.frame("State" = costofliv_states[-50], "COL Rank" = costofliv_rank[-50], "COL Index" = costofliv_index[-50])
df_costofliv[50, "COL.Rank"] = 50 # Since we removed D.C., set Hawaii COL to 50.


df_master = full_join(df_PA, df_at, by = "State") %>% full_join(., df_costofliv, by = "State") %>% full_join(., df_medincome, by = "State") %>% full_join(., df_schoolrank, by = "State")
df_master$dens = states$density

print("Global script ran successfully.")


