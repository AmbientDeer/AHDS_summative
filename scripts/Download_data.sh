mkdir -p "raw"

echo "finish mkdir"

PMID_URL="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=%22long%20covid%22&retmax=10000" 


PMID_FILE="raw/pmids.xml"

echo "Downloading PMIDs..."
if curl -s "$PMID_URL" -o "$PMID_FILE"; then
    echo "PMIDs downloaded successfully: $PMID_FILE"
else
    echo "Error downloading PMIDs!" >&2
    exit 1
fi




pmids=$(awk -F'<Id>|</Id>' '/<Id>/{print $2}' raw/pmids.xml)

echo $pmids

for pmid in $pmids; do     echo "downloading PubMed ID 为: $pmid 的元数据";     curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${pmid}" > raw//article-data-$pmid.xml;     sleep 1; done
