#download 2017 AGU twitter data from:
#Pikas, Christina (2019): American Geophysical Union Annual Meeting Tweets 2018.
#figshare. Dataset. https://doi.org/10.6084/m9.figshare.7991927.v1
library(tidyverse)
library(lubridate)
library(tidytext)
AGUtweetdata <- read_csv("https://ndownloader.figshare.com/files/14884364")

#correct the timestamps
data <- AGUtweetdata  %>% mutate_at(vars(time), dmy_hms)

#UTC to US central time
attributes(data$time)$tzone <- "US/Eastern" 

#subset for Meeting dates
dataM <- filter(AGUtweetdata, time >= "2018-12-09 00:00:00", time <= "2018-12-17 00:00:00")

#plot hourly tweets during the week
ggplot(dataM, aes(x=time)) +
  geom_histogram(bins = 168)  + 
  labs(x= "Day", y = "Tweets/Hr") +
  labs(title = "Hourly #AGU18 Tweets During the Meeting")
ggsave("Hourly.pdf")

#subset and plot  just theAGU tweets 
dataMA <- filter(dataM, from_user == "theAGU")

ggplot(dataMA, aes(x=time)) +
  geom_histogram(bins = 168)  + 
  labs(x= "Day", y = "Tweets/Hr") +
  labs(title = "Hourly @theAGU #AGU18 Tweets During the Meeting")
ggsave("HourlyAGU.pdf")

# subset and plot all nonAGU tweets
dataMNA <- filter(dataM, from_user != "theAGU")

ggplot(dataMNA, aes(x=time)) +
  geom_histogram(bins = 168)  + 
  labs(x= "Day", y = "Tweets/Hr") +
  labs(title = "Hourly non-@theAGU #AGU18 Tweets During the Meeting")
ggsave("HourlyNonAGU.pdf")

#remove RTs from meeting subset and plot those
dataMnRT <- filter(dataM, !grepl('RT @', text))

ggplot(dataMnRT, aes(x=time)) +
  geom_histogram(bins = 168)  + 
  labs(x= "Day", y = "Tweets/Hr")  +
  labs(title = "Hourly #AGU18 Tweets (no RTs) During the Meeting")
ggsave("HourlyNoRT.pdf")

#break the words out of each tweet
#from tidytext book
replace_reg <- "https://t.co/[A-Za-z\\d]+|http://[A-Za-z\\d]+|&amp;|&lt;|&gt;|RT|https"
unnest_reg <- "([^A-Za-z_\\d#@']|'(?![A-Za-z_\\d#@]))"
tidy_tweets <- dataMNA %>% 
  filter(!str_detect(text, "^RT")) %>%
  mutate(text = str_replace_all(text, replace_reg, "")) %>%
  unnest_tokens(word, text, token = "regex", pattern = unnest_reg) %>%
  filter(!word %in% stop_words$word,
         str_detect(word, "[a-z]"))

#all word freq for dataMNA dataset
frequency <- tidy_tweets %>%
  count(word,sort = TRUE) 

#filter for the top 15 words
filtered_tidy_tweets <- filter(tidy_tweets, word %in% frequency$word[1:15])

#plot top words 15 words, but by day..
# add column for 'days'
tidy_tweets_days  <- mutate(filtered_tidy_tweets,Dec = mday(filtered_tidy_tweets$time))

#all word freq for dataMNA dataset grouped by day
frequency_day <- tidy_tweets_days %>%
  group_by(Dec) %>%
  count(word,sort = TRUE) 

#make a plot of use of top words (from freq) by day.
ggplot(data=tidy_tweets_days, aes(x=Dec)) + 
  geom_line(stat='count') + 
  facet_wrap(~ word, nrow = 5, scales="free_y")

#bar plot
tidy_tweets %>%
count(word, sort = TRUE) %>%
  filter(n > 200) %>%
  mutate(word = reorder(word,n)) %>%
  ggplot(aes(word,n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
