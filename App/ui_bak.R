sourceDir <- function (path, pattern = "\\.[rR]$", env = NULL, chdir = TRUE) 
{
   files <- sort(dir(path, pattern, full.names = TRUE))
   lapply(files, source, chdir = chdir)
}



#source('init_packages.R')


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
                             
                             ,   leafletMap("map", width="100%", height="100%",
                                            initialTileLayer = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                                            initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>'),
                                            options=list(
                                               center = c(60.21,24.95)
                                               , zoom = 12
                                               , maxBounds = list(list(60.42450, 24.42330)
                                                                  , list(60.05791, 25.5197))                                              )
                             )
                             
                             
                             # Vasemman puolen paneeli
                             , absolutePanel( 
                                fixed = TRUE, draggable = FALSE
                                , id = "controls"
                                #, class = "modal"
                                , top = 60, left = 40 , right = "auto" , bottom = "auto"
                                , width = 330, height = "auto",
                                
                                h3("Koti-osoite")
                                
                                    # typeahead thingie, not too functional
#                                 , textInput.typeahead(
#                                    id="kotiosoite_from_ui"
#                                    ,placeholder="type 'name' or '2'"
#                                    ,local=data.frame(name=c("name1","name2"),info=c("info1","info2"))
#                                    ,valueKey = "name"
#                                    ,tokens=c(1,2)
#                                    ,template = HTML("ad")
#                                 )
                                
                                , textInput("kotiosoite_from_ui", label = p(""), value = "Kotiosoite") 
                                , textOutput("kotiosoite")
                                
                                # tulospaneeli käyttäjän osoitteen jälkeen

                                , conditionalPanel(
                                   condition = "input.kotiosoite_from_ui != 'Kotiosoite'"
                                   , h5('Täällähän menee hiton hyvin')
                                )
                                
                                , conditionalPanel(
                                   condition = "input.kotiosoite_from_ui != 'Kotiosoite'"
                                   , plotOutput( "koti_pic" )
                                )
                                
                                
                             )
                             
                             # Oikean puolen paneeli
                             , absolutePanel(  
                                fixed = TRUE, draggable = FALSE
                                , id = "controls"
                                #, class = "modal"
                                , top = 60, left = "auto", right = 40, bottom = "auto",
                                width = 330, height = "auto",
                                
                                h3("Muutto-osoite")
                                
                                , textInput("muutto_osoite_from_ui", label = p(""), value = "Muutto-osoite") 
                                , textOutput( "muutto_osoite" )
                                
                                , conditionalPanel(
                                   condition = "input.muutto_osoite_from_ui != 'Muutto-osoite'"
                                   , h5('Täällähän menee huonosti')
                                )
                                
                                
                                # tulospaneeli käyttäjän osoitteen jälkeen
                                , conditionalPanel(
                                   condition = "input.muutto_osoite_from_ui != 'Muutto-osoite'"
                                   , plotOutput( "muutto_pic" )
                                )                                                  
                             )
                             
                         )
              )
              
              
              , tabPanel("Infoa",
                         
                         h3('Tännekö joku esittely???')
                         
              )
   ))
