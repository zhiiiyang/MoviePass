#Loading the rvest package
library(rvest)
library(stringr)
library(imdbapi)

source("Functions.R")

if ((Sys.Date() - as.Date(file.info("data/MovieNameID.rdata", extra_cols = TRUE)$mtime) )>7){
  webpage <- read_html("https://www.moviepass.com/movies/")
  
  input <- html_nodes(webpage, 'script')[3] %>%  html_text() %>% str_split("var") 
  
  Dates <- input[[1]][[6]] %>% str_match_all("'.+'") %>% unlist() %>% str_replace_all("'","")
  imgs <- input[[1]][5] %>% str_split(":", simplify = TRUE) %>% c() %>% str_extract_all("(/)([^ ]+).jpg") 
  
  %>% str_split("]", simplify = TRUE) %>% c() %>% str_extract_all("(/)([^ ]+).jpg") 

  Schedules <- lapply(imgs, function(x) str_split(x, "/")) %>% 
               lapply(., function(x) str_subset(unlist(x), ".jpg") %>% 
                       str_replace(".jpg","")) 
            
  Names <- Schedules %>% unlist() %>% unique() %>% sapply(FindName)
  
  
  imdbID <- sapply(Names, FindIMDB) %>% unlist()
  
  Ratings<-sapply(1:length(imdbID), function(x) {res <- unique(find_by_id(imdbID[x])$imdbRating);
                                      ifelse(length(res)!=0, res, unique(find_by_title(Names[x])$imdbRating))}) 
  
  Votes<-sapply(1:length(imdbID), function(x) {res <- unique(find_by_id(imdbID[x])$imdbVotes);
                                      ifelse(length(res)!=0, res, unique(find_by_title(Names[x])$imdbVotes))})
  
  MovieTables <- data.frame(Names=Names, imdbID=imdbID, url=unique(unlist(imgs)),
                            Ratings=Ratings, Votes=Votes) 
  
  MovieTables <- lapply(1:Schedules, function(x) MovieTables[x,])
  
  for(i in 1:nrow(MovieTables)){
    download.file(paste0("https://www.moviepass.com", as.character(MovieTables$url[i])),paste0('www/',MovieTables$Names[i],'.jpg'), mode = 'wb')
  }
  
  save(MovieTables, file="data/MovieTables.rdata")
  save(Dates, Names, Schedules, file="data/MovieNameDates.rdata")

}

if (Sys.Date() != as.Date(file.info("data/title.ratings.tsv.gz", extra_cols = TRUE)$mtime) ){
  download.file("https://datasets.imdbws.com/title.ratings.tsv.gz", "data/title.ratings.tsv.gz")
  MovieRatings <- read.delim("data/title.ratings.tsv.gz", stringsAsFactors = FALSE)
  save(MovieRatings, file="data/MovieRatings.rdata")
}


