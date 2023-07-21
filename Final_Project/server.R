library(shiny)
library(stringr)
library(tm)
library(RWeka)
library(purrr)
source('getting-cleaning data.R')
corpus <- readRDS('corpus.RData')

BackoffModels <- function(n){
  BackoffModel <<- list()
  for(i in 2:n){
    BackoffModel[[paste(i,"grams")]] <<- createNgrams(corpus,i)
  }
}

createNgrams <- function(text, n){ 
  ngram <- function(x) NGramTokenizer(x, Weka_control(min = n, max = n))
  ngrams <- TermDocumentMatrix(text, control = list(tokenize = ngram))
  ngrams_freq <- rowSums(as.matrix(ngrams))
  ngrams_freq <- sort(ngrams_freq, decreasing = TRUE)
  ngrams_freq_df <- data.frame(word = names(ngrams_freq), freq=ngrams_freq)
  
  ngrams_freq_df
  
}

extractLowerGram <- function(x,n){
  
  x <- strsplit(as.character(x), ' ' )
  x <- head(x[[1]],n-1)
  x <- paste(x,collapse = ' ' )
  x
}
predict <- function(x,n) {
  xs <- stripWhitespace(stemDocument(removePunctuation(tolower(removeNumbers(x)))))
  
  # Back Off Algorithm
  # Predict the next term of the user input sentence
  # 1. For prediction of the next word, Quadgram is first used (first three words of Quadgram are the last three words of the user provided sentence).
  # 2. If no Quadgram is found, back off to Trigram (first two words of Trigram are the last two words of the sentence).
  # 3. If no Trigram is found, back off to Bigram (first word of Bigram is the last word of the sentence)
  # 4. If no Bigram is found, back off to the most common word with highest frequency 'the' is returned.
  
  if(n > length(strsplit(xs,' ')[[1]])){
    n <- length(strsplit(xs,' ')[[1]])
    n <- n+1
  }
  
  if( n >= 2){
    xs <- strsplit(xs, ' ' )
    xs <- tail(xs[[1]],n-1)
    xs <- paste(xs,collapse = ' ' )
  }
  currentModel <- BackoffModel[[paste(n,"grams")]]
  
  currentModel$lowerGram <- lapply(currentModel[['word']],extractLowerGram,n)
  
  matchList <- currentModel[currentModel$lowerGram == xs,]
  
  if(dim(matchList)[1] != 0){
    candidateList <- head(as.character(matchList[['word']]),3)
    candidateList <- lapply(candidateList,function(x){tail(strsplit(x[[1]]," "),1)[[1]][[n]]})
    mesg <<- paste("Next word is predicted using ",n,"gram.")
    candidateList
  }
  else if(n == 2){
    mesg<<- "No Matches Found"
  }
  else{
    predict(xs,n-1)
  }
}



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$prediction <- renderText({
    BackoffModels(input$Ngram)
    result <- predict(input$inputString,input$Ngram)
    output$text2 <- renderText({mesg})
    paste(input$inputString,result,',')
  });
  output$text1 <- renderText({input$inputString});
})
