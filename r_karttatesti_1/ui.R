library(shiny)
library(rCharts)

shinyUI(
   navbarPage("rMaps Leaflet Sizing"
              , tabPanel("Map",
                            #  tags$style('.leaflet {height: 100%; width: 100%}'), --no change 
                            mapOutput('mapPlotJSON')
                   )
))
