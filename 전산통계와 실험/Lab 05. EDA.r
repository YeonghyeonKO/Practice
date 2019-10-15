install.packages("GGally")
library(GGally)

# ************************����!

as.tbl(iris[,c(1,2,5)])
summary(iris[,c(1,2,5)])

ggpairs(data = iris[,c(1,2,5)],
        title = "Multiple scatter p`lot",
        progress = FALSE)

?ggpairs

install.packages("corrplot")
library(corrplot)

as.tbl(iris[,1:3])

?corrplot
cor_iris <- cor(iris[,1:3]); cor_iris

corrplot(cor_iris)

## 3. Heatmap
# ��ʸ�Ʈ ó�� ���� �ֵ��� �����м� ���
# �����м��� ���� col�� row�� �ٲ�� ����.

set.seed(123)
nr1 = 4; nr2 = 8; nr3 = 6; nr = nr1 + nr2 + nr3
nc1 = 6; nc2 = 8; nc3 = 10; nc = nc1 + nc2 + nc3
mat = cbind(rbind(matrix(rnorm(nr1*nc1, mean = 1,   sd = 0.5), nr = nr1),
                  matrix(rnorm(nr2*nc1, mean = 0,   sd = 0.5), nr = nr2),
                  matrix(rnorm(nr3*nc1, mean = 0,   sd = 0.5), nr = nr3)),
            rbind(matrix(rnorm(nr1*nc2, mean = 0,   sd = 0.5), nr = nr1),
                  matrix(rnorm(nr2*nc2, mean = 1,   sd = 0.5), nr = nr2),
                  matrix(rnorm(nr3*nc2, mean = 0,   sd = 0.5), nr = nr3)),
            rbind(matrix(rnorm(nr1*nc3, mean = 0.5, sd = 0.5), nr = nr1),
                  matrix(rnorm(nr2*nc3, mean = 0.5, sd = 0.5), nr = nr2),
                  matrix(rnorm(nr3*nc3, mean = 1,   sd = 0.5), nr = nr3))
)
mat = mat[sample(nr, nr), sample(nc, nc)] # random shuffle rows and columns
rownames(mat) = paste0("row", seq_len(nr))
colnames(mat) = paste0("column", seq_len(nc))

heatmap(mat)

## Missing values
as.tbl(airquality)
summary(airquality)

hist(airquality$Ozone) # hist�� NA �� ���� �׸�.

airquality %>% na.omit() %>% as.tbl()

sum(complete.cases(airquality))
sum(!complete.cases(airquality))

## Outlier �ٷ�� ���� �����غ���!!

