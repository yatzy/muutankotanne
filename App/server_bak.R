library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
set.seed(100)
#zipdata <- allzips[sample.int(nrow(allzips), 10000),]
# By ordering by centile, we ensure that the (comparatively rare) SuperZIPs
# will be drawn last and thus be easier to see
#zipdata <- zipdata[order(zipdata$centile),]

########### parametrit


shinyServer(function(input, output, session) {
   
   ## Interactive Map ###########################################
   
   # Create the map
   map <- createLeafletMap(session, "map")
   
   output$kotiosoite <- renderText({ paste( input$kotiosoite_from_ui ) })
   output$muutto_osoite <- renderPrint({ cat(input$muutto_osoite_from_ui) })
   
   output$koti_pic = renderPlot(plot(1:10))
   output$muutto_pic = renderPlot(plot(10:1))
   
   koti_coordinates = 
   
})
