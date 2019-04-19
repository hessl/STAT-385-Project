print("Starting global.R script.")
# global.R loads before ui.R and server.R
library(shiny)

# This is where packages are loaded into the global environment.
library(ggplot2)
library(leaflet)
library(rvest)
library(geojsonio)

# This is where we should do scraping. Load data into global variables.
states = geojson_read("https://raw.githubusercontent.com/PublicaMundi/MappingAPI/master/data/geojson/us-states.json", what = "sp")

selected_state = NULL

print("Global script ran successfully.")