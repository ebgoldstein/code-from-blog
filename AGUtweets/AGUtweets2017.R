
#download 2017 AGU twitter data from:
#Pikas, Christina (2018): American Geophysical Union Annual Meeting Tweets 2017. 
#figshare. Dataset. https://doi.org/10.6084/m9.figshare.5756514.v1 
library(tidyverse)
library(lubridate)
data <- read.csv("https://ndownloader.figshare.com/files/10141338")

#subset columns i want
datasubset <- select(data, from_user, time)

#reformat the column types and correct the timestamps
datasubset <- datasubset %>% mutate_at(vars(from_user), as.character)
datasubset <- datasubset %>% mutate_at(vars(time), dmy_hms)

#mean # of tweets/ person

#distribution of tweets per person 

#plot hourly tweets

#subset for Meeting dates
