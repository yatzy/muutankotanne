library(RCurl)
library(jsonlite)

reverse_geocode_table_nominatim = function(address){
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
   
   data        = jsonlite::fromJSON(searchjson,flatten=TRUE)
   return(data)
}

reverse_geocode_nominatim = function(address){
   # returns the best bet for address
   addr_table = reverse_geocode_table_nominatim(address)
   return( addr_table[ which.max(addr_table$importance) , 3:ncol(addr_table)  ] )
}
# example
# reverse_geocode_nominatim('mannerheimintie 53 , helsinki')[c('lat','lon')]
