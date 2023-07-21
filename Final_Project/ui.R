#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Next Word Prediction"),
  h6("it may take several seconds"),
  
  # Sidebar with a slider input for number of n gram
  sidebarLayout(
    sidebarPanel(
      
      sliderInput(
        inputId =  "Ngram", 
        label = "Select N for Ngram:", 
        min = 1,
        max = 20,
        value = 3,
        step = 1
      ),
      textInput("inputString", "Enter a partial sentence here",value = "it is one of the"),
      submitButton("Submit", icon("refresh"))
      
    ),
    mainPanel(
      h2("Predicted Next Word"),
      strong("Sentence Input:"),
      tags$style(type='text/css', '#text1 {background-color: rgba(255,255,0,0.40); color: blue;}'), 
      textOutput('text1'),
      br(),
      strong("Sentences with Next Word Candidates:"),
      textOutput("prediction"),
      br(),
      strong("Note:"),
      tags$style(type='text/css', '#text2 {background-color: rgba(255,255,0,0.40); color: black;}'),
      textOutput('text2')
    )
  )
))