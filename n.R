# Today, we'll start digging into some of the functions used to summarise data. 
# The full summarise function will be covered for the letter S. 
# For now, let's look at one function from the tidyverse that can give some overall information about a dataset: n_distinct.

# This function counts the number of unique values in a vector or variable. 
# There are 87 books in my 2019 reading list, but I read multiple books by the same author(s). Let's see how many authors there are in my set.
library(tidyverse)
library(magrittr)

reads2019 <- read_csv("./SaraReads2019_allrated.csv",
                      col_names = TRUE)
reads2019 %$% n_distinct(Author)
## [1] 42

# So while there are 87 books in my dataset, there are only 42 authors. Let's see who the top authors are.
reads2019 %>%
  group_by(Author) %>%
  summarise(Books = n()) %>%
  arrange(desc(Books), Author) %>%
  filter(between(row_number(), 1, 10))

# n_distinct can also be used in conjunction with other functions, like filter or group_by.
library(tidytext)

titlewords <- reads2019 %>%
  unnest_tokens(titleword, Title) %>%
  select(titleword, Author, Book.ID) %>%
  left_join(reads2019, by = c("Book.ID", "Author"))

titlewords %>%
  group_by(Title) %>%
  summarise(unique_words = n_distinct(titleword),
            total_words = n())

# This chunk of code separated title into its individual words, then counted the number of unique words within each book title. 
# For many cases, some words are reused multiple times in the same title - often words like "of" or "to". We could also write some code to tell us how many unique words are used across all titles.
titlewords %$%
  n_distinct(titleword)
## [1] 224

# There are, overall, 458 titlewords that make up the titles of the books in the dataset, but only 224 distinct words are used. 
# This means that many titles are using the same words as others. Once again, these are probably common words. 
# Let's see what happens when we remove those common words.
titlewords <- titlewords %>%
  anti_join(stop_words, by = c("titleword" = "word"))

titlewords %$%
  n_distinct(titleword)
## [1] 181

# After removing stopwords, there are now 306 individual words, but only 181 distinct ones.

