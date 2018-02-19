library(tidyverse)

## When a variable is categorical you can examine the distribution with a bar chart

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

diamonds %>%
  count(cut)

## If a variable is continuos you can examine the distribution using a histogram

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

diamonds %>%
  count(cut_width(cut,0.5))


## It is always useful to look at different sections of the data, for example look
## at the difference when we look at diamonds which are smaller 

smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.1)

## You can overlay multiple histograms in one plot with geom_freqpoly

ggplot(data = smaller) +
  geom_freqpoly(mapping = aes(x = carat, colour = cut), binwidth = 0.1)


ggplot(data = smaller) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.01)


## When looking at the data lets say your looking for really low values, perhaps
## outliers you could adress this by setting a limit to the y axis and observing

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

## we can now pluck out these outlier values using dplyr

unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)
unusual


## Now lets say we wanted to get rid of these outlier values we can replace
## the values with missing values

diamonds2 <- diamonds %>%
  mutate(y = ifelse( y < 3 | y > 20, NA, y))

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

## BOX PLOTS :

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

## TILE PLOT :

diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))


## When making scatterplots with large data sets points tend to overlap so we can
## use bin in 2d to fix this:

ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))

install.packages("hexbin")

ggplot(data = smaller) +
  geom_hex(mapping = aes(x = carat, y = price))


ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))


## It's hard to understand the relationship between cut and price, because cut 
## and carat, and carat and price are tightly related. It's possible to use a 
## model to remove the very strong relationship between price and carat so we 
## can explore the subtleties that remain. The following code fits a model that 
## predicts price from carat and then computes the residuals (the difference 
## between the predicted value and the actual value). The residuals give us a 
## view of the price of the diamond, once the effect of carat has been removed.

library(modelr)

mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))

ggplot(data = diamonds2) + 
  geom_point(mapping = aes(x = carat, y = resid))

ggplot(data = diamonds2) + 
  geom_boxplot(mapping = aes(x = cut, y = resid))
