runApp(list(
   ui = fluidPage(
      selectizeInput(
         'foo', '', choices = state.name,
         options = list(
            placeholder = 'Please select an option below',
            onInitialize = I('function() { this.setValue(""); }')
         )
      )
   ),
   server = function(input, output) {}
))

