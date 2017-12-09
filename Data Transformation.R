library(nycflights13)
library(tidyverse)
?flights
View(flights)

#### Dyplyr Functions

### 1. FILTER

## filter (<DATA>, <EXPRESSION>,<EXPRESSION>)
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

## arrange (<DATA>, <VARIABLE>,<VARIABLE>,<VARIABLE> )
## arrange will sort the data in ascending order according to the first variable
## the subsequent variables are used to break ties
## example:
(fastestflights <- arrange(flights, dep_delay+arr_delay))
View(fastestflights)

## random change test

