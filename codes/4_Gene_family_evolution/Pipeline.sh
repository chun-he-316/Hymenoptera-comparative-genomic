# Orthogroups.GeneCount.tsv from the results of orthofinder
awk 'OFS="\t" {$NF=""; print}' Orthogroups.GeneCount.tsv > tmp  
awk '{print "(null)""\t"$0}' tmp > cafe.input.tsv 
sed -i '1s/(null)/Desc/g' cafe.input.tsv
# Screen out gene families with more than 100 gene copies in one or more species.
python ./CAFE5/tutorial/clade_and_size_filter.py -i cafe.input.tsv -o filtered.cafe.input.tsv -s 
# Run cafe5 to analyse gene family expansion and contraction
cafe5 -i filtered.cafe.input.tsv -t finaltree.afterR8s.txt --pvalue 0.05 