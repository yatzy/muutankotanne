
mapServiceNameToUnits = function(unitdata, servicedata, name)
{
  # 
  
  unitcodes = servicedata[servicedata$name_fi == name, 'unit_ids'][[1]]
    
  units     = unitdata[unitdata$id %in% unitcodes,]
  
  return(units)
}