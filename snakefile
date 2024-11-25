rule all:
    input:
        expand("data/raw/article-data-{pmid}.xml", pmid=range(1, 10000))

rule fetch_pmids:
    output:
        "data/raw/pmids.xml"
    shell:
        """
        curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=%22long%20covid%22&retmax=10000" > {output}
        """

rule fetch_articles:
    input:
        "data/raw/pmids.xml"
    output:
        "data/raw/article-data-{pmid}.xml"
    shell:
        """
        pmids=$(awk -F'<Id>|</Id>' '/<Id>/{print $2}' {input})
        echo $pmids
        for pmid in $pmids; do
            if [ "$pmid" == "{wildcards.pmid}" ]; then
                echo "正在下载 PubMed ID 为: $pmid 的元数据"
                curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${pmid}" > {output}
                sleep 1
            fi
        done
        """
