library("tidyverse")
head(iris)

as_tibble(iris)

tibble(
  x = 1:5, 
  y = 1, 
  z = x ^ 2 + y)

tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5)
  # 전치행렬 만들기

tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE))   # letters() == 'a' -- 'z'

nycflights13::flights %>% 
  print(n = 10, width = Inf)

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
df; df$x; df[["y"]]; df[[1]]; df[1]
df %>% .$x; df %>% .[["x"]]


## Data import : csv(,) / csv2(;) / tsv(tab) / delim
## read.csv는 r의 기본 함수, read_csv는 readr 패키지
read_csv("a,b,c
1,2,3
4,5,6")

read_csv("The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3", skip = 2)

read_csv("# A comment I want to skip
  x,y,z
  1,2,3", comment = "^")

read_csv("1,2,3\n4,5,6", col_names = FALSE)

read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))

read_csv("a,b,c,d\n1,2,.,$", na = c(".", "$"))

heights <- read_csv("C:\\Users\\1234\\Desktop\\고영현\\수업\\19-2\\전산통계와 실험\\Workbook\\heights.csv")
heights


## Parsing a vector
str(parse_logical(c("TRUE", "FALSE", "NA")))
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1979-10-14")))

parse_integer(c("1", "231", ".", "456", "3.14"), na = ".") # Missing values


## Numbers
parse_double(c("1.23", "abc"))
parse_double("1,23", locale = locale(decimal_mark = ","))

parse_number("$100"); parse_number("It was almost 20% higher than the original cost")

parse_number("$123,456,789") # Used in America
parse_number("123'456'789", locale = locale(grouping_mark = "'"))
# Used in Switzerland


## Strings
charToRaw("Yeonghyeon") # 16진수표기법(10~15는 a,b,c,d,e,f)
x1 <- "El Ni\xf1o was particularly bad this year" 
 # Latin1 (aka ISO-8859-1)
x2 <- "\xbe\xc8\xb3\xe7\xc7\xcf\xbc\xbc\xbf\xe4"    # EUC-KR (Korean)

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "EUC-KR"))


## Factors
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)


## Dates, date-times, and times
parse_datetime("1995-07-08T1900")
parse_datetime("19950708")
parse_date("1995-07-08"); parse_date("1995/07/08")

library(hms)
parse_time("11:11 pm"); parse_time("11:11:11 pm")

challenge <- read_csv(readr_example("challenge.csv"))
problems(challenge)

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(), y = col_character()
  )
)

tail(challenge)

challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)
challenge2

df <- tribble(
  ~x,  ~y,
  "1", "1.21",
  "2", "2.32",
  "3", "4.56"
)
df

type_convert(df)

write_csv(challenge, "challenge.csv")
write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")


## Tidy Data
table4a %>%
  gather(`1999`, `2000`, key = "year", value = "cases")

tidy4a <- table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")
left_join(tidy4a, tidy4b)  # we'll learn about this in Ch. 13

table2
spread(table2, key = type, value = count)

table3
table3 %>% 
  separate(rate, into = c("cases", "population"))
  # 알아서 "/"를 기준으로 분리

table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)
  # 알아서 정수형으로 바꿔줌

table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)

table5
table5 %>% 
  unite(new, century, year, sep = "")
