library(tidyverse)

reads2019 <- read_csv("./SaraReads2019_allrated.csv",
                      col_names = TRUE)

# In my reading dataset, I could compute a cumulative sum of my days reading, 
# then plot that against day of the year (days numbered from 1 to 365), to see where I might have had gaps in my reading habits.
library(lubridate)

reads2019 <- reads2019 %>%
  mutate(date_started = as.Date(reads2019$date_started, format = '%m/%d/%Y'),
         date_read = as.Date(date_read, format = '%m/%d/%Y'),
         days_reading = order_by(date_read, cumsum(read_time)),
         DOY = yday(date_read))

reads2019 <- reads2019 %>%
  mutate(read_time = ifelse(read_time > DOY, DOY, read_time),
         days_reading = order_by(date_read, cumsum(read_time)))

# Now I can plot days reading against day of the year.

reads2019 %>%
  ggplot(aes(DOY, days_reading)) +
  geom_point() +
  scale_x_continuous(breaks = seq(0, 380, 20)) +
  scale_y_continuous(breaks = seq(0, 360, 20)) +
  xlab("Day of Year") +
  ylab("Days Reading")

# Based on this chart, I have few gaps in my reading habits, but overall, read 341 days out of the year. 
# There are also spots where I was clearly reading 2 books at once, as well as places where I finished one book one day, 
# then started and finished another one that same day (some of the books I read were short, though).



