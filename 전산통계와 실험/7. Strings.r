library(stringr); library(tidyverse)

string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'
# 쌍 따옴표가 문자열로 인식이 안됨.

double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

double_quote
single_quote

writeLines(double_quote); writeLines(single_quote)
# \뒤의 "과 '만 프린트됨

x <- c("\"", "\\")
x

?"'"

x <- "\uc804\uc0b0\ud1b5\uacc4"
x
y <- "\u96fb\u7b97\u7d71\u8a08"
y

str_length("\u96fb\u7b97\u7d71\u8a08")
str_length("R for data science")

str_c("x", "y", "z")
str_c("x", "y"); str_c("\u96fb\u7b97", "통계")
str_c("이름", c("a", "b", "c"), "사람", sep = ":")
# 두 벡터의 길이가 달라도 짧은 인자를 긴 걸로 맞춤.
# 권장하지 않음...

name <- "Marcel"
time <- "Morning"
birthday <- FALSE

str_c(
  "Good", time, name,
  if(birthday) "and Happy Birthday", "\b.",
  sep = " "
  )

str_c(c("xy", "y", "z"), c("a", "b", "c"), collapse = "*")
str_c(c("xy", "y", "z"), c("a", "b", "c"), sep = ",")

?str_c


## Subsetting strings
str_sub("Apple", 1:3)
str_sub("Apple", 2)
str_sub("Apple", 1, 3)

x <- c("Apple", "Banana", "Pear")
str_sub(c("Apple", "Banana", "Pear"), 1, 3)
str_sub(x, -3, -1)

str_to_lower(c("ASDF"))
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))


## Basic matches
x <- c("apple", "banana", "pear")
str_view(x, "an")
str_view_all(x, "an")

str_view(x, ".a.")

str_view(c("abc", "a.c", "bef"), "a\\.c")  # why "\\."?
# a\\.c의 글자수는 4
# regexp에서의 \.는 .을 의미하므로 a.c가 선택됨

str_view("a\\b", "\\\\")  # \\\\의 글자수는 2
# \\\\는 \\를 뜻하는데, regexp에서는 \ 하나를 뜻함
# 따라서 a\\b 즉 a\b에서의 \가 선택된다.


str_view("")

## Anchors
x <- c("apple", "banana", "pear")
str_view(x, "^a") # a로 시작하는 문자열
str_view(x, "a$") # a로 끝나는 문자열

x <- c("apple pie", "apple", "apple cake", "pine apple")
str_view(x, "^apple$")

str_view(x, "apple$")

# \\d -> \d : 숫자 매칭
# \\s -> \s : 공백(space, tab, enter)

str_view(c("grey", "gray"), "gr[ea]y")
str_view(c("grey", "gray"), "gr[^ea]y")
# [^]는 대괄호 안 문자 제외

str_view(words, "^[^aeiou]", match = TRUE)
str_view(words, "[^e](ed)$", match = TRUE)

## Repetition
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")  # ?는 0 or 1
str_view(x, "CC+")  # +는 한 번 이상
str_view(x, "C[LX]+") # L 또는 X가 한 번 이상

str_view(x, "C{2}")
str_view(x, "C{2,3}") # 2번 이상 3번 이하

str_view(x, 'C[LX]+?')  # L 또는 X 한 번 이상 찾고 끝
str_view(x, "C{2,3}?")

## Grouping and backreference
str_view(fruit, "(..)\\1", match = TRUE)
  # 문자열이 한번 더 반복되는거 찾아라

str_view(words, "(.)(.)\\2\\1", match = TRUE)
str_view(words, "(.).\\1.\\1", match = TRUE)
str_subset(words, "([a-z]).*\\1.*\\1")

str_view(words, "(.)(.)(.).*\\3\\2\\1", match = TRUE)
str_view("02-895-62", "\\d{2}-\\d{3}-\\d{2}")

str_subset(words, "^(.)(.*\\1$)")

str_subset(words, "^(.)((.*\\1$)|\\1?$)")

str_subset(words, "([A-Za-z][A-Za-z]).*\\1")

str_subset(words, "^[^aeiou]+$")
str_count(c("apple", "banana"), "[aeiou]")


## Detect matches
x <- c("apple", "banana", "pear")
str_detect(x, "e")

length(words); head(words)
sum(str_detect(words, "^t"))
str_subset(words, "x$")

df <- tibble(
  word = words, 
  i = seq_along(word)
  # words의 index 생성
)
df %>% 
  filter(str_detect(words, "x$"))
  # x로 끝나는 단어 순서 제시


str_count(x, "a")

mean(str_count(words, "[aeiou]"))
# 한 단어 당 평균 모음의 갯수

df %>% 
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )
  # 모음과 자음의 갯수 세기


## Extract matches
colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")
colour_match # 6개 색을 |를 사이에 두고 합침

has_colour <- str_subset(sentences, colour_match)
matches <- str_extract(has_colour, colour_match)
head(matches)

more <- sentences[str_count(sentences, colour_match) > 1]
str_view_all(more, colour_match)

str_extract_all(more, colour_match)


## Grouped matches
noun <- "(a|the) ([^ ]+)"   # very crude heuristic

has_noun <- sentences %>%
  str_subset(noun) %>%
  head(10)
has_noun %>%
  str_extract(noun)

has_noun %>%
  str_match(noun) # component로 쪼갬.


tibble(sentence = sentences) %>%
  tidyr::extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)",
    remove = FALSE
  )


## Replacing matches
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
str_replace_all(x, "[aeiou]", "-")

x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>% 
  head(5)
  # 그룹 ()을 찾자. 대괄호 안의 ^ 뒤에꺼 제외
  # 첫 번째부터 세 번째 단어 찾기.
  # 두 번째랑 세 번째 단어 위치 바꾸기.
  # 한국어는 조사도 붙어있기 때문에 단어끼리 분리가 안됨.

sentences %>%
  head(5) %>% 
  str_split(" ")

str_split("a|b|c", "\\|", simplify = TRUE)

fields <- c("Name: Hadley", "Country: NZ", "Age: 35")
fields %>% str_split(": ", n = 2, simplify = TRUE)

x <- "This is a sentence.  This is another sentence."
str_view_all(x, boundary("word"))
  # boundary()로 구두점 고려하여 단어 split

str_view(c("banana", "Banana"), regex("banana",
         ignore_case = TRUE))
