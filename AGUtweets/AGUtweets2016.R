#2016 AGU twitter data from:
#Pikas, Christina (2016): American Geophysical Union Fall Meeting 2016 Tweets. 
#figshare. Dataset.figshare. Dataset. https://doi.org/10.6084/m9.figshare.4497395.v1 

#there seems to be a gap in the data at the beginning of the meeting, from Dec 10 to Dec 13th

library(tidyverse)
library(lubridate)
#download data
data <- read_csv("https://ndownloader.figshare.com/files/7267175")

#correct the timestamps
data <- data  %>% mutate_at(vars(time), dmy_hms)

#UTC to US central time
attributes(data$time)$tzone <- "US/Pacific" 

#subset for Meeting dates
dataM <- filter(data, time >= "2016-12-10 00:00:00", time <= "2016-12-17 00:00:00")

#plot hourly tweets during the week
ggplot(dataM, aes(x=time)) +
  geom_histogram(bins = 168)  + 
  labs(x= "Day", y = "Tweets/Hr") +
  labs(title = "Hourly #AGU16 Tweets During the Meeting")
ggsave("Hourly16.pdf")

#subset and plot  just theAGU tweets 
dataMA <- filter(dataM, from_user == "theAGU")

ggplot(dataMA, aes(x=time)) +
  geom_histogram(bins = 168)  + 
  labs(x= "Day", y = "Tweets/Hr") +
  labs(title = "Hourly @theAGU #AGU16 Tweets During the Meeting")
ggsave("Hourly16AGU.pdf")

# subset and plot all nonAGU tweets
dataMNA <- filter(dataM, from_user != "theAGU")

ggplot(dataMNA, aes(x=time)) +
  geom_histogram(bins = 168)  + 
  labs(x= "Day", y = "Tweets/Hr") +
  labs(title = "Hourly non-@theAGU #AGU16 Tweets During the Meeting")
ggsave("Hourly16NonAGU.pdf")

#remove RTs from meeting subset and plot those
dataMnRT <- filter(dataM, !grepl('RT @', text))

ggplot(dataMnRT, aes(x=time)) +
  geom_histogram(bins = 168)  + 
  labs(x= "Day", y = "Tweets/Hr")  +
  labs(title = "Hourly #AGU16 Tweets (no RTs) During the Meeting")
ggsave("Hourly16NoRT.pdf")