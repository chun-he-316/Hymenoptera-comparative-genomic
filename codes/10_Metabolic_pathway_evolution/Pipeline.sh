# KEGG annotation
python emapper.py --cpu 56 -i pep.fasta -o eggnog.out

# Calculate pathway coverage
python calculate.pathway.coverage.py
