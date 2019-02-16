#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

two_word <- readRDS("two_word.rds")
three_word <- readRDS("three_word.rds")

source("PredictionModel.R",local = TRUE)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
  
  # Application title
  titlePanel("Predict Next Word"),
  
  # Sidebar with a place to write the wanted phrase
  sidebarLayout(
    sidebarPanel(
      textInput("phrase",
                "Input Phrase:")
    ),
    
    # Show the three predicted Words
    mainPanel(
      h4("Predicted word:"),
      textOutput("predictedWords")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$predictedWords <- renderText({
    predictedWords   <- predictNextWord(input$phrase)
    
    predictedWords[1]
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

