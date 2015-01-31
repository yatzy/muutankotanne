
complement_ddg_url = function(url){
   if( substr(url , 1 , 1) =='/' ){
      return( replacement = sub('/' , 'www.' , url) )
   } else {
      return(url)
   }
}

extract_ddg_links = function(keyword,about=F){
   base_part = "https://duckduckgo.com/html/?q="
   end_part = "&ia=about"
   if(about){
      url.name = paste0( base_part , keyword , end_part)
   } else{
      url.name = paste0( base_part , keyword)
   }
   url.get=GET(url.name)
   url.content=content(url.get, as="text")
   links <- xpathSApply(htmlParse(url.content), "//a/@href")
   links = unique( links[2:(length(links)-3)] )
   
   links = sapply(links , complement_ddg_url )
   return(links = unname(unlist(links) ))
}

get_url_content = function(link){
   cont = try( htmlTreeParse( getURL( link , .encoding = "UTF-8" ) ,  useInternal = TRUE) )
   #cont = htmlTreeParse( getURL( link ) ,  useInternal = TRUE) 
   #    cont = xpathApply(cont
   #                       , "//body//text()[not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)]"
   #                       , xmlValue)
   
   if(class(cont) == "try-error"){
      return(NA)
   } else {
      cont <- xpathSApply(cont, "//p", xmlValue)
      return(cont)
   }
}

remove_multiple_spaces <- function(x) {
   return(gsub("^ *|(?<= ) | *$", "", x, perl=T))
}

tide_text = function(content){
   #content = iconv(content, "latin1", "ASCII", sub="")
   #content = gsub("[^a-zA-Z]", " ", content) 
   content = gsub("^[a-zA-ZäöüÄÖÜ]*$", " ", content , perl=T) 
   #content = gsub("[\t\n\r\f\v] ", " ", content) 
   content = gsub("\\d+"," ",content )
   content = gsub("-" , " " , content , perl = T )
   content = gsub("/" , " ", content , perl = T )
   content = gsub("\"" , " ", content , perl = T )
   content = gsub(":" , " " , content , perl = T )   
   content = remove_multiple_spaces(content)
   return(content)
}

# EXAMPLE
# urls = extract_ddg_links('malmi')
# link = urls[1]
# content = tide_text(  get_url_content(link) )
# content
# paste(content, collapse = ' ')

ddg_search = function(keyword){
   urls = extract_ddg_links(keyword)
   texts = pblapply( urls 
                     , function(link) {
                        paste( tide_text(  get_url_content(link) ) , collapse = ' ' )
                     })
   content = paste(texts , collapse = ' ')
   return(content)
}

ddg_search('malmi')

tes2 = sapply(texts , function(x) str_replace_all(x , "[:punct:]" , " ") )

tes3 = sapply(texts, function(x){
   str_replace_all( x , "[^[a-zA-ZäöüÄÖÜ]*$]" , " ")
})

guess_encoding(texts[16])
repair_encoding(texts[[16]])
guess_encoding(texts[[18]])
repair_encoding(texts[[18]])

html_text( html() )