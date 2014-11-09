complement_ddg_url = function(url){
   if( substr(url , 1 , 1) =='/' ){
      return( replacement = sub('/' , 'www.' , url) )
   } else {
      return(url)
   }
}


extract_ddg_links = function(keyword){
   base_part = "https://duckduckgo.com/html/?q="
   keyword = "kamppi"
   url.name=paste0( base_part , keyword)
   url.get=GET(url.name)
   url.content=content(url.get, as="text")
   links <- xpathSApply(htmlParse(url.content), "//a/@href")
   links = unique( links[2:(length(links)-3)] )

   links = sapply(links , complement_ddg_url )
   return(links = unname(unlist(links) ))
}


# EXAMPLE
# extract_ddg_links('kamppi')
