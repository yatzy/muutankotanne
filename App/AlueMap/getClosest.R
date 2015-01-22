library(geosphere)


getClosest = function(units, lat, lon, n=5)
{
  # 
  
  #unitcodes = servicedata[servicedata$name_fi == name, 'unit_ids'][[1]]
    
  #units     = unitdata[unitdata$id %in% unitcodes,]
  
  unitloc = matrix(c(units$lon, units$lat),ncol=2)
      
  placeloc = matrix(1,dim(unitloc)[1],2)
  
  placeloc[,1] = placeloc[,1] * as.numeric(lon)
  placeloc[,2] = placeloc[,2] * as.numeric(lat)
  print(placeloc)
  
  distloc    = distCosine(unitloc,placeloc)
  
  distsort = order(ordered(distloc))
  
  closest   = units$id[distsort][1:n]
  
  return(units[units$id %in% closest,])
}