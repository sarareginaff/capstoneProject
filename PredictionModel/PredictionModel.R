library(RWeka)
library(tm)
library(filehash)
library(tidyr)

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))

removeSpecialChars <- function(x) gsub("[^a-zA-Z0-9 ]","",x)

download.file("https://www.cs.cmu.edu/~biglou/resources/bad-words.txt", "profane");
profane <- read.table("profane")

# Build function
predictNextWord <- function(sentence){
  sentence <- tolower(sentence)
  sentence <- removePunctuation(sentence)
  sentence <- removeWords(sentence, profane$V1)
  sentence <- gsub("/", " ", sentence)
  sentence <- gsub("@", " ", sentence)
  sentence <- gsub("'", " ", sentence)
  sentence <- gsub("\\|", " ", sentence)
  sentence <- removeNumbers(sentence)
  sentence <- removeWords(sentence, stopwords("english"))
  sentence <- stripWhitespace(sentence)
  sentence <- gsub("[^a-zA-Z0-9 ]","",sentence)
  sentence
  predictedWord <- ""
  splitWords <- as.array(strsplit(sentence, " ")[[1]])
  numWords <- length(splitWords)

  if (numWords > 2)
  {
    splitWords <- splitWords[-(1:(numWords-2))]
    numWords <- length(splitWords)
  }
  
  while (predictedWord == "" && numWords > 0) {
    if (numWords == 2){
      equalPreviousWords <- three_word[three_word$previous_words == paste(splitWords[1],splitWords[2],sep=" "),]
    } else if (numWords == 1){
      equalPreviousWords <- two_word[two_word$previous_words == splitWords[1],]
    }
    equalPreviousWords <- equalPreviousWords[order(equalPreviousWords$frequency,decreasing=TRUE),]
    if (nrow(equalPreviousWords) > 0)
    {
      predictedWord <- equalPreviousWords
      #predictedWord <- predictedWord[predictedWord$frequency,]
      predictedWord <- predictedWord[order(predictedWord$frequency,decreasing=TRUE),]
      predictedWord <- predictedWord$last_word[1:3]
    }
    else
    { 
      if (numWords > 1)
      {
        splitWords <- splitWords[-(1:(numWords-1))]
        numWords <- length(splitWords)
      } else
      {
        numWords <- 0
        predictedWord <- two_word$last_word[1]
      }
    }
  }
  
  predictedWord
}
