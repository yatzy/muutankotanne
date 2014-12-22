

use_base_package <- function(package) {
   if (!is.element(package, installed.packages()[,1]))
      install.packages(package, dep = TRUE)
   require(package, character.only = TRUE)
}

use_base_packages = function(package_list){
   sapply(package_list , use_base_package)
}

use_package('devtools')

use_github_package <- function(package) {
   if (!is.element(package, installed.packages()[,1]))
      install_github(package)
   require(package, character.only = TRUE)
}

use_github_packages = function(package_list){
   sapply(package_list , use_github_package)
}

############# ADD NEEDED PACKAGES TO THIS LIST
base_libraries = c('httr' , 'RCurl' ,'XML' , 'ggplot2' , 'maps' 
              ,'jsonlite' ,'leafletR')
use_packages(base_libraries)

############# ADD NEEDED GITHUB PACKAGES TO THIS LIST
github_libraries = c('jcheng5/leaflet-shiny' , 'trestletech/ShinyDash')
use_github_packages(github_libraries)

