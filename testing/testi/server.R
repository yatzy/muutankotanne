require(shiny)
require(shinysky)


shinyServer(function(input, output, session) {
   output$searchBox <- renderUI({
      if (is.null(input$search_option))
         return()
      # Depending on input$search_option, we'll generate a different search box with ontology
      # UI component and send it to the client.
      switch(input$search_option,
             "m1" = textInput.typeahead(id="thti",placeholder="type and select",local = to[,c(1,2)],valueKey = "Parent_Term", tokens = c(1:nrow(to)),template = HTML("<p class='repo-language'>{{Parent_Term}}</p> <p class='repo-name'>{{Ontology_ID}}</p> <p class='repo-description'></p>")),
             "m2" = textInput.typeahead(id="thti",placeholder="type and select",local = bp[,c(1,2)],valueKey = "Parent_Term", tokens = c(1:nrow(bp)),template = HTML("<p class='repo-language'>{{Parent_Term}}</p> <p class='repo-name'>{{Ontology_ID}}</p> <p class='repo-description'></p>")),
             "m3" = textInput.typeahead(id="thti",placeholder="type and select",local = mf[,c(1,2)],valueKey = "Parent_Term", tokens = c(1:nrow(mf)),template = HTML("<p class='repo-language'>{{Parent_Term}}</p> <p class='repo-name'>{{Ontology_ID}}</p> <p class='repo-description'></p>")),
             "m4" = textInput.typeahead(id="thti",placeholder="type and select",local = cc[,c(1,2)],valueKey = "Parent_Term", tokens = c(1:nrow(cc)),template = HTML("<p class='repo-language'>{{Parent_Term}}</p> <p class='repo-name'>{{Ontology_ID}}</p> <p class='repo-description'></p>")),
   })
   
   observe({
      input$thti
      input$search_option
      output$select_child_terms <- renderUI({
         selectizeInput("select_child_terms", label = h3("Select related terms"),
                        choices = unlist(getchildterms(input$thti,input$search_option)), multiple = TRUE)
      })
   })
   
   output$dynamic_value <- renderText({
      input$add_button
      isolate({
         #str(input$select_child_terms)
         paste(input$dynamic_value, input$select_child_terms, collapse = ",")
         #showshinyalert(session,"dynamic_value", paste(input$select_child_terms, collapse = ","), "info")
      })
   })
   
   
   
})
