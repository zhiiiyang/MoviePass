#Loading the rvest package
library(rvest)
library(stringr)


#Reading the HTML code from the website
webpage <- read_html("https://www.moviepass.com/movies/")
 
input <- html_nodes(webpage, 'script')[3] %>%  html_text() %>% str_split("var") 

Days <- str_subset(input[[1]][2], coll('day', TRUE)) %>% str_extract_all('([^ ]+)(day)') %>% unlist()

## img 
imgsL <- input[[1]][5] %>% str_split("]", simplify = TRUE) %>% c() %>% str_extract_all("(/)([^ ]+).jpg") 

## Name 
Names <- lapply(imgsL, function(x) str_split(x, "/")) %>% 
            lapply(., function(x) str_subset(unlist(x), ".jpg") %>% 
                     str_replace(".jpg","")) 

## Dates
Dates <- input[[1]][[6]] %>% str_match_all("'.+'") %>% unlist() %>% str_replace_all("'","")




