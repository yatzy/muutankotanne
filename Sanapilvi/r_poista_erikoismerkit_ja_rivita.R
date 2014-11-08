#!/usr/bin/Rscript

#eval(parse(text = rev(commandArgs())[1]))

#options(error=function(err) { 
#  cat("HEPSANKEIKKAA! Nyt meni pieleen\n") 
#  cat("\n\n") 
#  quit(save='no', status=1) 
#}) 


tiedosto_rlle <- commandArgs(TRUE)
#cat("luetaan tiedosto\n")

#	cat( tiedosto_rlle, "\n\n")

#tiedosto_rlle <- Sys.getenv("tiedosto_rlle") 
args <- commandArgs(TRUE)
cat(  " \n\n Luettu tiedosto kohteesta" , tiedosto_rlle , "\n\n" )

library(stringr)
teksti <- scan(tiedosto_rlle
               , sep=" " , what="character")
               
teksti <- str_replace_all(teksti , "[[:punct:]]" , "")

#cat(  " \n\n Tämä luettu" , teksti , "\n\n" )

ulosmeno <- as.character(tiedosto_rlle)
#ulosmeno <- substr(ulosmeno, 1, nchar(ulosmeno)-4 )
ulosmeno <- paste(ulosmeno , "_rout.txt" , sep="")
write.table(teksti , ulosmeno
            ,quote=FALSE , col.names = FALSE , row.names = FALSE)

cat(  " \n\n Kirjoitettu uusi tiedosto kohteeseen" , ulosmeno, "\n\n" )

Sys.setenv(tiedosto_malagalle=ulosmeno)

cat("!!!!!!!!!!! R:llä meni nappiin !!!!!!!!!!! \n")
