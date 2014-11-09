library(httr)
search.term="httr+package+daterange:%3A2456294-2456659"
url.name=paste0("https://www.google.com/search?q=",search.term)
url.get=GET(url.name)
url.content=content(url.get, as="text")
links <- xpathSApply(htmlParse(url.content), "//a/@href")
head(links,3)
# href 
# "https://www.google.com/webhp?tab=ww" 
# href 
# "https://www.google.com/search?q=httr%2Bpackage%2Bdaterange::2456294-2456659&um=1&ie=UTF-8&hl=en&tbm=isch&source=og&sa=N&tab=wi" 
# href 
# "https://maps.google.com/maps?q=httr%2Bpackage%2Bdaterange::2456294-2456659&um=1&ie=UTF-8&hl=en&sa=N&tab=wl" 