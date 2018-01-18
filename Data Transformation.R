library(nycflights13)
library(tidyverse)
?flights
View(flights)

#### Dyplyr Functions

### 1. FILTER

## filter (<DATA>, <EXPRESSION>,<EXPRESSION>...)
## Operators: < <= > >= == !=
## example:

jan1 <- filter (flights, month == 1)
(dec25 <- filter (flights, month==12, day==25))

## Booleans 
## & <- and 
## | <- or 
## ! <- not

(decornov<- filter (flights, month ==12| month ==11))

## another way to write the above is using %in%
## x %in% y will take all the rows where x is one of the values in y

(decornovbetter <- filter (flights, month %in% c(12, 11)))


## often in data sets we have unknown values
## when a value is unknown it is set as NA
## ANY OPERATION YOU DO ON NA WILL PRODUCE NA
## even NA==NA will produce NA
## in order to check if a value is NA:
## is.na(<VARIABLE>)

## filter automatically excludes all rows that produce a false
## or that have NA 
## if you want the NA then ask for it specifically

(random <- filter (flights, is.na(month)| month %in% c(12, 11)))

## Two other operators that can be used are:
## near(<VALUE>,<VALUE>)
## between(<VARIABLE>, <LEFT BOUND>, <RIGHT BOUND>)


### 2. ARRANGE

## arrange (<DATA>, <VARIABLE>,<VARIABLE>,<VARIABLE> ...)
## arrange will sort the data in ascending order according to the first variable
## the subsequent variables are used to break ties
## example:

(fastestflights <- arrange(flights, dep_delay+arr_delay))
View(fastestflights)

## In order to sort from lowest to highest use desc()
## example:

(slowestflights <- arrange(flights, desc(dep_delay+arr_delay)))
View(slowestflights)


### 3. SELECT

## select (<DATA>, <VARIABLE>,<VARIABLE>,<VARIABLE> ...)
## select will produce the original dataset with only the variables you want
## example:

select(flights, day, month, year) #selection by name

select(flights, year:day) #selection of all columns between year and day (inclusive)

select(flights, -(year)) #selection of all columns except year

## Other helper functions you can use with select:
## starts_with ()
## ends_with ()
## contains()
## matches()
## num_range()

## rename(<DATA>, <NEW NAME> = <VARIABLE>) changes the name of one variable
## example:

rename(flights, tail_num = tailnum)

## If you want to re-arrange a couple variables to the front while everything 
## else stays as is: (you can use the everything() helper with the select function)
## example:

select(flights, year, day, tailnum, everything())

### 4. MUTATE

## mutate(<DATA>, <NEW VARIABLE Name>= (<VARIABLE> operator <VARIABLE> ...)
##                <NEW VARIABLE Name>= (<VARIABLE> operator <VARIABLE> ...) ...)
## Creates a new variable that is a function of one or more variables found in the
## data set, the new variable is automatically added to the end
## example:

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time)
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60,
       gain_per_hour = gain/ hours)
  
## If you only want to retain the new variables use transmute()
## example:

transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours)

## Useful functions to use in mutate()

## log() log2() log10()  
## These are useful for dealing with data that ranges across multiple orders of 
## magnitude. They also convert multiplicative relationships into additive 
## relationships. eg. if you use log2() a difference of 1 corresponds
## to doubling, while a difference of -1 corresponds to halfing

## lead() lag()
## allows you to refer to the next or previous item in the data set

## Cumulative and rolling aggregates
## cumsum(), cumprod(), cummin(), cummax(), cummean()



### 5. SUMARISE 

## sumarise (<DATA>, <NEW VARIABLE NAME> = operator (<VARIABLE>, na.rm = TRUE))
## collapses a data frame into one row
## Note: na.rm = TRUE takes out all the values that are NA
## example:

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

## sumarise is usually used with group_by. When you sumarise paired with group_by
## instead of sumarising the data into one row, it gets sumarised by group
## example:

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = floor(mean(dep_delay, na.rm = TRUE)))

######### PIPE %>%
## Pipe is a function that links different functions which takes away the need
## for you to name each intermediary step 
## eg. x %>% f(y) => f(x, y)
##     x %>% f(y) %>% g(z) => g( f(x, y), z)


## Counts 
## When doing aggregation it is often useful to include a count n()
## for example look at the three examples below, in the first example without count
## it looks as if there is a high variation in the data, however in the second
## example it can be seen that many of the outliers have very low counts. In the 
## third example we take out the data points that have low counts.
## example 1

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
    )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

## example 2

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

## example 3

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
   geom_point(alpha = 1/10)
