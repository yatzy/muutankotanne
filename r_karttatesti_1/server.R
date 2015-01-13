library(shiny)
library(rCharts)
library(rMaps)

shinyServer(
   function(input, output, session) {
   output$mapPlotJSON <- renderMap({
      map1 = Leaflet$new()
      map1$setView(c(45.5236, -122.675), 13)
      map1$tileLayer(provider ='Stamen.Terrain')
      map1$fullScreen(TRUE)
      #   map1$set(width = "100%", height = "100%") --doesn't show map
      map1
   })
})