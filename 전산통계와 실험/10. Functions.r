df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df$a <- (df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) / 
  (max(df$b, na.rm = TRUE) - min(df$b, na.rm = TRUE))
df$c <- (df$c - min(df$c, na.rm = TRUE)) / 
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) / 
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))

x <- df$a
(x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

rng <- range(x, na.rm = TRUE)
(x - rng[1]) / (rng[2] - rng[1])

?range()
## Function 만들기!!!
df

rescale0 <- function(x){
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

df %$% rescale0(a)

x <- c(1:10, Inf) # Inf는 double
rescale0(x)  # 실수/inf, ... , inf/inf

avg_na <- function(x){
  mean(is.na(x))
}

avg_na(c(1,4,6,2,NA))

has_prefix <- function(word, prefix){
  if(prefix != ""){
    substr(word, 1, nchar(prefix)) == prefix
  }else{
    cat("No prefix")
    # return(NULL)
  }
}

has_prefix("unknown", "un")



## Conditional execution: if - else
has_name <- function(x){
  nms <- names(X)
  if (is.null(nms)){
    rep(FALSE, length(x))
  } else{
    !is.na(nms) & nms != ""
  }
}


if (c(TRUE, FALSE)) {
  print(1)
}


## Function Arguments
mean_ci <- function(x, conf = 0.95){
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - conf
  mean(x) + se * qnorm(c(alpha/2, 1 - alpha/2))
}

mean_ci(runif(100))
mean_ci(runif(100), conf = 0.99)


## Checking values : 벡터 재활용 주의!!
wt_mean <- function(x, w) {
  sum(x * w) / sum(w)
}
wt_mean(1:6, 1:3)  # why this result?

wt_mean <- function(x, w) {
  if (length(x) != length(w)) {
    stop("`x` and `w` must be the same length", call. = FALSE)
  }
  sum(w * x) / sum(w)
}
wt_mean(1:6, 1:3)
?stop()

iter <- 12
try(if(iter > 10) stop("too many iterations"))


## switch()
calculator <- function(x, y, op){
  switch(op,
         plus = x+y,
         minus = x-y,
         times = x*y,
         divide = x/y,
         stop("Unknown op!"))
}

?switch
switch(2, "apple", "banana", "cantaloupe")

calculator(2,0, "divide")


library(lubridate)

greeting <- function(x){
  hr <- substr(now(), 12, 13)
  cat(paste0("It's ", hr, ".\n"))
  if(hr < 12){
    "good morning"
  }else if(hr < 18){
    "good afternoon"
  }else{
    "good evening"
  }
}

greeting(now())

temp <- seq(-10, 50, by = 5)
cut(temp, c(-Inf, 0, 10, 20, 30, Inf),
    right = FALSE,
    labels = c("freezing", "cold", "cool", "warm", "hot")
)
# right = FALSE는 오른쪽이 열린구간.



## (...)
commas <- function(...) stringr::str_c(..., collapse = ", ")
commas(letters[1:10])




## Writing pipeable functions
show_missings <- function(df) {
  n <- sum(is.na(df))
  cat("Missing values: ", n, "\n", sep = "")
  
  invisible(df)
}

x <- show_missings(mtcars); class(x); dim(x)


## Environment
`+` <- function(x, y) {  # override `+`
  if (runif(1) < 0.1) {
    sum(x, y)
  } else {
    sum(x, y) * 1.1
  }
}
# 덧셈을 새로이 정의
table(replicate(1000, 1 + 2))

rm(`+`)
table(replicate(1000, 1 + 2))


