library(shiny)
library(shinysky)

#header page includes a panel.
shinyUI(fluidPage(  
   #title
   headerPanel("my tool"),
   
   #create a sidebar layout
   column(3,wellPanel(
      #Radio option to select search type
      radioButtons("search_option", label = h3("Search by"),
                   c("method1" = "m1",
                     "method2" = "m2",
                     "method3" = "m3",
                     "method4" = "m4",
                     "Keyword" = "keyword")),
      #typeahead
      uiOutput("searchBox"),   
      
      # Dynamically rendered select box for selecting child terms  
      uiOutput("select_child_terms"),
      
      #show text input box if option is keyword search
      conditionalPanel(
         condition = "input.search_option == 'keyword'",
         textInput("search_term", label = "kwrd")
      ),
      
      #Action button to build query
      actionButton("add_button", label = "Add"),
      
      #text display
      verbatimTextOutput("dynamic_value")
      #textInput("dynamic_value",label=""),
      #shinyalert("dynamic_value",click.hide=FALSE),
      
      #    checkboxInput("list_option", label="Enter your own gene list?",value=FALSE)
      
      #    conditionalPanel(
      #     condition = "input.list_option == 'TRUE'",
      #      textInput(inputId="list",label="name list")
      #     ),
      
      #Submit button
      #submitButton(text="Submit")
   )
   )
))
