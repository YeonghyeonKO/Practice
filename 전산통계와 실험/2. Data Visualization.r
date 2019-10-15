
# install.packages("tidyverse")
library(tidyverse)
# tidyverse_update()
# install.packages(c("nycflights13", "gapminder", "Lahman"))

mpg

# ggplot : ggplot(data=<DATA>)+<GEOM_FUNCTION>(mapping=aes(<MAPPINGS>))
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class), color = "blue")

# facets : divide a plot into subplots based on the values of one or more discrete variables
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
  # facet_wrap : (~ discrete ????) ?? ???? ??��. 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ class)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl)) +
  facet_grid(drv ~ cyl)

# Geometric objects : smooth (linetype, )
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() +
  geom_smooth()
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) +
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)
  # se???? FALSE?̸? smooth ��?? ????. (?ŷڱ??? ????)

# 3.7. Statistical transformations - computed variables (stat)
# geom_bar() : ?????׷???
diamonds
?geom_bar
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut)) # count?? diamonds ?????? ?ƴ?.
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
  # y ??�� ..prop.., group=1?? ?ٲٸ? ???뵵???? ??ȯ
  # STAT???? ?????? ???????? ??Ÿ???��? ?????? ?յڿ? ".."�� ?ٿ??? ?Ѵ?.
  # stat="identity"?? geom_bar()?? STAT ??�� ???????ͼ¿? ?ִ? ??��?? ???ڴٴ? ?ǹ?


ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median)
ggplot(data = diamonds, mapping = aes(cut, depth)) +
  geom_line() +
  geom_point(aes(cut, median(depth), group = cut))

# Position adjustments - color, fill, 
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, color = cut, fill = cut))
  # ?? ???ָ? x?࿡?? ��???Ϸ��? factor(??????)
ggplot(airquality, aes(x = Day, y = Temp, group = Day)) + 
  geom_boxplot()
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "identity")
  # position = "identity"?? stack ???? ó��???? ?ٽ? ?ױ? ?????? I1�� ?????? ??��.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")
  # position = "dodge"?? ??��?? ?????Ѵ?.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")
  # position = "fill"?? ??ü?? ä?? ?? ?????Ѵ?.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "jitter")
  # ?????? ?????????? ?? ?Ⱦ?.
ggplot(data=mtcars) +
  geom_point(mapping = aes(x=as.factor(cyl), y=mpg))
ggplot(data=mtcars) +
  geom_point(mapping = aes(x=as.factor(cyl), y=mpg), position = "jitter")
  # position = "jitter"?? ?Ȱ?ġ?? ???߷? ǥ???Ѵ?.

# Coordinate systems
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_cartesian(xlim = c(0,5))

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()
  # coord_flip()�� ???? ?̻??? ?????? x???? overlapping�� ???Ѵ?.

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip() + 
  coord_fixed(ratio = 1/2)
  # Adding new coordinate system, which will replace the existing one.
  # ??, coord ?Լ??????? ??ĥ ?? ???? ?????? ?Լ??? ?ν??Ѵ?.

install.packages("maps")
library("maps")

nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black")
  # ?????? geom_polygon ?Լ? ????

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

ggplot(data = diamonds) + geom_bar( mapping = aes(x = cut, fill = cut), show.legend = FALSE, width = 1 ) + theme(aspect.ratio = 1) + labs(x = NULL, y = NULL)+
  coord_flip()

ggplot(data = diamonds) + geom_bar( mapping = aes(x = cut, fill = cut), show.legend = TRUE, width = 1 ) + theme(aspect.ratio = 1) + labs(x = NULL, y = NULL) +
  coord_polar()
  # ?????? ???????? ???????ε?, cut�� ?????? ?????̹Ƿ? ?????? ???? ????.

# ??, ggplot�� layered grammar of graphics!

# Graphics for communications (Ch. 28)
# Title / Subtitle / caption / 
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel efficiency generally decreases with engine size",
       subtitle = "Two seaters (sports cars) are an exception because of their light weight",
       caption = "Data from fueleconomy.gov",
       x = "Engine displacement (L)",
       y = "Highway fuel economy (mpg)")

