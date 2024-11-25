#!/bin/bash

# Directory containing the downloaded XML files
input_dir="/Users/linzexuan/Downloads/Uni/Bristol/Data science summative/data/raw"
output_dir="/Users/linzexuan/Downloads/Uni/Bristol/Data science summative/data/clean"
output_file="$output_dir/processed_articles.tsv"

# Ensure the output directory exists
mkdir -p "$output_dir"

# Create or overwrite the output file and add the header
echo -e "PMID\tYear\tTitle" > "$output_file"

# Process each XML file
processed_files=0
for file in "$input_dir"/article-data-*.xml; do
    # Extract PMID from the file name
    pmid=$(basename "$file" | sed -E 's/article-data-([0-9]+)\.xml/\1/')

    # Extract the first title and year
    title=$(grep '<ArticleTitle>' "$file" | head -n 1 | sed -n 's:.*<ArticleTitle>\(.*\)</ArticleTitle>.*:\1:p' | sed 's/<[^>]*>//g')
    year=$(grep '<Year>' "$file" | head -n 1 | sed -n 's:.*<Year>\(.*\)</Year>.*:\1:p')

    # Skip entries without a title
    if [[ -n "$title" ]]; then
        echo -e "$pmid\t$year\t$title" >> "$output_file"
        ((processed_files++))
    fi
done

echo "Processing complete. $processed_files files processed."
echo "Extracted data saved to $output_file."
