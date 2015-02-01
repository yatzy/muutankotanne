if(file.exists("/home/yatzy/Applications/muutankotanne/App/")==TRUE){
   setwd("/home/yatzy/Applications/muutankotanne/App/")
} else if( file.exists("/home/kurkku/Applications/muutankotanne/App/")==TRUE ){
   setwd('/home/kurkku/Applications/muutankotanne/App/')
}

source('init/init_packages.R')
source('scripts/aluemap.R')

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
      if (!initialized){
         initialized <<- TRUE
      }
      else{
         isolate(callback())
      }
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
   if(DEBUG){
      print(koti_coord)
   }
   
   muutto_coord = reactive({reverse_geocode_nominatim( input$muutto_osoite_from_ui )[c('lat','lon')] })
   
   koti_coordinates = reactiveValues( lat = reverse_geocode_nominatim( input$muutto_osoite_from_ui )['lat']
                                 , lon = reverse_geocode_nominatim( input$muutto_osoite_from_ui )['lon'] )
   
   lat = observe(reverse_geocode_nominatim( input$muutto_osoite_from_ui )['lat'] )
   lon = observe(reverse_geocode_nominatim( input$muutto_osoite_from_ui )['lon'] )

   output$kotiosoite_coord = renderPrint( reverse_geocode_nominatim( input$kotiosoite_from_ui )[c('lat','lon')] )
   output$muutto_osoite_coord = renderPrint(reverse_geocode_nominatim( input$muutto_osoite_from_ui )[c('lat','lon')] )   
   
   ## OSOITE KARTALLE
   #    bindEvent(input$map_click, function() {
          map$addMarker(lat , lon )
   #    })
   

      #print(isolate(koti_coordinates$lat) ) 

   
   #    map$addMarker(koti_coord$lat , koti_coord$lon
   #                     , options=list(icon=list(
   #                       , iconUrl='my-icon.png'
   #                        ,iconRetinaUrl='my-icon@2.png'
   #                        ,iconSize=c(38, 95)
   #                        ,iconAnchor=c(22, 94)
   #                        ,popupAnchor=c(-3, -76)
   #                        ,shadowUrl='my-icon-shadow.png'
   #                        ,shadowRetinaUrl='my-icon-shadow@2x.png'
   #                        ,shadowSize=c(68, 95)
   #                        ,shadowAnchor=c(22, 94))
   #                     ))
   
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
         if (is.null(values$markers)){
            return(NULL)
         }
         data <- values$markers
         colnames(data) <- c('Latitude', 'Longitude')
         return(data)
      })
      
      
      
      
      
      #################### markers removal   #################### 
      
      #       bindEvent(input$clearMarkers, function() {
      #          map$clearMarkers()
      #          values$markers <- NULL
      #       })
      
      #       
      #       bindEvent(input$map_shape_click, function() {
      #          event <- input$map_shape_click
      #          map$clearPopups()
      #          
      #          cities <- topCitiesInBounds()
      #          city <- cities[row.names(cities) == event$id,]
      #          values$selectedCity <- city
      #          content <- as.character(tagList(
      #             tags$strong(paste(city$City, city$State)),
      #             tags$br(),
      #             sprintf("Estimated population, %s:", input$year),
      #             tags$br(),
      #             prettyNum(city[[popCol()]], big.mark=',')
      #          ))
      #          map$showPopup(event$lat, event$lng, content, event$id)
      #       })
      
      
   }
})
