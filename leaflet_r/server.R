
shinyServer( function(input, output) {
   
   
   map = leaflet( ) %>% fitBounds( 24.89 , 60.16, 25 , 60.26)  %>% addTiles()    
   output$map = renderLeaflet(map)
   
#    leafletMap(
#       "map", "100%", 400,
#       initialTileLayer = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
#       initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>'),
#       options=list(
#          center = c(37.45, -93.85),
#          zoom = 4,
#          maxBounds = list(list(17, -180), list(59, 180))
#       )
   
   output$pic = renderPlot(plot(1:10))
   
   output$kotiosoite <- renderPrint({ input$kotiosoite })
   output$muutto_osoite <- renderPrint({ input$muutto_osoite })
   
   
})