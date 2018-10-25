library(tm)

con <- file("final/en_US/en_US.twitter.txt", "r") 
twitter <- readLines(con,1000) 
close(con)

con <- file("final/en_US/en_US.blogs.txt", "r") 
blogs <- readLines(con) 
close(con)

con <- file("final/en_US/en_US.news.txt", "r") 
news <- readLines(con) 
close(con)

sort(nchar(twitter), decreasing = TRUE)[1]
sort(nchar(blogs), decreasing = TRUE)[1]
sort(nchar(news), decreasing = TRUE)[1]

#review_text <- paste(data, collapse = " ")
#review_text <- gsub('[“]', "", review_text)
#review_text <- gsub('[”]', "", review_text)

sum(grepl("love", twitter)) / sum(grepl("hate", twitter))

twitter[grepl("biostats", twitter) == TRUE]

sum(grepl("A computer once beat me at chess, but it was no match for me at kickboxing", twitter))