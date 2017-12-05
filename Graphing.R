library(tidyverse)

mpg
?mpg

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))


#ggplot(data = <DATA>) + 
#  <GEOM FUNCTION>(mapping = aes(x = <VARIABLE>, 
#                                y = <VARIABLE>, 
#                                color = <VARIABLE>
#                                shape = <VARIABLE>
#                                size = <VARIABLE>
#                                alpha = <VARIABLE>
#                                stroke = <VARIABLE>))
# Note: you can set an aesthetic manually eg color to blue
#       by replacing the <VARIABLE> with "blue" and taking
#       the aesthetic out of the aes ()
# EXAMPLE:

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")



# Splitting up a graph into seperate graphs based on a 
# categorical variable (can use continuos)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# Splitting up a graph into seperate graphs based on two 
# variables 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

# Note : facet_grid(. ~ cyl) facets without using rows


# You can create different types of graphs using different "geoms"
# For example you can use geom_smooth as follows

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))


# You can overlay multiple graphs by adding multiple geom functions to the ggplot

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

# If you dont want to update each individual mapping you can create a local 
# mapping as follows and then add specific aes as required 

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color=drv)) + 
  geom_smooth()

# You can also change the local data set for each individual geom
# which will overwrite the global data

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)


## Statistical Data and Bar Graphs 

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

## geom_bar automatically calculates a new variable "count" which will correlate
## to the x value. However if you want to map x to your own frequencies already
## present in your data set then you can do this:

demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

## If instead of the count of the variables you want the proportion you can use:

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

## Another method for graphing

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )


## NICEST BAR GRAPH maps the fill aesthetic to the clarity variable 
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

## Proportion graph with colours 
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

## Graph with the different stacked layers of clarity side by side
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")


## Lets say you have a scatter plot with many values, some of the values
## that are close together will overlap and end up showing as one point
## because they will be rounded, to avoid this 

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() +
  geom_jitter

## coord_flip() flips the x and y axis 

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()

##  If you are mapping maps use coord_quickmap() to set aspect ratios

nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap

## Interesting graphs

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()


## Final Template for all graphs 
##ggplot(data = <DATA>) + 
##  <GEOM_FUNCTION>(
##    mapping = aes(<MAPPINGS>),
##    stat = <STAT>, 
##    position = <POSITION>
##  ) +
##  <COORDINATE_FUNCTION> +
##  <FACET_FUNCTION>
