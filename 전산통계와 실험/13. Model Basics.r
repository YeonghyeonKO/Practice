library(tidyverse)
library(modelr)
options(na.action = na.warn)

ggplot(sim1, aes(x, y)) +   # simulated dataset, included with the modelr package
  geom_point()

models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)

ggplot(sim1, aes(x, y)) + 
  geom_abline(aes(intercept = a1, slope = a2), data = models, alpha = 1/4) +
  geom_point() 

model1 <- function(a, data) {
  a[1] + data$x * a[2]
}
model1(c(7, 1.5), sim1)


## Distance from a model to the data
measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff ^ 2))
}
measure_distance(c(7, 1.5), sim1)

## Compute the distances
sim1_dist <- function(a1, a2) {  # helper function. why do we need this?
  measure_distance(c(a1, a2), sim1)
}

models <- models %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
models


## 10 best models
ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist), 
    data = filter(models, rank(dist) <= 10)
  )


## Visualise the models in the a1 - a2 plane
ggplot(models, aes(a1, a2)) +
  geom_point(data = filter(models, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist))


## lm()
sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod)


grid <- sim1 %>% 
  data_grid(x) # evenly space grid the covers the data region
grid <- grid %>% 
  modelr::add_predictions(sim1_mod) 
grid

ggplot(sim1, aes(x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = pred), data = grid, colour = "red", size = 1)

sim1 <- sim1 %>% 
  add_residuals(sim1_mod)
sim1

## 잔차가 정규분포를 띤다.
ggplot(sim1, aes(resid)) + 
  geom_freqpoly(binwidth = 0.5)

## 별다른 패턴이 없어 good!
sim1 %>%
  ggplot(aes(x, resid)) + 
  geom_ref_line(h = 0) +
  geom_point() 


## Formulas and model families
df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)
model_matrix(df, y ~ x1)


## Categorical variables
df <- tribble(
  ~ sex, ~ response,
  "male", 1,
  "female", 2,
  "male", 1
)
model_matrix(df, response ~ sex)
  # 범주형 변수를 0, 1, 2로 나타내면 
  # 순서가 만들어져 문제들이 생김.
  # 이럴 때 차원을 늘려 (0,0), (0,1), (1,0)처럼 한다.
  # 그러면 model_matrix는 3x3 행렬(intercept 포함)
  # 혈액형을 예로 들면 (0,0,0), (0,0,1), (0,1,0), (1,0,0)으로 표현

ggplot(sim2) + 
  geom_point(aes(x, y))

mod2 <- lm(y ~ x, data = sim2)

grid <- sim2 %>% 
  data_grid(x) %>% 
  add_predictions(mod2)
grid

ggplot(sim2, aes(x)) + 
  geom_point(aes(y = y)) +
  geom_point(data = grid, aes(y = pred), colour = "red", size = 4)

# 범주에 대해 계산되는 계수는 category가 바뀔 때마다 바꿀 수 있는건 intercept 뿐
# 따라서 상수에 대해 fitting, 즉 평균에 대해서만 fitting하게 됨.


## Interactions (continuous and categorical)
sim3

ggplot(sim3, aes(x1, y)) +
  geom_point(aes(colour = x2))

mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)
# mod2 도 계수에 대해 선형모형(interaction을 감안한)

grid <- sim3 %>% 
  data_grid(x1, x2) %>%      # note two predictors
  gather_predictions(mod1, mod2)   # add predicitions from two models
grid

ggplot(sim3, aes(x1, y, colour = x2)) + 
  geom_point() + 
  geom_line(data = grid, aes(y = pred)) + 
  facet_wrap(~ model)

# mod1는 기울기가 같고 하필 x2가 범주형이라 intercept(y 절편)만 바뀌게 됨.


## Model comparison
sim3 <- sim3 %>% 
  gather_residuals(mod1, mod2)

ggplot(sim3, aes(x1, resid, colour = x2)) + 
  geom_point() + 
  facet_grid(model ~ x2)
# mod1는 선형파트로만은 설명할 수 없는 noise가 잔차에 남아 있음.


## Interactions (two continuous)
mod1 <- lm(y ~ x1 + x2, data = sim4)
mod2 <- lm(y ~ x1 * x2, data = sim4)

grid <- sim4 %>% 
  data_grid(
    x1 = seq_range(x1, 5),  # regularly spaced grid b/w min and max
    x2 = seq_range(x2, 5) 
  ) %>% 
  gather_predictions(mod1, mod2)
grid

ggplot(grid, aes(x1, x2)) + 
  geom_tile(aes(fill = pred)) + 
  facet_wrap(~ model)

ggplot(grid, aes(x1, pred, colour = x2, group = x2)) + 
  geom_line() +
  facet_wrap(~ model)

ggplot(grid, aes(x2, pred, colour = x1, group = x1)) + 
  geom_line() +
  facet_wrap(~ model)


## Transformations
df <- tribble(
  ~y, ~x,
  1,  1,
  2,  2, 
  3,  3
)
model_matrix(df, y ~ I(x^2) + x)

model_matrix(df, y ~ poly(x, 2))
# polynomial regression(다항함수로 회귀)


## Missing values
# options(na.action = na.warn)으로 결측치 있는지 확인
df <- tribble(
  ~x, ~y,
  1, 2.2,
  2, NA,
  3, 3.5,
  4, 8.3,
  NA, 10
)

mod <- lm(y ~ x, data = df)
mod <- lm(y ~ x, data = df, na.action = na.exclude)
# 경고메시지 표시 x


