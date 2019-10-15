library(nycflights13)
library(tidyverse)

head(flights)
dim(flights)
?dim
a<-flights

## dplyr basics 

# filter() : Ư�� �� ���, arrange() : �� ��迭
# select() : Ư�� �� ���
# mutate() : ���� ����, summarise() : �ǽ��غ���

jan1 <- filter(flights, month == 1, day == 1)
  # 1�� 1�Ͽ� �ش��ϴ� �ุ �̾Ƴ�.

sqrt(2)^2 == 2
1/49 * 49 == 1
# floating point error : ��ȿ���ڱ����� ǥ����.
c <- sqrt(2)
c^2 == sqrt(2)^2

near(sqrt(2)^2, 2); near(1/49 * 49, 1)
  # == ��� �ٻ����� ������

flightsNovDec <- filter(flights, month == 11 | month == 12)
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)
  # �ؿ� �ΰ� ��� ����
  # &&�� || ���� ����...


## Missing values : NA(�������� �ǹ̸� ���� ���� �ִ�!!)
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
  # year���� dep_time �������� ����
tmp <- select(flights, -(year:day)); head(tmp)
tmp <- select(flights, seq(1, 10, by = 2))
  # 1,3,5,7,9�� ����
tmp <- select(flights, time_hour, air_time, everything()); head(tmp)
  # ������ ������ �տ� ������.
tmp <- rename(flights, yr = year); head(tmp)
  # ������ �ٲٱ�


## Add new variables with mutate()
flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
head(flights_sml)
  # starts_with(), ends_with(), contains()
tmp <- mutate(flights_sml, gain = arr_delay - dep_delay, speed = distance / air_time * 60)
head(tmp)

tmp <- transmute(flights, gain = arr_delay - dep_delay, hours = air_time / 60); head(tmp)
  # transmute()�� ���� ���� ���� ������ ���� ���� �� ����.
tmp <- transmute(flights,
                 dep_time,
                 hour = dep_time %/% 100,  # why divide by 100?
                 minute = dep_time %% 100); head(tmp)
  # %/%�� ��, %%�� ������
(x <- 1:10)
lag(x)  # ���������� �� ĭ �б�
lead(x) # �������� �� ĭ �����
cumsum(x); cummean(x)

y <- c(1, 2, 2, NA, 3, 4)
min_rank(y); min_rank(desc(y))


## Grouped summaries with summarise() : ���� ���, �Ϻ� ��� ��� 
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))
  # ���� ��¥�� ������� by_day���� �Ϸ� ��� dep_delay ����


## Pipe : %>% �������� �帧! �ͼ�������.
by_dest <- group_by(flights, dest) # ������ ���� ����
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
  # arr_delay�� ū ������� 9�� ���

popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 10000 )
  # ���� ���������� ���� count�� 10000�� �Ѵ� �͸� ǥ��.
dim(popular_dests)

