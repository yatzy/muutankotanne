use_base_package <- function(package) {
   if (!is.element(package, installed.packages()[,1]))
      install.packages(package, dep = TRUE, repos="http://cran.rstudio.com/")
   require(package, character.only = TRUE)
}

use_base_packages = function(package_list){
   sapply(package_list , use_base_package)
}

use_base_package('devtools')

use_github_package = function(package) {
   package_name = strsplit( package ,'/' )[[1]][2]
   if (!is.element(package_name, installed.packages()[,1]))
      install_github(package)
   require(package_name, character.only = TRUE)
}

use_github_packages = function(package_list){
   sapply(package_list , use_github_package)
}

############# ADD NEEDED PACKAGES TO THIS LIST
shiny_libraries = c('shiny' , 'jsonlite')
use_base_packages(shiny_libraries)

# ############# ADD NEEDED PACKAGES TO THIS LIST
# base_libraries = c('shiny','httr' , 'RCurl' ,'XML' , 'ggplot2' , 'maps' , 'stringr'
#               ,'jsonlite' ,'htmlwidgets' ,'magrittr', 'networkD3' 
#               , 'pbapply', 'scrapeR' ,'repmis' , 'tm.plugin.webmining','rjson'
#               , 'stringr', 'rvest','stringi','RColorBrewer','scales','lattice'
#               , 'ShinyDash')
# # no ,'leafletR' ,'dplyr'
# use_base_packages(base_libraries)

############# ADD NEEDED GITHUB PACKAGES TO THIS LIST
github_libraries = c( 'trestletech/ShinyDash' #,'jcheng5/leaflet-shiny'
                     ,'rstudio/leaflet','rstudio/htmlwidgets' , 'jjallaire/sigma' 
                     ,'rstudio/shinythemes')
# 'jcheng5/leaflet-shiny' # server down as tried13.1.2015
# 'ramnathv/rCharts' inferes rstudio's shiny library
# 'AnalytixWare/ShinySky'
use_github_packages(github_libraries)

use_leaflet <- function() {
   if (!is.element('leaflet', installed.packages()[,1]))
      install_git('https://github.com/jcheng5/leaflet-shiny')
   require('leaflet', character.only = TRUE)
}
use_leaflet()
