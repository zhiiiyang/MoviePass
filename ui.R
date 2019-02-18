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
load("data/MovieTables.rdata")
load("data/MovieNameDates.rdata")

tabNames <- Dates

ui <- fluidPage(
  titlePanel(
    fluidRow(
      column(9,

             img(src = "moviepass_icon.png", height = 92, width = 500), offset = 1) 
    )
  ),
  
  fluidRow(#div(style = "height:80px;background-color: white;", ""),
      # column(3, 
      #        offset=1,
      #        p(strong("MoviePass"), "only allows you to watch a few movies per day. Don't worry!!! We've got you covered. You can instantaneously 
      #          know",strong("when and where")," to watch the highest-rated movies by IMDb near your neighborhood."),
      #        
      #        imageOutput("poster", inline = TRUE)
      # 
      # ),
    
      column(4,
        do.call(tabsetPanel, c(id = 'Dates', lapply(1:length(MovieTables), function(i){
          tabPanel(tabNames[i],
                   DT::dataTableOutput(paste0('day',i), width = "100%"))
        })))
      )#,
      
     #  column(4,
     # 
     #         textInput("zip", h4("Please enter your Zipcode:"),
     #                   value = "91803"),
     #         
     #         sliderInput("number", h4("Number of nearby theaters:"),
     #                     min = 0, max = 5, value = "2"), 
     #         
     #         actionButton("goButton", "Go!"),
     #         
     #         br(),
     #         br(),
     #         
     #         # uiOutput("nText")
     #         uiOutput("MovieScheduleLocation", inline = TRUE)
     # )
  )
)


  
#ensure mobile support(fix the column) 
#double click
#fix the tab name too

# Run the app ----
shinyApp(ui = ui, server = server)
