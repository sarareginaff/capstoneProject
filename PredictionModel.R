library(tm)
library(filehash)

# Get data
con <- file("final/en_US/en_US.twitter.txt", "r") 
twitter <- readLines(con,10000) 
close(con)

con <- file("final/en_US/en_US.blogs.txt", "r") 
blogs <- readLines(con,1000) 
close(con)

con <- file("final/en_US/en_US.news.txt", "r") 
news <- readLines(con,1000) 
close(con)

# Filtering
download.file("https://www.cs.cmu.edu/~biglou/resources/bad-words.txt", "profane");
profane <- read.table("profane")

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))

removeSpecialChars <- function(x) gsub("[^a-zA-Z0-9 ]","",x)

twitterCorpus <- Corpus(VectorSource(twitter), 
                  readerControl = list(language = "en"))
                  #dbControl = list(dbName = "pcorpus.db", dbType = "DB1"))
twitterCorpus <- tm_map(twitterCorpus, removePunctuation)
twitterCorpus <- tm_map(twitterCorpus, content_transformer(tolower))
twitterCorpus <- tm_map(twitterCorpus, removeWords, profane$V1)
twitterCorpus <- tm_map(twitterCorpus, toSpace, "/")
twitterCorpus <- tm_map(twitterCorpus, toSpace, "@")
twitterCorpus <- tm_map(twitterCorpus, toSpace, "\\|")
twitterCorpus <- tm_map(twitterCorpus, removeNumbers)
#twitterCorpus <- tm_map(twitterCorpus, removeWords, stopwords("english"))
twitterCorpus <- tm_map(twitterCorpus, stripWhitespace)
twitterCorpus <- tm_map(twitterCorpus, function(x) iconv(x, to = "ASCII//TRANSLIT"))
twitterCorpus <- tm_map(twitterCorpus, removeSpecialChars)


blogsCorpus <- Corpus(VectorSource(blogs), 
                        readerControl = list(language = "en"))
#dbControl = list(dbName = "pcorpus.db", dbType = "DB1"))
blogsCorpus <- tm_map(blogsCorpus, removePunctuation)
blogsCorpus <- tm_map(blogsCorpus, content_transformer(tolower))
blogsCorpus <- tm_map(blogsCorpus, removeWords, profane$V1)
blogsCorpus <- tm_map(blogsCorpus, toSpace, "/")
blogsCorpus <- tm_map(blogsCorpus, toSpace, "@")
blogsCorpus <- tm_map(blogsCorpus, toSpace, "'")
blogsCorpus <- tm_map(blogsCorpus, toSpace, "\\|")
blogsCorpus <- tm_map(blogsCorpus, removeNumbers)
blogsCorpus <- tm_map(blogsCorpus, stripWhitespace)
blogsCorpus <- tm_map(blogsCorpus, function(x) iconv(x, to = "ASCII//TRANSLIT"))
blogsCorpus <- tm_map(blogsCorpus, removeSpecialChars)

newsCorpus <- Corpus(VectorSource(news), 
                      readerControl = list(language = "en"))
#dbControl = list(dbName = "pcorpus.db", dbType = "DB1"))
newsCorpus <- tm_map(newsCorpus, removePunctuation)
newsCorpus <- tm_map(newsCorpus, content_transformer(tolower))
newsCorpus <- tm_map(newsCorpus, removeWords, profane$V1)
newsCorpus <- tm_map(newsCorpus, toSpace, "/")
newsCorpus <- tm_map(newsCorpus, toSpace, "@")
newsCorpus <- tm_map(newsCorpus, toSpace, "'")
newsCorpus <- tm_map(newsCorpus, toSpace, "\\|")
newsCorpus <- tm_map(newsCorpus, removeNumbers)
newsCorpus <- tm_map(newsCorpus, stripWhitespace)
newsCorpus <- tm_map(newsCorpus, function(x) iconv(x, to = "ASCII//TRANSLIT"))
newsCorpus <- tm_map(newsCorpus, removeSpecialChars)

# Build n-grams

# Build function
predictNextWord <- function(sentence){
  predictedWord <- ""
  splitWords <- as.array(strsplit(sentence, " ")[[1]])
  numWords <- length(splitWords)
  
  if (numWords > 3)
  {
    splitWords <- splitWords[-(1:(numWords-3))]
    numWords <- length(splitWords)
  }
  
  while (predictedWord == "" && numWords > 0) {
    if (numWords == 3){
      equalPreviousWords <- four_word[four_word$previous_words == paste(splitWords[1],splitWords[2],splitWords[3],sep=" "),]
    } else if (numWords == 2){
      equalPreviousWords <- three_word[three_word$previous_words == paste(splitWords[1],splitWords[2],sep=" "),]
    } else if (numWords == 1){
      equalPreviousWords <- two_word[two_word$previous_words == splitWords[1],]
    }
    equalPreviousWords <- equalPreviousWords[order(equalPreviousWords$frequency,decreasing=TRUE),]
    if (nrow(equalPreviousWords) > 0)
    {
      predictedWord <- equalPreviousWords[1,]$last_word
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
      }
    }
  }
  
  predictedWord
}