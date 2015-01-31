
sukija_path = '/home/yatzy/Applications/suomi-malaga-1.13/sukija'

get_sukija_inflection =  function( sana , sukija_path= '/home/yatzy/Applications/suomi-malaga-1.13/sukija'  ){
   return( 
      system( 
         sprintf( "echo %s | malaga -m %s/suomi.pro" , sana , sukija_path ) 
         , intern = T , ignore.stderr = T
      ) 
   )
}

strip_sukija_inflection = function( sukija_object ){
   answer_matrix = sapply( sukija_object , function(x){
      strsplit(x , ':' )[[1]]   
   } )
   ans = unique( substr ( answer_matrix[3 , ] , 3 , nchar(answer_matrix[3 , ])-1 ))
   ans = unique(ifelse(ans == 'nknow' , NA , ans ) )
   return(ans)
}

# strip_sukija_inflection(get_sukija_inflection('kuusi'))

# text = scan(file = '/home/yatzy/Applications/muutankotanne/Sanapilvi/teksti.txt' 
#             , sep=" " , what="character")



preprocess_text = function( text ){
   text = str_replace_all( tolower( gsub('-' , ' ' , text) ) , "[[:punct:]]" , "")
   text = unlist(strsplit( text , ' ' ) )
   text = text[ nchar(text) > 1 ]
}


sukija_inflection = function(string , in_multicore=F){
   strip_sukija_inflection(get_sukija_inflection(string))
}

inflect_finnish = function( word_vector , multicore=F ){
   if(!multicore){
      return(pblapply( word_vector , sukija_inflection ))      
   } else{
      require(parallel)
      return(
         mclapply( word_vector , sukija_inflection , in_multicore=T , mc.cores = detectCores() )
         #mcadply( word_vector , sukija_inflection , in_multicore=T , mc.cores = detectCores() )
      )
   }
}


# Example
# text = readLines(con = '/home/yatzy/Applications/muutankotanne/Sanapilvi/teksti.txt' )
# toolo = preprocess_text(text)
# 
# 
# toolo2 = toolo[1:20]
# asdf = inflect_finnish(toolo2)
# asdf = inflect_finnish(toolo)
# asdf = inflect_finnish(toolo , multicore=T)
