library(shiny)
library(leaflet)


shinyUI(navbarPage("Muutanko tänne?"
                   , id="nav"
                   
                   , tabPanel("Sovellus",
                            div(class="outer",
                                
                                tags$head(
                                   # Include our custom CSS
                                   includeCSS("styles.css"),
                                   includeScript("gomap.js")
                                ),
                                
                                leafletMap("map", width="100%", height="100%",
                                           initialTileLayer = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                                           initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>'),
                                           options=list(
                                              center = c(60.21,24.95),
                                              zoom = 12
                                              #, maxBounds = list(list(15.961329,-129.92981), list(52.908902,-56.80481)) # Show US only
                                           )
                                ), # 24.89 , 60.16, 25 , 60.26
                                
                                
                                # Vasemman puolen paneeli
                                absolutePanel(id = "controls", class = "modal", fixed = TRUE, draggable = FALSE,
                                              top = 60, left = 350 , right = "auto" , bottom = "auto",
                                              width = 330, height = "auto",
                                              
                                              h3("Koti-osoite")
                                  
                                              , textInput("kotiosoite", label = p(""), value = "Kotiosoite") 
                                              , verbatimTextOutput("kotiosoite_to_ui")
                                              
                                )              
                                 # Oikean puolen paneeli
                                , absolutePanel(id = "controls", class = "modal", fixed = TRUE, draggable = FALSE,
                                              top = 60, left = "auto", right = 20, bottom = "auto",
                                              width = 330, height = "auto",
                                              
                                              h3("Muutto-osoite")
                                              
                                              , textInput("muutto_osoite", label = p(""), value = "Muutto-osoite") 
                                              , verbatimTextOutput("muutto_osoite_to_ui")
                                 )
                                
                            )
                   )

                   
                   , tabPanel("Infoa",
                   
                   h3('Tännekö joku esittely???')

)))