?plotmath

best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)
best_in_class

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = class)) +
  geom_text(aes(label = model), data = best_in_class)

install.packages("ggrepel")
library(ggrepel)
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class)

# Scales
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class))+
  scale_x_continuous() + 
  scale_y_continuous() +
  scale_color_discrete()

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(breaks = seq(15, 40, by = 5))
# breaks : ???? ?߰? / labels : ???? ???? ??��

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  scale_y_log10() +
  scale_x_reverse()
# log10() : ?α׽????Ϸμ? ?????? ?????? ???? ???? ??.
# reverse() : ?ش? ?? ??????

# Legends : "left", "right", "top", "bottom", "none"
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class)) + 
  theme(legend.position = "left")

# Zooming : coord_cartesian() ???ڷ? xlim, ylim ??��
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class)) + 
  geom_smooth(se = FALSE) +
  xlim(5,7) + ylim(10,30) +
  theme(legend.position = "bottom")


df <- reshape2::melt(outer(1:4, 1:4), varnames = c("X1", "X2"))

p1 <- ggplot(df, aes(X1, X2)) + geom_tile(aes(fill = value))
p2 <- p1 + geom_point(aes(size = value))

# Basic form
p1 + scale_fill_continuous(guide = guide_legend())

# Control styles

# title position
p1 + guides(fill = guide_legend(title = "LEFT", title.position = "left"))

# title text styles via element_text
p1 + guides(fill =
              guide_legend(
                title.theme = element_text(
                  size = 15,
                  face = "italic",
                  colour = "red",
                  angle = 0
                )
              )
)

# label position
p1 + guides(fill = guide_legend(label.position = "left", label.hjust = 1))

# label styles
p1 + scale_fill_continuous(breaks = c(5, 10, 15),
                           labels = paste("long", c(5, 10, 15)),
                           guide = guide_legend(
                             direction = "horizontal",
                             title.position = "top",
                             label.position = "bottom",
                             label.hjust = 0.5,
                             label.vjust = 1,
                             label.theme = element_text(angle = 90)
                           )
)

# Set aesthetic of legend key
# very low alpha value make it difficult to see legend key
p3 <- ggplot(mtcars, aes(vs, am, colour = factor(cyl))) +
  geom_jitter(alpha = 1/5, width = 0.01, height = 0.01)
p3
# override.aes overwrites the alpha
p3 + guides(colour = guide_legend(override.aes = list(alpha = 1)))

# multiple row/col legends
df <- data.frame(x = 1:20, y = 1:20, color = letters[1:20])
p <- ggplot(df, aes(x, y)) +
  geom_point(aes(colour = color))
p + guides(col = guide_legend(nrow = 8))
p + guides(col = guide_legend(ncol = 8))
p + guides(col = guide_legend(nrow = 8, byrow = TRUE))

# reversed order legend
p + guides(col = guide_legend(reverse = TRUE))


# Themes : _bw(), _classic(), _light(), _dark(), _void()
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class)) + 
  geom_smooth(se = FALSE) +
  theme_classic()

library(tibble)
install.packages("hexbin")
library(hexbin)
df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)
ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed()

ggplot(df, aes(x, y)) +
  geom_hex() +
  viridis::scale_fill_viridis() +
  coord_fixed()

# Saving plots
ggplot(mpg, aes(displ, hwy)) + geom_point() + geom_smooth(se = FALSE)
ggsave("my-plot.pdf")
# pdf?? ?????????̶? interpolation, png?? ??Ʈ?? ?????̶? ?ػ󵵰? ��??��??��.
# "https://www.ggplot2-exts.org" ???? ?׸? ???��?.
# "http://rstudio.com/cheatsheets"???? ?????ϱ?!

ggplot(mpg, mapping = aes(cty, hwy)) +
  geom_point(aes(color = class))
  
y <- seq(1,10, length.out = 6)
y
