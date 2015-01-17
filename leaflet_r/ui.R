

# Define UI for application that draws a histogram
shinyUI(
   fluidPage( theme = shinytheme("united"),
      #titlePanel("Hieno kartta!"),
      #fluidRow(

         column(2
                , textInput("kotiosoite", label = p(""), value = "Kotiosoite")  
                , verbatimTextOutput("kotiosoite")
         ),
         
         
         #column(8 , leafletOutput('map', height = '100%', width = '100%' )),
         column(8 , leafletOutput('map', height=900 )),
         
         #column(8 , plotOutput(outputId = 'pic' )),
         #column(8 , plotOutput(outputId = 'pic', height='100%' )),
         
         column(2
                , textInput("muutto_osoite", label = p(""), value = "Muutto-osoite") 
                , verbatimTextOutput("muutto_osoite")
         )
      #)
   )
)
