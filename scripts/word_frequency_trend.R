# Load required libraries
library(tidytext)
library(dplyr)
library(ggplot2)
library(stringr)
library(SnowballC)

# Load the clean data
data <- read.delim("clean/processed_articles_final.tsv", 
                   header = TRUE, stringsAsFactors = FALSE, quote = "")

# Ensure no missing titles or years
data <- data %>%
  filter(!is.na(processed_title), !is.na(Year))

# Tokenize the titles into individual words
tidy_data <- data %>%
  unnest_tokens(word, processed_title)

# Remove punctuation, stop words, and digits
clean_data <- tidy_data %>%
  mutate(word = str_replace_all(word, "[[:punct:]]", "")) %>% # Remove punctuation
  anti_join(stop_words, by = "word") %>%                     # Remove stop words
  filter(!str_detect(word, "^[0-9]+$")) %>%                  # Remove digits
  mutate(word = wordStem(word))                             # Stem the words

# Count word frequencies by year
word_year_counts <- clean_data %>%
  group_by(Year, word) %>%
  summarize(frequency = n(), .groups = "drop")

# Find the top words by total frequency
top_words <- word_year_counts %>%
  group_by(word) %>%
  summarize(total_frequency = sum(frequency), .groups = "drop") %>%
  arrange(desc(total_frequency)) %>%
  slice(1:10) %>%  # Select top 10 most frequent words
  pull(word)

# Filter for top words
filtered_data <- word_year_counts %>%
  filter(word %in% top_words)

# Plot changes in word frequency over time
gg <- ggplot(filtered_data, aes(x = Year, y = frequency, color = word)) +
  geom_line(size = 1) +
  labs(
    title = "Change in Word Frequency Over Time in Article Titles",
    x = "Year",
    y = "Word Frequency",
    color = "Top Words"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title = element_text(size = 12)
  )

ggsave("plot/Word_Frequency_Trends.png", width = 8, height = 6)