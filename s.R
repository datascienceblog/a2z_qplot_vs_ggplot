library(tidyverse)

reads2019 <- read_csv("./SaraReads2019_allrated.csv",
                      col_names = TRUE)

reads2019 %>%
  summarise(AllPages = sum(Pages),
            AvgLength = mean(Pages),
            AvgRating = mean(MyRating),
            AvgReadTime = mean(read_time),
            ShortRT = min(read_time),
            LongRT = max(read_time),
            TotalAuthors = n_distinct(Author))

# Now, let's create a summary where we do save it as a tibble. And let's have it create some groups for us. 
# In the dataset, I coded author gender, with female authors coded as 1, so I can find out how many women writers are represented in a group by summing that variable. 
# I also want to fill in a few missing publication dates, which seems to happen for Kindle version of books or books by small publishers. 
# This will let me find out my newest and oldest books in each group; I just arrange by publication year, then request last and first, respectively. 
# Two books were published in 2019, so I'll replace the others based on title, then have R give the remaining NAs a year of 2019

reads2019 %>%
  filter(is.na(OriginalPublicationYear)) %>%
  select(Title)

reads2019 <- reads2019 %>%
  mutate(OriginalPublicationYear = replace(OriginalPublicationYear,
                                           Title == "Empath: A Complete Guide for Developing Your Gift and Finding Your Sense of Self", 2017),
         OriginalPublicationYear = replace(OriginalPublicationYear,
                                           Title == "Summerdale", 2018),
         OriginalPublicationYear = replace(OriginalPublicationYear,
                                           Title == "Swarm Theory", 2016),
         OriginalPublicationYear = replace_na(OriginalPublicationYear, 2019))

genrestats <- reads2019 %>%
  filter(Fiction == 1) %>%
  arrange(OriginalPublicationYear) %>%
  group_by(Childrens, Fantasy, SciFi, Mystery) %>%
  summarise(Books = n(),
            WomenAuthors = sum(Gender),
            AvgLength = mean(Pages),
            AvgRating = mean(MyRating),
            NewestBook = last(OriginalPublicationYear),
            OldestBook = first(OriginalPublicationYear))

# Now let's turn this summary into a nicer, labeled table.
genrestats <- genrestats %>%
  bind_cols(Genre = c("General Fiction",
                      "Mystery",
                      "Science Fiction",
                      "Fantasy",
                      "Fantasy SciFi",
                      "Children's Fiction",
                      "Children's Fantasy")) %>%
  ungroup() %>%
  select(Genre, everything(), -Childrens, -Fantasy, -SciFi, -Mystery)

#install.packages("expss")
library(expss)

as.etable(genrestats, rownames_as_row_labels = NULL)

#install.packages("ggthemes")
library(ggthemes)

reads2019 %>%
  mutate(Gender = factor(Gender, levels = c(0,1),
                         labels = c("Male",
                                    "Female")),
         Fiction = factor(Fiction, levels = c(0,1),
                          labels = c("Non-Fiction",
                                     "Fiction"),
                          ordered = TRUE)) %>%
  group_by(Gender, Fiction) %>%
  summarise(Books = n()) %>%
  ggplot(aes(Fiction, Books)) +
  geom_col(aes(fill = reorder(Gender, desc(Gender)))) +
  scale_fill_economist() +
  xlab("Genre") +
  labs(fill = "Author Gender")



