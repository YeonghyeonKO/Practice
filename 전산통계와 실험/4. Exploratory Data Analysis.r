# 1. 주어진 변수들에 어떤 종류의 분산이 존재하는가?
# 2. 변수들 사이에 어떤 공분산이 있는가?


## Visualizing Variations
library(ggplot2)
library(dplyr)
diamonds %>% dplyr::count(cut)
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds) + geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
  # binning = 값에 따라 계급을 나누는 것.(binwidth : 0.5 간격으로 나눔)
diamonds %>% count(ggplot2::cut_width(carat, 0.5))

smaller <- diamonds %>% 
  filter(carat < 3)  # 3캐럿 미만으로 필터링
ggplot(data = smaller, mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.1)
  # 1, 1.5, 2캐럿으로 (정수) 맞추는 경향성을 알 수 있음. 일반적인 분포(정규, 감마 등)에 맞지 않다.
  # 또한, 각 peak 오른쪽이 왼쪽에 비해 많이 분포한 것으로 보아 0.99 보다는 1.01이 더 선호됨이 당연.

ggplot(data = smaller, mapping = aes(carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)
  # 히스토그램 대신 꺾은선 그래프로 표현.


## Subgroups
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)
  # peak가 2개이므로 군집이 2개(2분 동안 분출하는 군집과 4~5분가량 분출하는 군집으로 나뉘어짐.)


## Unusual Values
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
  # y값이 10 이하로 많이 분포해있지만 히스토그램 결과 60까지도 분포한다.

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 10))
  # 알고보니 30과 60 부근에 하나씩만 존재한다. 0인 값도 이상하니깐 살펴보자.

unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)
unusual
  # 살펴보았더니 x,y,z값이 모두 0이다. 결측값으로 두어도 무방할 듯?
  # y값이 31.8, 58.9인 친구들도 y값만 너무 크니깐 잘못 적지 않았다면 이상한 값 (outlier인 듯)
  # "it’s reasonable to replace them with missing values, and move on."


## Missing Values : 단순히 입력이 잘못된 것이거나 유용한 정보가 있는 것들로 나뉘어짐.
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))
  # 이상치들을 NA로 바꾸는 작업.

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()
  # ggplot에서 NA는 무시함. (NA있으면 경고 메시지 뜸)

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)
  # 결측값을 따로 둔 뒤에 시간을 실수값(0~24)으로 변환
  # 특정 시간에 결항이 많은가? 딱히...

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
  # 카운트를 기준으로하면 넓이가 당연히 ideal이 높게 나옴.

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
  # 따라서 count 대신에 density로 바꾸어 진짜 분포를 살펴봄.
  # Fair(가장 낮은) 등급이 가장 가격이 높다?! 더 알아보자.

## Boxplot
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()
  # boxplot의 whisker(수염같은 선)는 1.5*IQR 안에서 가장 먼 값.
  # 1.5*IQR 밖의 점은 다 표시함(outliers)
  # box 안의 선은 평균이 아니라 중앙값(50%)

## reorder()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))
  # reorder()로 범주를 정렬할 수 있다.

ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

diamonds %>% count(color, cut)

diamonds %>% count(color, cut) %>%
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))


## Two continuous variables
ggplot(diamonds) +
  geom_point(mapping = aes(x = carat, y = price), alpha = 1/50)

ggplot(data = diamonds) +
  geom_bin2d(mapping = aes(x = carat, y = price))

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, width=0.1)))

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, n=20)))

ggplot(data = faithful) + 
  geom_point(mapping = aes(x = eruptions, y = waiting))


## Patterns and models
library(modelr)
# model: assume exponential relation between `price` and `carat`
mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))  # residuals of the model

?add_residuals

ggplot(data = diamonds2) + 
  geom_point(mapping = aes(x = carat, y = resid))
  # 이때의 resid는 y에 대한 회귀모형으로 설명할 수 없는 부분

ggplot(data = diamonds2) + 
  geom_boxplot(mapping = aes(x = cut, y = resid))
  # price는 carat에 크게 의존하고 있기 때문에 carat에 대한 의존도를 제거하면
  # cut과 price의 관계를 설명할 수 있지 않을까
  # 그 결과 cut과 price는 양의 상관관계를 띤다.

