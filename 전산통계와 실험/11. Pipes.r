library(magrittr)

"x" %>% assign(100)
x
# %>% 는 temporary이기 때문에 x 변수로 저장안됨

env <- environment()
"x" %>% assign(50, envir = env)

rnorm(100) %>%
  matrix(ncol = 2) %>%
  plot() %>%
  str()

# T-pipe : 한 갈래가 아니라 두 갈래로 뻗어가도록
rnorm(100) %>%
  matrix(ncol = 2) %T>%
  plot() %>%
  str()


mtcars %$%
  cor(disp, mpg) 

mtcars <- mtcars %>% 
  transform(cyl = cyl * 2)

# 다시 변수로 넣어줌.
mtcars %<>% transform(cyl = cyl * 2)
