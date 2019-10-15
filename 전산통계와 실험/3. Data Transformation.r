library(nycflights13)
library(tidyverse)

head(flights)
dim(flights)
?dim
a<-flights

## dplyr basics 

# filter() : 특정 행 골라냄, arrange() : 행 재배열
# select() : 특정 열 골라냄
# mutate() : 변수 만듦, summarise() : 실습해보길

jan1 <- filter(flights, month == 1, day == 1)
  # 1월 1일에 해당하는 행만 뽑아냄.

sqrt(2)^2 == 2
1/49 * 49 == 1
# floating point error : 유효숫자까지만 표기함.
c <- sqrt(2)
c^2 == sqrt(2)^2

near(sqrt(2)^2, 2); near(1/49 * 49, 1)
  # == 대신 근삿값으로 비교하자

flightsNovDec <- filter(flights, month == 11 | month == 12)
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)
  # 밑에 두개 결과 같음
  # &&나 || 쓰지 말길...


## Missing values : NA(결측값이 의미를 가질 때도 있다!!)
NA > 5; 10 == NA
x <- NA; y <- NA; x == y; is.na(x)

df <- tibble(x = c(1, NA, 3, 5))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)


## Arrange rows with arrange()
tmp <- arrange(flights, year, month, day)
tmp <- arrange(flights, desc(arr_delay))
head(tmp)
df <- tibble(x = c(5, 2, NA))
arrange(df, x); arrange(df, desc(x))


## Select columns with select()
tmp <- select(flights, year, month, day); head(tmp)
tmp <- select(flights, year:dep_time); head(tmp)
  # year부터 dep_time 열까지만 선택
tmp <- select(flights, -(year:day)); head(tmp)
tmp <- select(flights, seq(1, 10, by = 2))
  # 1,3,5,7,9열 선택
tmp <- select(flights, time_hour, air_time, everything()); head(tmp)
  # 선택한 변수를 앞에 제시함.
tmp <- rename(flights, yr = year); head(tmp)
  # 변수명 바꾸기


## Add new variables with mutate()
flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
head(flights_sml)
  # starts_with(), ends_with(), contains()
tmp <- mutate(flights_sml, gain = arr_delay - dep_delay, speed = distance / air_time * 60)
head(tmp)

tmp <- transmute(flights, gain = arr_delay - dep_delay, hours = air_time / 60); head(tmp)
  # transmute()를 통해 새로 만든 변수만 따로 빼낼 수 있음.
tmp <- transmute(flights,
                 dep_time,
                 hour = dep_time %/% 100,  # why divide by 100?
                 minute = dep_time %% 100); head(tmp)
  # %/%는 몫, %%는 나머지
(x <- 1:10)
lag(x)  # 오른쪽으로 한 칸 밀기
lead(x) # 왼쪽으로 한 칸 땡기기
cumsum(x); cummean(x)

y <- c(1, 2, 2, NA, 3, 4)
min_rank(y); min_rank(desc(y))


## Grouped summaries with summarise() : 월별 통계, 일별 통계 등등 
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))
  # 같은 날짜로 묶어놓은 by_day에서 하루 평균 dep_delay 구함


## Pipe : %>% 데이터의 흐름! 익숙해지자.
by_dest <- group_by(flights, dest) # 목적지 별로 묶음
delay <- summarise(by_dest,
                   count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE))
(delay <- filter(delay, count > 20, dest != "HNL"))

(
  delays <- flights %>% 
    group_by(dest) %>% 
    summarise(
      count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE) ) %>% 
    filter(count > 20, dest != "HNL")
)

not_cancelled <- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))


## Grouped filters
flights %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)
  # arr_delay가 큰 순서대로 9개 골라냄

popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 10000 )
  # 행을 목적지별로 묶고 count가 10000이 넘는 것만 표시.
dim(popular_dests)

