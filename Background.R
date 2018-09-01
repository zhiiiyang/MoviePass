library(rvest)
library(utils)
library(RCurl)
library(XML)
library(magrittr)
library(stringr)
library(curl)
library(omdbapi)
library(dplyr)
library(RJSONIO)
library(DT)
library(lubridate) 


source("Functions.R")

if ((Sys.Date() - as.Date(file.info("data/MovieNameID.rdata", extra_cols = TRUE)$mtime) )>7){
  h <- read_html("https://www.moviepass.com/movies/")
  nodes  <- html_nodes(h, '.push-top-lg') 
  
  date.index <- which(html_text(nodes) == "")

  dates <- html_text(nodes)[-date.index]
  
  MoviePassSchedule <- rep(list(NA), length(dates))
  MoviePassImage <- rep(list(NA), length(dates))
  
  #names(MoviePassSchedule) <- as.character(sapply(strsplit(dates, ", "), function(x) x[[1]]))
  Month2Dates <- as.list(1:12)
  names(Month2Dates) <- format(ISOdate(2018, 1:12,1),"%B")
  
  names(MoviePassSchedule) <- lapply(strsplit(sapply(strsplit(dates,", "), function(x) x[[2]]), " "), 
         function(x) paste0(Month2Dates[[x[[1]]]],"/", as.numeric(gsub("([0-9]+).*$", "\\1", x[[2]]))))

  
  for (i in 1:length(MoviePassSchedule)){
    image <- imgs[i] %>% html_nodes(".movies-img") %>% html_attr("src")
    MoviePassSchedule[[i]] <- sapply(strsplit(image, "\\/|\\.|\\_"), '[[', 5)
    MoviePassImage[[i]] <- nodes[-image.index][[i]] %>% html_nodes("img") %>% html_attr("src")
  }
  MovieNames <- sapply(unique(unlist(MoviePassSchedule)), FindName)
  MovieNameID<-cbind(MovieNames, imdbID=sapply(MovieNames, FindIMDB) %>% unlist(), url=unique(unlist(MoviePassImage)))
  
  MovieNameID[which(rownames(MovieNameID) %in% 
                   c("SKATEKITCHEN","MADELINESMADELINE","MISSIONIMPOSSIBLEFALLOUT")),
                    "imdbID"]<-c("tt7545566", "tt6101602","tt4912910")
  MovieNameID<-as.data.frame(MovieNameID, stringsAsFactors = FALSE)
  
  for(i in 1:nrow(MovieNameID)){
    download.file(paste0("https://www.moviepass.com", as.character(MovieNameID$url[i])),paste0('www/',MovieNameID$imdbID[i],'.jpg'), mode = 'wb')
  }
  
  save(MoviePassSchedule, file="data/MoviePassSchedule.rdata")
  save(MovieNameID, file="data/MovieNameID.rdata")
}

if (Sys.Date() != as.Date(file.info("data/title.ratings.tsv.gz", extra_cols = TRUE)$mtime) ){
  download.file("https://datasets.imdbws.com/title.ratings.tsv.gz", "data/title.ratings.tsv.gz")
  MovieRatings <- read.delim("data/title.ratings.tsv.gz", stringsAsFactors = FALSE)
  save(MovieRatings, file="data/MovieRatings.rdata")
}

load("data/MovieNameID.rdata")
load("data/MovieRatings.rdata")
load("data/MoviePassSchedule.rdata")

