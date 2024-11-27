# Load libraries
library(tidytext)
library(dplyr)
library(stringr)
library(NLP)
library(tm)


# Load the clean data
data <- read.delim("clean/processed_articles.tsv", 
                   header = TRUE, stringsAsFactors = FALSE, quote = "")
# Preview the data
head(data)

# Tokenise the titles into individual words
tidy_data <- data %>%
  unnest_tokens(word, Title)
# Preview the tidy dataset
head(tidy_data)

# Remove stop words and digits
clean_data <- tidy_data %>%
  anti_join(stop_words, by = "word") %>% # Remove stop words
  filter(!str_detect(word, "^[0-9]+$"))  # Remove digits
# Preview cleaned data
head(clean_data)

# Stem the words
clean_data <- clean_data %>%
  mutate(word = SnowballC::wordStem(word))
# Preview data after stemming
head(clean_data)

# Recombine words into processed titles
processed_titles <- clean_data %>%
  group_by(PMID) %>%
  summarize(processed_title = paste(word, collapse = " ")) %>%
  ungroup()
# Join with the original data to retain other columns
final_data <- data %>%
  select(PMID, Year) %>%  # Retain original columns
  left_join(processed_titles, by = "PMID")
# Preview the final data
head(final_data)

# Save to a new TSV file
write.table(final_data, 
            "clean/processed_articles_final.tsv", 
            sep = "\t", row.names = FALSE, quote = FALSE)





