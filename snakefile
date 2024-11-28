# Rule to download raw data
rule download_data:
    output:
        "raw/pmids.xml"
    shell:
        """
	mkdir -p raw
	bash ./scripts/Download_data.sh
	"""

# Rule to process raw data
rule process_data:
    input:
        "raw/pmids.xml"
    output:
        "clean/processed_articles.tsv"
    shell:
        """
	mkdir -p clean
	bash ./scripts/process_data.sh
	"""

# Rule to process titles
rule process_titles:
    input:
        "clean/processed_articles.tsv"
    output:
        "clean/processed_articles_final.tsv"
    script:
        "scripts/process_titles.R"

# Rule to generate word frequency visualization
rule word_frequency_trend:
    input:
        "clean/processed_articles_final.tsv"
    output:
        "plot/Word_Frequency_Trends.png"
    script:
        "scripts/word_frequency_trend.R"

# Workflow execution order
rule all:
    input:
	"plot/Word_Frequency_Trends.png"
