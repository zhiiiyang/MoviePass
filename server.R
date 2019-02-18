

# Define server logic ----
server <- function(input, output) {
  
  
  lapply(1:length(MovieTables), function(i){
    output[[paste0('day',i)]]<- DT::renderDataTable({DT::datatable(MovieTables[[i]][,-(2:3)], rownames = NULL, selection="single",
                                                                   options = list(pageLength = 20, paging=FALSE,searching = FALSE),
                                                                   colnames = c("Title","IMDb Ratings","IMDb Voters"))
    }, server = TRUE)
    
  })
  
  #output$text <- renderText({paste0("You are viewing tab \"", input$Dates, "\"")})
  
  
  # output$poster <- renderImage({
  #   #index <- get(paste0('input$day',1:length(MovieTables),"_rows_selected"))
  #   #index <- c(input$day1_rows_selected, input$day2_rows_selected)
  #   if(is.null(input$day1_rows_selected)==TRUE){
  #     list(src=paste0("www/",MovieTables[[which(tabNames == input$Dates)]][1,"imdbID"],".jpg"),
  #          width = 420,
  #          height = 560) 
  #   }else{
  #     list(src=paste0("www/",MovieTables[[which(tabNames == input$Dates)]][input[[paste0('day',which(tabNames == input$Dates),"_rows_selected")]],"imdbID"],".jpg"),
  #          width = 420,
  #          height = 560)
  #   }
  #   
  # } ,deleteFile = FALSE)
  
  # ntext <- eventReactive(input$goButton, {
  #   if(is.null(input[[paste0('day',which(tabNames == input$Dates),"_rows_selected")]])==TRUE){
  #     "Please select a movie on the left first."
  #   }else{
  #     withProgress(message = 'Searching', value = 0, {
  #       # Number of times we'll go through the loop
  #       n <- 100
  #       
  #       for (i in 1:n) {
  #         # Each time through the loop, add another row of data. This is
  #         # a stand-in for a long-running computation.
  #         # Increment the progress bar, and update the detail text.
  #         incProgress(1/n)
  #         
  #         # Pause for 0.1 seconds to simulate a long computation.
  #         Sys.sleep((1/(n:1))[i])}
  #     })
  #     
  #     AvailableSchedule <- GenerateTimeSchedule(MovieTables[[which(tabNames == input$Dates)]][input[[paste0('day',which(tabNames == input$Dates),"_rows_selected")]],"MovieNames"],
  #                                               input$zip, input$number, strsplit(input$Dates, " ")[[1]][[2]]) 
  #     
  #     AvailableSchedule %>% print()
  #   }
  # }
  # 
  # )
  
  
  # output$MovieScheduleLocation <-renderUI({
  #   HTML(paste0(ntext(), sep='<br/>'))
  # })
  
  # rsconnect::deployApp('path/to/your/app')
  
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