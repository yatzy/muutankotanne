getGoogleCount <- function(searchTerms=NULL,
                           language="de",
                           ...){
   
   # check for arguments
   if(is.null(searchTerms)) stop("Please enter search terms!")
   if(!any(language==c("de","en"))) stop("Please enter correct
                                           language (de, en)!")
   
   # construct google like expression
   require(RCurl)
   # Collapse search terms.
   entry <- paste(searchTerms, collapse="+")
   siteHTML <- getForm("http://www.google.com/search",
                       hl=language, lr="", q=entry,
                       btnG="Search")
   
   # select language sepcific indicator word
   if(language=="de") indicatorWord <- "ungefähr" else
      indicatorWord <- "of about"        
   
   # start extraction at indicator word position
   posExtractStart <- gregexpr(indicatorWord, siteHTML,
                               fixed = TRUE)[[1]]
   # extract string of 30 chracters length
   stringExtract <- substring(siteHTML, first=posExtractStart,
                              last = posExtractStart + 30)
   # search for <b>number</b> (can be left out, see above)
   posResults <- gregexpr('<b>[0-9.,]{1,20}</b>', stringExtract)
   posFirst <- posResults[[1]][1]
   textLength  <- attributes(posResults[[1]])$match.length
   stringExtract <- substring(stringExtract, first=posFirst,
                              last = posFirst + textLength)
   # erase everything but the numbers
   matchCount <- as.numeric(gsub("[^0-9]", "", stringExtract))
   
   return(matchCount)
}

# NOR RUN

getGoogleCount(c("r-project"), language="en")
getGoogleCount(c("r-project", "europe"), language="en")