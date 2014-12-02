library(RCurl)
library(jsonlite)

AlueMap = function(address)
{
    #curlGlobalInit()
    #urlformat   = 'http://nominatim.openstreetmap.org/search?q=%s+%s,+%s&format=json&polygon=0&addressdetails=1'
    properaddress   = gsub(' ','+',address)
    urlformat   = 'http://nominatim.openstreetmap.org/search?q=%s&format=json&polygon=0&addressdetails=1'
    searchurl   = sprintf(urlformat,properaddress)
    
    searchjson  = getURIAsynchronous(searchurl)

    data        = fromJSON(searchjson,flatten=TRUE)

    return(data)
}
