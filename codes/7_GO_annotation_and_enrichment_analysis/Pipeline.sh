# Annotated proteins from using eggNOG-mapper v2 (Cantalapiedra et al. 2021) against the eggNOG5 database.
python emapper.py --cpu 56 -i pep.fasta -o eggnog.out
# GO enrichment analysis
python go.enrich.py -bg Background.txt -gl test_GO.txt -o GO.enrichment.out