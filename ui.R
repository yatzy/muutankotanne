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


shinyUI(
   navbarPage("Muutanko tänne?"
              , id="nav"
              
              , tabPanel("Sovellus",
                         div(class="outer"
                             
                             , tags$head(
                                # Include our custom CSS
                                includeCSS("styles.css")
                                #, includeScript("gomap.js")
                             )
                             
                             ,   leafletMap("map", width="100%", height="100%"
                                            , initialTileLayer = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png"
                                            , initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>')
                                            , options=list(
                                               center = c(60.21,24.95)
                                               , zoom = 12
                                               , maxBounds = list(list(60.42450, 24.42330)
                                                                  , list(60.05791, 25.5197))                                              )
                             )
                             
                             
                             
                             ############### Vasemman puolen paneeli ###############
                             
                             , absolutePanel( 
                                ########## panel settings
                                fixed = F, draggable = FALSE
                                , id = "controls"
                                #, class = "modal"
                                , top = 60, left = 40 , right = "auto" , bottom = "auto"
                                , width = 330, height = "auto"
                                
                                ########## panel 
                                
                                , h3("Koti-osoite")
                                , textInput("kotiosoite_from_ui", label = p(""), value = "Kotiosoite") 
                                ,if(MARKERS){
                                #                                  ,actionLink('randomLocation', 'Go to random location')
                                checkboxInput('addMarkerOnClick', 'Add marker on click', FALSE)
                                }
                                
                                , if(DEBUG){
                                   #textOutput( "kotiosoite" )
                                   textOutput("kotiosoite_coord")
                                }
                                ,if(MARKERS){
                                   conditionalPanel(
                                      condition = 'output.markers',
                                      h4('Marker locations'),
                                      actionLink('clearMarkers', 'Clear markers')
                                   )
                                   tableOutput('markers')
                                }                       
                                
                                
                                # tulospaneeli käyttäjän osoitteen jälkeen
                                
                                , conditionalPanel(
                                   condition = "input.kotiosoite_from_ui != 'Kotiosoite'"
                                   , h5('Hyvin menee')
                                )
                                
                                , conditionalPanel(
                                   condition = "input.kotiosoite_from_ui != 'Kotiosoite'"
                                   , plotOutput( "koti_pic" )
                                )
                                
                                
                             )
                             
                             ############### Oikean puolen paneeli ###############
                             
                             , absolutePanel(  
                                fixed = F, draggable = FALSE
                                , id = "controls"
                                #, class = "modal"
                                , top = 60, left = "auto", right = 40, bottom = "auto",
                                width = 330, height = "auto",
                                
                                h3("Muutto-osoite")
                                
                                , textInput("muutto_osoite_from_ui", label = p(""), value = "Muutto-osoite") 
                                
                                , conditionalPanel(
                                   condition = "input.muutto_osoite_from_ui != 'Muutto-osoite'"
                                   , h5('Täällähän menee huonosti')
                                )
                                
                                
                                # tulospaneeli käyttäjän osoitteen jälkeen
                                , conditionalPanel(
                                   condition = "input.muutto_osoite_from_ui != 'Muutto-osoite'"
                                   , plotOutput( "muutto_pic" )
                                )
                                
                                
                                
                                ############### ensimmäisen välilehden loppu ###############
                             )
                             
                         )
              )
              
              
              , tabPanel("Infoa",
                         
                         h3('Tännekö joku esittely???')
                         
              )
   ))
