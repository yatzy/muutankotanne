library(RSQLite)

database <- dbConnect(SQLite(),dbname="muutankotanne.db")
results <- dbGetQuery(database,"select unit__ids from services where id = '27720';")$unit__ids
results2 <- dbGetQuery(database, sprintf("select id from units where id in('%s')",gsub(" ","\',\'", results)))
resultsplit <- as.matrix(strsplit(results," "))
#print(resultsplit)
#print(paste(resultsplit,collapse=","))
#print(sprintf("select * from services where id in(%s);",paste(resultsplit, "','")))
#results <- dbGetQuery(database,sprintf("select * from services where id in(%s);",gsub(as.character(resultsplit),'"',"'")))
print(results2)
print(resultsplit)
print(dim(results2))
print(dim(resultsplit))
print(is.matrix(resultsplit))
dbDisconnect(database)
