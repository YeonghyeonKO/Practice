### Vectors

# integer vector는 모두 integer (homogeneous)
# list vector는 여러 자료형이 섞여도 됨.(heterogeneous)
# Null vs NA
# Null은 벡터의 부재, NA는 벡터 내에서 값이 없음.

typeof(letters)
typeof(1:10)
length(list("a", "b", 1:10))
?read_csv
# 실수 비교에서 등호를 사용은 피해라! (floating point)

x <- sqrt(2)^2
x == 2
x
near(2, x)

c(-1, 0, 1)
typeof(c(-1, 0, 1))

c(-1, 0, 1) / 0

# install.packages("pryr")
x <- "This is a reasonably long string."
pryr::object_size(x)

pryr::object_size(x[1:10])

# unique string은 memory에 저장되므로 효율성 좋음.
# 같은 문장이 반복될 때 몇 번 반복되는지만 알려줌.
pryr::object_size(rep(x, 1000))


## Explicit coercion
# as.logical(), as.integer(), as.double()

## Implicit coercion
x <- sample(20, 100, replace = TRUE)
y <- (x > 10)
sum(y)  # logical인 y를 sum()이 implicit coercion
mean(y)

if (length(x)){
  print(2)
  # 0이면 FALSE
}

typeof(c(TRUE, 1L)) # integer
typeof(c(1.5, 1L))  # double
typeof(c("a", 1.5)) # character
# 벡터에 여러 type이 섞이면 복잡한 것으로 coercion


## Recycling Vectors
sample(10) + 100  # 1~10까지 비복원추출
runif(10) > 0.5 # 0~1까지 균일분포
1:10 + 1:2
1:10 + 1:3


## Subsetting : pull our elements
x <- c("one", "two", "three", "four", "five")
x[c(1, 1, 5, 5, 5, 2)]
x[c(-1, -3, -4)]  # drop the elements

x <- c(10, 3, NA, 5, 8, 1, NA)
x[!is.na(x)]  # All non-missing values of x
x[x %% 2 == 0]

y <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2 )
y[2,] # y행렬의 2열(열부터 채워짐)
y[,-1]


## Lists
x <- list(1,2,3)
x; str(x); typeof(x)

x_named <- list(a = 1, b = 2, c = 3)
str(x_named)


## Subsetting
a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5))
str(a[4]); str(a[1:2])

str(a[[4]]); str(a[[1]]) # list에서 하나 더 들어감.
str(a[[4]][1])
a$a


