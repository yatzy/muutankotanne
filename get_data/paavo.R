# http://www.r-ohjelmointi.org/?p=1940
# Ladataan data
load(url("http://koti.mbnet.fi/tuimala/tiedostot/Paavo3_V2.RData"))
write.csv(paavo3 , file='/home/yatzy/Applications/muutankotanne/get_data/paavo.csv')
