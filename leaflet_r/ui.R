
# Define UI for application that draws a histogram
shinyUI(
   fluidPage(
   
   leaflet() %>% fitBounds( 24.89 , 60.16, 25 , 60.26)  %>% addTiles()    

   )
)
