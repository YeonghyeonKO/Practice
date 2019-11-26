library(tidyverse)


### For loops

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df

output <- vector("double", ncol(df))  # 1. output
for (i in seq_along(df)) {            # 2. sequence
  output[[i]] <- median(df[[i]])      # 3. body
}
output

# vector() : 주어진 길이의 빈 벡터 생성
# 1:length(x) 대신 seq_along() 권장!!!
# x의 길이를 알 수 없는 경우가 존재함.

y <- vector("double", 0)
1:length(y); seq_along(y)
for (i in 1:length(y)){
  print(1)
}
  # 예상과 다른 결과가 출력됨.


rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

for (i in seq_along(df)) {
  df[[i]] <- rescale01(df[[i]])
}

rescale01(df$c)


# 기존 벡터에서 새로운 벡터로 이름 따오기
results <- vector("list", length(df))
names(results) <- names(df)
results


for (i in seq_along(df)) {
  name <- names(df)[[i]]
  value <- df[[i]]
}

name; value


## Unknown output length

means <- c(0, 1, 2)

output <- double()
for (i in seq_along(means)){
  n <- sample(100, 1)
  output <- c(output, rnorm(n, means[i]))
}
str(output) # 매번 n이 갱신되므로 길이 변함.


## Unknown sequence length: while loop
flip <- function() sample(c("T", "H"), 1)
flips <- 0; nheads <- 0

while(nheads < 3){
  if (flip() == "H"){
    nheads <- nheads + 1
  } else{
    nheads <- 0
  }
  flips <- flips + 1
}

flips


col_mean <- function(df){
  output <- vector("double", length(df))
  for (i in seq_along(df)){
    output[i] <- mean(df[[i]])
  }
  output
}

col_sd <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- sd(df[[i]])
  }
  output
}

col_summary <- function(df, fun){
  out <- vector("double", length(df))
  for (i in seq_along(df)){
    out[i] <- fun(df[[i]])
  }
  out
}

col_summary(df, median)


## The map functions : purrr package
map_dbl(df, median); df %>% map_dbl(median)
map_dbl(df, sd); df %>% map_dbl(sd)
# for 문이 r에서 느리기 때문에 map이 효율적


## Anonymous function
models <- mtcars %>%
  split(.$cyl) %>%
  map(function(df) lm(mpg ~ wt, data = df))

str(models)

models %>% 
  map(summary) %>% 
  map_dbl(~.$r.squared)

x <- list(list(1, 2, 3), list(4, 5, 6), list(7, 8, 9))
x %>% map_dbl(2)  # map_dbl( ,2) : 두번째꺼 뽑기


## *apply() 함수
x1 <- list(
  c(0.27, 0.37, 0.57, 0.91, 0.20),
  c(0.90, 0.94, 0.66, 0.63, 0.06), 
  c(0.21, 0.18, 0.69, 0.38, 0.77)
)
x2 <- list(
  c(0.50, 0.72, 0.99, 0.38, 0.78), 
  c(0.93, 0.21, 0.65, 0.13, 0.27), 
  c(0.39, 0.01, 0.38, 0.87, 0.34)
)

threshold <- function(x, cutoff = 0.8) x[x > cutoff]
x1 %>% sapply(threshold) %>% str()
x2 %>% sapply(threshold) %>% str()


## Dealing with failure
safe_log <- safely(log)
str(safe_log(10))
str(safe_log("a"))

x <- list(1, 10, "a")
y <- x %>% map(safely(log))
str(y)

y <- y %>% purrr::transpose()
str(y)

is_ok <- y$error %>% map_lgl(is_null)
x[!is_ok]

y$result[is_ok] %>% flatten_dbl()
# flatten 함수

x <- list(1, 10, "a")
x %>% map_dbl(possibly(log, NA_real_))
# possibly : 에러 나면 NA 값

x <- list(1, -1)
x %>% map(quietly(log)) %>% str()
# quietly : 에러메시지 자세하게


## Reduce and accumulate
# reduce : 이항연산! 중요합니당@@@

dfs <- list(
  age = tibble(name = "John", age = 30),
  sex = tibble(name = c("John", "Mary"), sex = c("M", "F")),
  trt = tibble(name = "Mary", treatment = "A")
)

dfs %>% reduce(full_join)

vs <- list(
  c(1, 3, 5, 6, 10),
  c(1, 2, 3, 7, 8, 10),
  c(1, 2, 3, 4, 8, 9, 10)
)

vs %>% reduce(intersect)

