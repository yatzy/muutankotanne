
l1 = '/home/yatzy/Downloads/B01S_ESP_Vakiluku141108191440151415469448299s_2.csv'
l2 = '/home/yatzy/Downloads/A01S_HKI_Vakiluku141108191440151415469374685s_2.csv'
l3 = '/home/yatzy/Downloads/C01S_VAN_Vakiluku141108191440151415469470544s_2.csv'

f1 = read.csv(l1 , sep=';' , header=F , stringsAsFactors=F)
f2 = read.csv(l2 , sep=';' , header=F , stringsAsFactors=F)
f3 = read.csv(l3 , sep=';' , header=F , stringsAsFactors=F)


f = rbind(f1,f2,f3)
f = f[,1]
f =gsub( '\xe4' , 'ä' , f)
f =gsub( '\U3e36663c' , 'ö' , f)
f =gsub( '\U3e34633c' , 'Ä' , f)
f =gsub( '\xd6' , 'Ö' , f)

f = f[ !substr(f , 6,6) == ' ']
f = f[ !substr(f , nchar(f),nchar(f)) == ')']
f = f[ !substr(f , nchar(f)-3,nchar(f)) == 'Muut']
f = f[ !substr(tolower(f) , 5,5) %in% letters ]
f = f[ !substr(f , 7,7) == ' ']
f = substr(f , 9,nchar(f) )
f = f[  !c(f %in% c('Esikaupungit' , 'Kantakaupunki')) ]

ff = rbind(f1,f2,f3)
ff = ff[,1]
ff =gsub( '\xe4' , 'ä' , ff)
ff =gsub( '\U3e36663c' , 'ö' , ff)
ff =gsub( '\U3e34633c' , 'Ä' , ff)
ff =gsub( '\xd6' , 'Ö' , ff)
ff



write.table(f , file='/home/yatzy/Downloads/pienalueet' , sep='\n')