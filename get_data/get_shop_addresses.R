base_url = 'http://aukioloajat.com/selaa/'
middle_parts = c('misc' , letters , 'å' , 'ä' , 'ö')
base_urls = paste( base_url , middle_parts , sep='')

get_links <- function(URL) {
   getLinks <- function() {
      links <- character()
      list(a = function(node, ...) {
         links <<- c(links, xmlGetAttr(node, "href"))
         node
      },
      links = function() links)
   }
   h1 <- getLinks()
   htmlTreeParse(URL, handlers = h1)
   h1$links()
}

get_address = function(url){
   address_vec = url %>% html %>% html_nodes('td') %>% html_text() 
   return(address_vec)
}

data_framify_vector = function( vec , nth ){   
      df = data.frame(
         sapply( 1:nth, function(this_nth){
            vec[seq(1, length(vec), nth) + this_nth-1 ]
         })
      )
      if(length(vec) > 6){
         return(df)
      } else{
         df = t(df)
         colnames(df) = paste('X',1:6, sep='')
         return(df)
   }
}

right_names = c('Nimi','Osoite',	'Postinro',	'Paikkakunta',	'Kaupunginosa',	'Aukioloaika' , 'Tyyppi')

address_df = as.data.frame(setNames(replicate(7,numeric(0), simplify = F), letters[1:7]))
colnames(address_df) = paste('X',1:6, sep='')

#address_list = list()

for( base_url in base_urls){
   cat('Going on url ' , base_url , '\n')
   # hakemistot a:sta ö:hön
   links = get_links(base_url)
   links = links[ substr(links , 1 , 30 ) == 'http://aukioloajat.com/ketjut/' ]
   categories = readHTMLTable(base_url)
   link_table = data.frame( unlist(links) , categories )
   colnames(link_table) = c('Linkki', 'Ketju', 'Kategoria', 'Määrä')
   #link_table = apply(link_table , 2 , as.character)
   for(row in 1:nrow(link_table)){
      link = as.character(link_table$Linkki[row])
      cat('    Going on link ' , link , '\n')
      link_address_df = data_framify_vector( get_address(link) , 6 ) 
      if(is.matrix(link_address_df)){
         link_address_df = as.data.frame(link_address_df)
      }
      link_address_df$category =  link_table$Kategoria[row]
      address_df = rbind(address_df , link_address_df )
      #address_list[[link]] = link_address_df
   }
}

#address_df = address_df[,-1]
rownames(address_df) = 1:nrow(address_df)
colnames(address_df) = right_names
address_df

legit_paikkakunnat = c('helsinki' , 'espoo' , 'vantaa' , 'kauniainen')
shops_pk =  address_df[ tolower(as.character(address_df$Paikkakunta)) %in% legit_paikkakunnat ,  ]
write.csv(shops_pk , file='/home/yatzy/Applications/muutankotanne/get_data/shops_pk.csv')
