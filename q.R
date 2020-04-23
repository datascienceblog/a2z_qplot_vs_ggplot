library(tidyverse)

reads2019 <- read_csv("./SaraReads2019_allrated.csv",
                      col_names = TRUE)

# `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
qplot(Pages, data = reads2019)

# If I give it 2 continuous variables, it generates a scatterplot.
qplot(Pages, read_time, data = reads2019)

# If I give it a factor, it generates a bar chart.
reads2019 <- reads2019 %>%
  mutate(Fiction = factor(Fiction,
                          levels = c(0,1),
                          labels = c("Non-Fiction", "Fiction")))

qplot(Fiction, data = reads2019)

# And so on. Now, all throughout this series, and in many other stats and R posts, I’ve been using ggplot, instead of qplot. 
# And I rarely, if ever, use qplot these days, even for quick data visualizations. 
# Unlike qplot, ggplot requires you to specify the exact type of plot you want to make, using a geom_ in your code. And if you request a geom type that can’t be made with the type of data you have, you’ll get an error. 
# Making a ggplot requires you to know what type of data you have and how you’d like it to be visualized. Despite (or perhaps because of) this, I strongly prefer ggplot and would encourage you to use it as well.
# There are nearly endless ways to customize a ggplot – transforming scales, adding color schemes, layering data, changing fonts – that allow you make a fancy, schmancy, publication-ready plot. 
# If you plan on publishing or presenting your work, you really want to use ggplots instead of qplots. qplots are like the first draft of your manuscript – no one sees it but you. 
# But, in this case, it’s a first draft that you can skip right over; just go straight to the good-looking plot.
# Second, you notice that I didn’t use the main pipe for my qplots above. That’s because if you try it, you get an error.

