#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

source("Background.R")

Month2Dates<-as.list(1:12)
names(Month2Dates)<-format(ISOdate(2018,1:12,1),"%B")

startIndex <- which(names(MoviePassSchedule) %in% paste0(Month2Dates[[months(Sys.Date())]],"/", day(Sys.Date())) )
tabNames <- paste0(weekdays(Sys.Date()+0:(length(MoviePassSchedule)-startIndex), TRUE),", ",names(MoviePassSchedule)[-c(1:(startIndex-1))])
# grab the movie lists from the MoviePass.com
MovieTables <- lapply(startIndex:length(MoviePassSchedule), function(i)(MovieNameID_Day<-left_join(MovieNameID[which(rownames(MovieNameID) %in% MoviePassSchedule[[i]]),], 
                                                                                                   MovieRatings, by=c("imdbID"="tconst")) %>% arrange(desc(averageRating))))

ui <- fluidPage(
  titlePanel(
    fluidRow(
      column(9,

             img(src = "moviepass_icon.png", height = 92, width = 500), offset = 1) 
    )
  ),
  
  fluidRow(#div(style = "height:80px;background-color: white;", ""),
      column(3, 
             offset=1,
             p(strong("MoviePass"), "only allows you to watch a few movies. Don't worry!!! We've got you covered. You can instantaneously 
               know",strong("when and where")," to watch the highest-rated movies by IMDb near your neighborhood."),
             
             imageOutput("poster", inline = TRUE)

      ),
    
      column(4,
        do.call(tabsetPanel, c(id = 'Dates', lapply(1:length(MovieTables), function(i){
          tabPanel(tabNames[i], 
                   DT::dataTableOutput(paste0('day',i), width = "100%"))
        })))
      ),
      
      column(4,

             textInput("zip", h4("Location"),
                       value = "91803"),
             
             sliderInput("number", h4("Number of nearby theaters"),
                         min = 0, max = 5, value = "2"), 
             
             actionButton("goButton", "Go!"),
             
             br(),
             br(),
             
             # uiOutput("nText")
             uiOutput("MovieScheduleLocation", inline = TRUE)
     )
  )
)



# Define server logic ----
server <- function(input, output) {
  

    lapply(1:length(MovieTables), function(i){
      output[[paste0('day',i)]]<- DT::renderDataTable({DT::datatable(MovieTables[[i]][,-(2:3)], rownames = NULL, selection="single",
                                                                     options = list(pageLength = 20, paging=FALSE,searching = FALSE),
                      colnames = c("Title","IMDb Ratings","IMDb Voters"))
      }, server = TRUE)
      
    })
    
    #output$text <- renderText({paste0("You are viewing tab \"", input$Dates, "\"")})
  
    
    output$poster <- renderImage({
      #index <- get(paste0('input$day',1:length(MovieTables),"_rows_selected"))
      #index <- c(input$day1_rows_selected, input$day2_rows_selected)
      if(is.null(input$day1_rows_selected)==TRUE){
        list(src=paste0("www/",MovieTables[[which(tabNames == input$Dates)]][1,"imdbID"],".jpg"),
             width = 420,
             height = 560) 
      }else{
        list(src=paste0("www/",MovieTables[[which(tabNames == input$Dates)]][input[[paste0('day',which(tabNames == input$Dates),"_rows_selected")]],"imdbID"],".jpg"),
               width = 420,
               height = 560)
      }

    } ,deleteFile = FALSE)
    
    ntext <- eventReactive(input$goButton, {
        if(is.null(input[[paste0('day',which(tabNames == input$Dates),"_rows_selected")]])==TRUE){
          "Select a movie!"
        }else{
          withProgress(message = 'Searching', value = 0, {
            # Number of times we'll go through the loop
            n <- 100
            
            for (i in 1:n) {
              # Each time through the loop, add another row of data. This is
              # a stand-in for a long-running computation.
              # Increment the progress bar, and update the detail text.
              incProgress(1/n)
              
              # Pause for 0.1 seconds to simulate a long computation.
              Sys.sleep((1/(n:1))[i])}
          })
          
          AvailableSchedule <- GenerateTimeSchedule(MovieTables[[which(tabNames == input$Dates)]][input[[paste0('day',which(tabNames == input$Dates),"_rows_selected")]],"MovieNames"],
                                                    input$zip, input$number, strsplit(input$Dates, " ")[[1]][[2]]) 
          
          AvailableSchedule %>% print()
        }
      }

    )

    # output$nText <- renderUI({
    #   
    # })
    
    # lapply(1:(input$Movielength), function(i) {
    #   output[[paste0('b', i)]] <- renderUI({
    #     ntext()[[i]]
    #   })
    # })
    # 
    output$MovieScheduleLocation <-renderUI({
      HTML(paste0(ntext(), sep='<br/>'))
      

    })
    
    # output$nText <- renderPrint({
    #   input$submit
    # 
    #   withProgress(message = 'Searching', value = 0, {
    #     # Number of times we'll go through the loop
    #     n <- 100
    # 
    #     for (i in 1:n) {
    #       # Each time through the loop, add another row of data. This is
    #       # a stand-in for a long-running computation.
    #       # Increment the progress bar, and update the detail text.
    #       incProgress(1/n)
    # 
    #       # Pause for 0.1 seconds to simulate a long computation.
    #       Sys.sleep((1/(n:1))[i])
    #     }
    #   })
    # 
    # 
    #  GenerateTimeSchedule(MovieTables[[which(tabNames == input$Dates)]][input[[paste0('day',which(tabNames == input$Dates),"_rows_selected")]],"MovieNames"],
    #                          input$zip, input$number, strsplit(input$Dates, " ")[[1]][[2]])} %>% print()
    # 
    # )
    

    
}
  


# Run the app ----
shinyApp(ui = ui, server = server)
