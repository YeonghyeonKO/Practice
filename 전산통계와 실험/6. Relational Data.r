library(nycflights13); library(tidyverse)

flights

airlines; airports; planes; weather

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

inner_join(x, y, by = "key")
left_join(x, y, by = "key")
right_join(x, y, by = "key")
full_join(x, y, by = "key")


## Duplicate keys
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)
left_join(x, y, by = "key")

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)
left_join(x, y, by = "key")


## Defining the key columns
flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

left_join(flights2, weather)
flights2 %>%  left_join(planes, by = "tailnum")


## Filtering Joins
top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest


## Semi-join : y에서 키가 존재하는 x행만 필터링
semi_join(flights, top_dest)  # 알아서 dest로 조인


## Anti-join : y에서 매칭이 안되는 x행 필터링
flights %>% 
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)

  # planes 데이터에 없는 tailnum을 가진 flights 골라냄.


## Set operations
df1 <- tribble(
  ~x, ~y,
  1,  1,
  2,  1
)
df2 <- tribble(
  ~x, ~y,
  1,  1,
  1,  2
)

intersect(df1, df2) # 행 기준으로 계산
union(df1, df2)
setdiff(df1, df2) # x와 y여집합의 교집합
setdiff(df2, df1) # y와 x여집합의 교집합
