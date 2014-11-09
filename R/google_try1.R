library(httr)
test <- GET(url="https://api.domain.com/store/data/unique_indentifier/_query?input/search_query=BLACK%20BOX&_user_unique_indentifier&_apikey=xxxxxx/MZgI01RVu+fI6x/cd+riqIpg==")


tess = GET("http://google.com/"
    , path = "search"
    , query = list(q = "ham")
    , authenticate("juha.lehtiranta", "gayhra86") 
    )

GET("https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt",
    write_disk("inst/cacert.pem", overwrite = TRUE))
