
#download 2017 AGU twitter data from:
#Pikas, Christina (2018): American Geophysical Union Annual Meeting Tweets 2017. 
#figshare. Dataset. https://doi.org/10.6084/m9.figshare.5756514.v1 
library(tidyverse)
library(lubridate)
data <- read_csv("https://ndownloader.figshare.com/files/10141338")

#correct the timestamps
data <- data  %>% mutate_at(vars(time), dmy_hms)

#UTC to US central time
attributes(data$time)$tzone <- "US/Central" 

#subset for Meeting dates
dataM <- filter(data, time >= "2017-12-10 00:00:00", time <= "2017-12-17 00:00:00")

#plot hourly tweets during the week
ggplot(dataM, aes(x=time)) +
  geom_histogram(bins = 168)  + 
  labs(x= "Day", y = "Tweets/Hr") +
  labs(title = "Hourly #AGU17 Tweets During the Meeting")
ggsave("Hourly.pdf")

#subset and plot  just theAGU tweets 
dataMA <- filter(dataM, from_user == "theAGU")

ggplot(dataMA, aes(x=time)) +
  geom_histogram(bins = 168)  + 
  labs(x= "Day", y = "Tweets/Hr") +
  labs(title = "Hourly @theAGU #AGU17 Tweets During the Meeting")
ggsave("HourlyAGU.pdf")

# subset and plot all nonAGU tweets
dataMNA <- filter(dataM, from_user != "theAGU")

ggplot(dataMNA, aes(x=time)) +
  geom_histogram(bins = 168)  + 
  labs(x= "Day", y = "Tweets/Hr") +
  labs(title = "Hourly non-@theAGU #AGU17 Tweets During the Meeting")
ggsave("HourlyNonAGU.pdf")

#remove RTs from meeting subset and plot those
dataMnRT <- filter(dataM, !grepl('RT @', text))

ggplot(dataMnRT, aes(x=time)) +
  geom_histogram(bins = 168)  + 
  labs(x= "Day", y = "Tweets/Hr")  +
  labs(title = "Hourly #AGU17 Tweets (no RTs) During the Meeting")
ggsave("HourlyNoRT.pdf")
