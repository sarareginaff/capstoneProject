library(RWeka)
library(tm)
library(filehash)
library(tidyr)

# Get data
#con <- file("final/en_US/en_US.twitter.txt", "r") 
#twitter <- readLines(con) 
#close(con)

#con <- file("final/en_US/en_US.blogs.txt", "r") 
#blogs <- readLines(con) 
#close(con)

# fez ate 135001
con <- file("final/en_US/en_US.news.txt", "r") 
news <- readLines(con,1000) 
close(con)

# Filtering
download.file("https://www.cs.cmu.edu/~biglou/resources/bad-words.txt", "profane");
profane <- read.table("profane")

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))

removeSpecialChars <- function(x) gsub("[^a-zA-Z0-9 ]","",x)

newsTemp <- news

for (i in seq(1, length(newsTemp), by=500)) {
  if (i - 500 > 0)
  {
    news <- newsTemp[i-500:i]
    
    #twitterCorpus <- Corpus(VectorSource(twitter), 
    #                  readerControl = list(language = "en"))
    #                  #dbControl = list(dbName = "pcorpus.db", dbType = "DB1"))
    #twitterCorpus <- tm_map(twitterCorpus, removePunctuation)
    #twitterCorpus <- tm_map(twitterCorpus, content_transformer(tolower))
    #twitterCorpus <- tm_map(twitterCorpus, removeWords, profane$V1)
    #twitterCorpus <- tm_map(twitterCorpus, toSpace, "/")
    #twitterCorpus <- tm_map(twitterCorpus, toSpace, "@")
    #twitterCorpus <- tm_map(twitterCorpus, toSpace, "\\|")
    #twitterCorpus <- tm_map(twitterCorpus, removeNumbers)
    #twitterCorpus <- tm_map(twitterCorpus, removeWords, stopwords("english"))
    #twitterCorpus <- tm_map(twitterCorpus, stripWhitespace)
    #twitterCorpus <- tm_map(twitterCorpus, function(x) iconv(x, to = "ASCII//TRANSLIT"))
    #twitterCorpus <- tm_map(twitterCorpus, removeSpecialChars)
    
    
    #blogsCorpus <- Corpus(VectorSource(blogs), 
    #                        readerControl = list(language = "en"))
    ##dbControl = list(dbName = "pcorpus.db", dbType = "DB1"))
    #blogsCorpus <- tm_map(blogsCorpus, removePunctuation)
    #blogsCorpus <- tm_map(blogsCorpus, content_transformer(tolower))
    #blogsCorpus <- tm_map(blogsCorpus, removeWords, profane$V1)
    #blogsCorpus <- tm_map(blogsCorpus, toSpace, "/")
    #blogsCorpus <- tm_map(blogsCorpus, toSpace, "@")
    #blogsCorpus <- tm_map(blogsCorpus, toSpace, "'")
    #blogsCorpus <- tm_map(blogsCorpus, toSpace, "\\|")
    #blogsCorpus <- tm_map(blogsCorpus, removeNumbers)
    #blogsCorpus <- tm_map(blogsCorpus, removeWords, stopwords("english"))
    #blogsCorpus <- tm_map(blogsCorpus, stripWhitespace)
    #blogsCorpus <- tm_map(blogsCorpus, function(x) iconv(x, to = "ASCII//TRANSLIT"))
    #blogsCorpus <- tm_map(blogsCorpus, removeSpecialChars)
    
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
    newsCorpus <- tm_map(newsCorpus, removeWords, stopwords("english"))
    newsCorpus <- tm_map(newsCorpus, stripWhitespace)
    newsCorpus <- tm_map(newsCorpus, function(x) iconv(x, to = "ASCII//TRANSLIT"))
    newsCorpus <- tm_map(newsCorpus, removeSpecialChars)
    
    
    # Merge data sets
    #generalCorpus <- c(twitterCorpus, blogsCorpus, newsCorpus)
    generalCorpus <- newsCorpus
    # Build n-grams
    min_freq <- 1
    
    # 2-grams 
    token_2 <- NGramTokenizer(generalCorpus, Weka_control(min=2,max=2, delimiters = " \\t\\r\\n.!?,;\"()"))
    two_word <- data.frame(table(token_2))
    two_word <- separate(two_word, token_2, cbind("word_1", "word_2"), sep = " ", remove = TRUE, convert = FALSE)
    colnames(two_word) <- c("previous_words", "last_word", "frequency")
    two_word$frequency = as.numeric(two_word$frequency)
    two_word <- two_word[order(two_word$frequency,decreasing=TRUE),]
    two_word <- two_word[two_word$frequency >= min_freq,]
    
    
    # 3-grams
    token_3 <- NGramTokenizer(generalCorpus, Weka_control(min=3,max=3, delimiters = " \\t\\r\\n.!?,;\"()"))
    three_word <- data.frame(table(token_3))
    three_word <- separate(three_word, token_3, cbind("word_1", "word_2", "word_3"), sep = " ", remove = TRUE, convert = FALSE)
    three_word$word_12 <- paste(three_word$word_1,three_word$word_2,sep=" ")
    three_word <- as.data.frame(cbind(three_word$word_12, three_word$word_3, three_word$Freq))
    colnames(three_word) <- c("previous_words", "last_word", "frequency")
    three_word$frequency = as.numeric(three_word$frequency)
    three_word <- three_word[order(three_word$frequency,decreasing=TRUE),]
    three_word <- three_word[three_word$frequency >= min_freq,]
    
    # 4-grams
    token_4 <- NGramTokenizer(generalCorpus, Weka_control(min=4,max=4, delimiters = " \\t\\r\\n.!?,;\"()"))
    four_word <- data.frame(table(token_4))
    four_word <- separate(four_word, token_4, cbind("word_1", "word_2", "word_3", "word_4"), sep = " ", remove = TRUE, convert = FALSE)
    four_word$word_123 <- paste(four_word$word_1,four_word$word_2,four_word$word_3,sep=" ")
    four_word <- as.data.frame(cbind(four_word$word_123, four_word$word_4, four_word$Freq))
    colnames(four_word) <- c("previous_words", "last_word", "frequency")
    four_word$frequency = as.numeric(four_word$frequency)
    four_word <- four_word[order(four_word$frequency,decreasing=TRUE),]
    four_word <- four_word[four_word$frequency >= min_freq,]
    
    if (exists("two_word_temp"))
      two_word_temp <- merge(two_word,two_word_temp, all=T)
    else
      two_word_temp <- two_word
    
    if (exists("three_word_temp"))
      three_word_temp <- merge(three_word, three_word_temp, all=T)
    else
      three_word_temp <- three_word
    
    if (exists("four_word_temp"))
      four_word_temp <- merge(four_word, four_word_temp, all=T)
    else
      four_word_temp <- four_word
  }
}