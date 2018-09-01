

FindName<-function(MovieName){
  url = URLencode(paste0("https://www.google.com/search?q=", paste(MovieName, "movie")))
  doc <- getURL(url) %>% htmlParse()
  name <- xpathSApply(doc, paste0("//div[@class ='FSP1Dd']"), xmlValue)
  return(name)
}


FindIMDB<-function(MovieName){
  if (length(search_by_title(strsplit(MovieName, " -")[[1]][1]))==0){
    return(NA)
  }else{
    resultList <-  search_by_title(strsplit(MovieName, " -")[[1]][1])%>% arrange(desc(Year)) %>% slice(1) %>% select(imdbID)
    return(resultList)
  }
}


GenerateTimeSchedule<-function(MovieName=MovieName, location=location, number=number, date=date){
  url = URLencode(paste0("https://www.google.com/search?q=", paste(MovieName, "movie", location, date)))
  doc <- getURL(url) %>% htmlParse()

  ##########
  ##schedule
  ##########
  theater <- xpathSApply(doc, paste0("//div[@class ='JLxn7']"), xmlValue)
  schedule <- xpathSApply(doc, paste0("//div[@class ='e3wEkd']"), xmlValue)
  
  theater <- theater[1:min(length(theater), number)]
  schedule <- schedule[1:min(length(schedule), number)]
  
  if (any(as.numeric(gregexpr("Atlantic",theater))>0)==TRUE | any(as.numeric(gregexpr("Edwards",theater))>0)==TRUE){
    # print(theater)
    # print(schedule)
    time_detail <- str_match_all(schedule,"([1]?[0-9][:][0-9][0-9])([ap][m])") %>% lapply(function(x) x[,1])
    names(time_detail) <- theater
    
  } else{
    time_detail <- paste("No schedules are available near", location)
    names(time_detail) <- paste("No theaters are available near", location)
  }
  
  return(as.vector(c(rbind(names(time_detail), lapply(time_detail, function(x) paste(x, collapse = " ")), " "))))
  
}




