library(shiny)

# Define server logic required to draw a histogram
shinyServer( function(input, output, session) {
   
   map <- createLeafletMap(session, 'map')
   
})
