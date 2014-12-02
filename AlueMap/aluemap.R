library(RCurl)
library(jsonlite)

AlueMap = function(address)
{
    # Gets location data form a given address.
    #
    # Args:
    #   address: Given address.
    #
    # Returns:
    #   An object with the address data.

    properaddress   = gsub(' ','+',address)
    urlformat   = 'http://nominatim.openstreetmap.org/search?q=%s&format=json&polygon=0&addressdetails=1'
    searchurl   = sprintf(urlformat,properaddress)
    
    searchjson  = getURIAsynchronous(searchurl)

    data        = fromJSON(searchjson,flatten=TRUE)

    return(data)
}
