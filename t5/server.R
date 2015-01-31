if(file.exists("/home/yatzy/Applications/muutankotanne/App/")==TRUE){
   setwd("/home/yatzy/Applications/muutankotanne/App/")
} else if( file.exists("/home/kurkku/Applications/muutankotanne/App/")==TRUE ){
   setwd('/home/kurkku/Applications/muutankotanne/App/')
}

source('init/init_packages.R')
source('AlueMap/aluemap.R')

# parameters
DEBUG =T
MARKERS=T


# https://github.com/jcheng5/leaflet-shiny/blob/polygon-example/inst/example/server.R
########### parametrit


bindEvent <- function(eventExpr, callback, env=parent.frame(), quoted=FALSE) {
   eventFunc <- exprToFunction(eventExpr, env, quoted)
   
   initialized <- FALSE
   invisible(observe({
      eventVal <- eventFunc()
      if (!initialized)
         initialized <<- TRUE
      else
         isolate(callback())
   }))
}



shinyServer(function(input, output, session) {
   
   ########## Interactive Map #################################
   
   # Create the map
   map <- createLeafletMap(session, "map")
   
   
   output$kotiosoite <- renderText({ paste( input$kotiosoite_from_ui ) })
   output$muutto_osoite <- renderPrint({ cat(input$muutto_osoite_from_ui) })
   
   output$koti_pic = renderPlot(plot(1:10))
   output$muutto_pic = renderPlot(plot(10:1))
   
   koti_coord = reactive({reverse_geocode_nominatim( input$kotiosoite_from_ui )[c('lat','lon')] })
   
   output$kotiosoite_coord = renderPrint( reverse_geocode_nominatim( input$kotiosoite_from_ui )[c('lat','lon')] )
   output$muutto_osoite_coord = renderPrint(reverse_geocode_nominatim( input$muutto_osoite_from_ui )[c('lat','lon')] )   
   
   if(MARKERS){
      ##################### markers #####################
      
      values <- reactiveValues(markers = NULL)
      
      bindEvent(input$map_click, function() {
         values$selectedCity <- NULL
         if (!input$addMarkerOnClick)
            return()
         map$addMarker(input$map_click$lat, input$map_click$lng, NULL)
         values$markers <- rbind(data.frame(lat=input$map_click$lat,
                                            long=input$map_click$lng),
                                 values$markers)
      })
      
      bindEvent(input$clearMarkers, function() {
         map$clearMarkers()
         values$markers <- NULL
      })
           
      output$markers <- renderTable({
         if (is.null(values$markers))
            return(NULL)
         
         data <- values$markers
         colnames(data) <- c('Latitude', 'Longitude')
         return(data)
      })
      
      #################### markers removal   #################### 
      
      bindEvent(input$clearMarkers, function() {
         map$clearMarkers()
         values$markers <- NULL
      })
      
      
      bindEvent(input$map_shape_click, function() {
         event <- input$map_shape_click
         map$clearPopups()
         
         cities <- topCitiesInBounds()
         city <- cities[row.names(cities) == event$id,]
         values$selectedCity <- city
         content <- as.character(tagList(
            tags$strong(paste(city$City, city$State)),
            tags$br(),
            sprintf("Estimated population, %s:", input$year),
            tags$br(),
            prettyNum(city[[popCol()]], big.mark=',')
         ))
         map$showPopup(event$lat, event$lng, content, event$id)
      })
   }
})
