install.packages("nycflights13")
install.packages("Lahman")
install.packages("dplyr")

library(tidyverse)
library(dplyr)
library(tibble)
library(nycflights13)
library(Lahman)

filter(flights, month == 1, day == 1)
flightsJanDec <- filter(flights, month == 1 | month == 12)
head(flightsJanDec)

tmp <- select(flights, year, month, day)
head(tmp)

colnames(flights)

tmp <- select(flights, year:day, ends_with(("time")))

tmp <- select(flights, -starts_with(("sche")))
head(tmp)

dim(flights)[1]; dim(flights)[2]
tmp <- select(flights, 6, dim(flights)[2])
head(tmp)


# Group by
daily <- group_by(flights, year, month, day)
daily

summarize(flights, flights = n())

per_day <- summarize(daily, flights = n())
per_day

daily %>% 
  ungroup() %>%             # no longer grouped by date
  summarise(flights = n())


## Reordering
arrange(flights, year, month, day)
arrange(flights, desc(arr_delay))

x <- factor(letters)
arrange(tibble(x), desc(x))


## Mutate() vs Transmute()
flights_sml <- 
  select(flights, year:day, ends_with("delay"), distance, air_time) %>% 
  mutate(., gain = arr_delay - dep_delay,
         hours = air_time / 60, gain_per_hour = gain / hours )
head(flights_sml)

tmp <- select(flights, year:day, ends_with("delay"), distance, air_time) %>%
  transmute(., gain = arr_delay - dep_delay,
            hours = air_time / 60, gain_per_hour = gain / hours)
head(tmp)


## Summarize()
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
summarise(flights, delay = mean(dep_delay))

by_day <- group_by(flights, year, month, day) %>% 
  summarise(., delay = mean(dep_delay, na.rm = TRUE)) 
head(by_day)

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE) ) %>% 
  filter(count > 20, dest != "HNL")
head(delays)

ggplot(data = delays, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) + geom_smooth(se = FALSE)


not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 1)

batting <- as_tibble(Lahman::Batting)
head(batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )
head(batters)

batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() + 
  geom_smooth(se = FALSE)


flights_sml <- 
  select(flights, year:day, ends_with("delay"), distance, air_time)
flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 10000 )  #목적지가 105개 였는데 filter로 9개만 살아남음
popular_dests


## Missing Values : NA
x <- c(1,3,65,NA)
NA == NA

is.na(x); !is.na(x)
df <- tibble(x = c(1, NA, 3))  # tibble is a data frame
filter(df, x > 1)
filter(df, is.na(x) | x > 1)

tmp <- rename(flights, tail_num = tailnum)
head(tmp)



## Example
not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>%
  select(year:day, ends_with("dep_time"), ends_with("dep_delay"), dest) %>%
  mutate(sched_dep_hour = sched_dep_time %/% 100)
head(not_cancelled)

popular_flight <- not_cancelled %>%
  group_by(dest) %>% filter(n()>10000)

n_distinct(popular_flight$dest) # 데이터 중복된거 뺀 갯수
unique(popular_flight$dest) # 데이터 중복된거 뺀 것 나열
range(not_cancelled$sched_dep_hour)

recommend_times <- popular_flight %>%
  filter(month %in% c(6, 7, 8)) %>%
  filter(sched_dep_hour >= 9 & sched_dep_hour <= 15) %>%
  ungroup() %>%
  group_by(dest, year, month, day) %>% 
  arrange(dep_delay) %>%
  summarise(recommend_time=first(sched_dep_hour), delay=first(dep_delay))

recommend_times

recommend_times %>% group_by(recommend_time, dest) %>%
  summarize(m = mean(delay), sd = sd(delay),
            low_ci = m - 2*sd,
            high_ci = m + 2*sd,
            n = n()) %>%
  ggplot(aes(recommend_time, m, ymin = low_ci, ymax = high_ci)) +
  geom_pointrange() +
  facet_wrap(~ dest, nrow = 2)

recommend_times %>% group_by(dest, recommend_time) %>%
  summarise(mean_delay=mean(delay), count=n()) %>% 
  arrange(mean_delay) %>% 
  summarise(recommend_time=first(recommend_time), mean_delay=first(mean_delay))
