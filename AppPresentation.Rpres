Predict Next Word App
========================================================
author: Sara Regina Ferreira de Faria
date: 2019, February 16th
autosize: true

The situation
========================================================

Around the world, people are spending an increasing amount of time on their mobile devices for email, social networking, banking and a whole range of other activities. 

But typing on mobile devices can take several minutes and be a serious pain. 

So our solution is to build a system that makes it easier for people to type on their mobile devices. 

***

We will use the computer processing capabilitty to build a smart solution that help you to predict the next word you want to type!

***

<div> <img src="images/cellphones.png"></img> </div>


Studying the data
========================================================

<small>We've got 556MB of data from blogs, twitter and news written in English. </small>

<small> After cleaning the data (removing the stop words, the ponctuations, the number, the profane words, etc.), we made several studies to understand the data we were dealing with. </small>

<div style="margin-left:75px; max-width:280px"> <img src="images/wordcloud.PNG"></img> </div>


***

<small>The common steps in natural language processing are:</small>

- <small>**Lexical Analysis**: identifying and analyzing the structure of words.</small>

- <small>**Syntactic Analysis**: to arrange the words in a manner that shows the relationship among them.</small>

- <small>**Semantic Analysis**: in this phase, the meaning of the single phrase is analysed.</small>

- <small>**Discourse Integration**: now the meaning of the hole text is analysed.</small>


The Algorithm
========================================================

<small>First of all, the data was prepared to be used by the prediction model. All the texts were splitted in 2-grams, 3-grams and 4-grams.</small>

<small>The algorithm to predict the next word the user wants to type follow this steps:</small>

- <small>The input prhase is treated the same way the whole dataset was (removing the stop words, the ponctuations, the number, the profane words, etc.)</small>

- <small>It takes the last three words and search for it the 4-grams. </small>

***

- <small>If the combination of three words was not found in the 4-grams, it looks for the last two words in the 3-grams. </small>

- <small>If the combination of two words was not found in the 3-grams, it looks for the last word in the 2-grams. </small>

<small>If the n-gram is found in any of these situations, the most common next word is displayed to the user as the predicted words. If teven thought any word is found, it suggests the most common word as the predicted one.</small>


How can you test it?
========================================================

The simplest way to test this algorithm is using a Shiny App. You can access it in this link (it may take some seconds to open):

[Shiny App to Test](https://sarareginaff.shinyapps.io/predictionmodel/)


To use it you have to type the wanted phrase and wait a second so the app will display the suggested word to be the next one in the phrase.

<div style="margin-left:350px"> <img src="shinyAppPrint.PNG"></img> </div>

<div style="font-weight:bold; color:red;position: fixed;">Enjoy it!</div>

