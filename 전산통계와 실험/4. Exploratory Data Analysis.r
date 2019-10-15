# 1. �־��� �����鿡 � ������ �л��� �����ϴ°�?
# 2. ������ ���̿� � ���л��� �ִ°�?


## Visualizing Variations
library(ggplot2)
library(dplyr)
diamonds %>% dplyr::count(cut)
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds) + geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
  # binning = ���� ���� ����� ������ ��.(binwidth : 0.5 �������� ����)
diamonds %>% count(ggplot2::cut_width(carat, 0.5))

smaller <- diamonds %>% 
  filter(carat < 3)  # 3ĳ�� �̸����� ���͸�
ggplot(data = smaller, mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.1)
  # 1, 1.5, 2ĳ������ (����) ���ߴ� ���⼺�� �� �� ����. �Ϲ����� ����(����, ���� ��)�� ���� �ʴ�.
  # ����, �� peak �������� ���ʿ� ���� ���� ������ ������ ���� 0.99 ���ٴ� 1.01�� �� ��ȣ���� �翬.

ggplot(data = smaller, mapping = aes(carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)
  # ������׷� ��� ������ �׷����� ǥ��.


## Subgroups
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)
  # peak�� 2���̹Ƿ� ������ 2��(2�� ���� �����ϴ� ������ 4~5�а��� �����ϴ� �������� ��������.)


## Unusual Values
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
  # y���� 10 ���Ϸ� ���� ������������ ������׷� ��� 60������ �����Ѵ�.

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 10))
  # �˰��� 30�� 60 �αٿ� �ϳ����� �����Ѵ�. 0�� ���� �̻��ϴϱ� ���캸��.

unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)
unusual
  # ���캸�Ҵ��� x,y,z���� ��� 0�̴�. ���������� �ξ ������ ��?
  # y���� 31.8, 58.9�� ģ���鵵 y���� �ʹ� ũ�ϱ� �߸� ���� �ʾҴٸ� �̻��� �� (outlier�� ��)
  # "it��s reasonable to replace them with missing values, and move on."


## Missing Values : �ܼ��� �Է��� �߸��� ���̰ų� ������ ������ �ִ� �͵�� ��������.
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))
  # �̻�ġ���� NA�� �ٲٴ� �۾�.

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()
  # ggplot���� NA�� ������. (NA������ ��� �޽��� ��)

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
  # �������� ���� �� �ڿ� �ð��� �Ǽ���(0~24)���� ��ȯ
  # Ư�� �ð��� ������ ������? ����...

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
  # ī��Ʈ�� ���������ϸ� ���̰� �翬�� ideal�� ���� ����.

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
  # ���� count ��ſ� density�� �ٲپ� ��¥ ������ ���캽.
  # Fair(���� ����) ����� ���� ������ ����?! �� �˾ƺ���.

## Boxplot
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()
  # boxplot�� whisker(�������� ��)�� 1.5*IQR �ȿ��� ���� �� ��.
  # 1.5*IQR ���� ���� �� ǥ����(outliers)
  # box ���� ���� ����� �ƴ϶� �߾Ӱ�(50%)

## reorder()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))
  # reorder()�� ���ָ� ������ �� �ִ�.

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
  # �̶��� resid�� y�� ���� ȸ�͸������� ������ �� ���� �κ�

ggplot(data = diamonds2) + 
  geom_boxplot(mapping = aes(x = cut, y = resid))
  # price�� carat�� ũ�� �����ϰ� �ֱ� ������ carat�� ���� �������� �����ϸ�
  # cut�� price�� ���踦 ������ �� ���� ������
  # �� ��� cut�� price�� ���� ������踦 ���.

