# We've used ggplots throughout this blog series, but today, I want to introduce another package that helps you customize scales on your ggplots - the scales package. 
# I use this package most frequently to format scales as percent. 

library(tidyverse)

reads2019 <- read_csv("./SaraReads2019_allrated.csv",
                      col_names = TRUE)

reads2019 <- reads2019 %>%
  mutate(perpage = Pages/sum(Pages))

library(scales)

reads2019 %>%
  ggplot(aes(perpage)) +
  geom_histogram() +
  scale_x_continuous(labels = percent, breaks = seq(0,.05,.005)) +
  xlab("Percentage of Total Pages Read") +
  ylab("Books")

# Histograms use a process called "binning", where ranges of scores are combined to form one of the bars. 
# The bins can be made bigger (including a larger range of scores) or smaller, and smaller bins will start showing the jagged nature of most data, even so-called normally distributed data.
# As one example, let's show what my percent figure would look like as a bar chart instead of a histogram (like the one above).
reads2019 %>%
  ggplot(aes(perpage)) +
  geom_bar() +
  scale_x_continuous(labels = percent, breaks = seq(0,.05,.005)) +
  xlab("Percentage of Total Pages Read") +
  ylab("Books")

#Now, my reading dataset is small - only 87 observations. What happens if I generate a large, random dataset?
et.seed(42)

test <- tibble(ID = c(1:10000),
               value = rnorm(10000))

test %>%
  ggplot(aes(value)) +
  geom_histogram()

# See that "stat_bin()" warning message? It's telling me that there are 30 bins, so R divided up the range of scores into 30 equally sized bins. 
# What happens when I increase the number of bins? Let's go really crazy and have it create one bin for each score value.
library(magrittr)

test %$% n_distinct(value)

test %>%
  ggplot(aes(value)) +
  geom_histogram(bins = 10000)

# How about if we mimic cognitive ability scores, with a mean of 100 and a standard deviation of 15? 
# I'll even force it to have whole numbers, so we don't have decimal places to deal with.
CogAbil <- tibble(Person = c(1:10000),
                  Ability = rnorm(10000, mean = 100, sd = 15))

CogAbil <- CogAbil %>%
  mutate(Ability = round(Ability, digits = 0))

CogAbil %$%
  n_distinct(Ability)

CogAbil %>%
  ggplot(aes(Ability)) +
  geom_histogram() +
  labs(title = "With 30 bins") +
  theme(plot.title = element_text(hjust = 0.5))

CogAbil %>%
  ggplot(aes(Ability)) +
  geom_histogram(bins = 103) +
  labs(title = "With 1 bin per whole-point score") +
  theme(plot.title = element_text(hjust = 0.5))
