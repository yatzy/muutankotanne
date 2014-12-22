library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
   
   # Application title
#    titlePanel("Hello Shiny!"),
#    
#    # Sidebar with a slider input for the number of bins
#    sidebarLayout(
#       sidebarPanel(
#          sliderInput("bins",
#                      "Number of bins:",
#                      min = 1,
#                      max = 50,
#                      value = 30)
#       ),
      
      # Show a plot of the generated distribution
#       mainPanel(
#          plotOutput("distPlot")
#       )

   leafletMap(
      "map"
      , "100%"
      , 800
#       , initialTileLayer = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png"
#       , initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>')
      , options=list(
         center = c(60.22, 24.9),
         zoom = 12
#        ,  maxBounds = list(list(17, -180), list(59, 180) )
      )
   )
   
   )
)

