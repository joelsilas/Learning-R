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


