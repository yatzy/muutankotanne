

AlueMap = function(osoite, numero, kaupunki)
{
    urlformat = 'http://nominatim.openstreetmap.org/search?q=%s+%s,+%s&format=xml&polygon=0&addressdetails=1'
    searchurl = sprintf(urlformat,numero,osoite,kaupunki)
    return(searchurl)
}
