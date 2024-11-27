curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=%22long%20covid%22&retmax=10000" > raw/pmids.xml

pmids=$(awk -F'<Id>|</Id>' '/<Id>/{print $2}' raw/pmids.xml)

echo $pmids

for pmid in $pmids; do     echo "正在下载 PubMed ID 为: $pmid 的元数据";     curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${pmid}" > raw//article-data-$pmid.xml;     sleep 1; done
