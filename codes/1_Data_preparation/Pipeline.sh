# Assess quality of each genome
python ./quast-5.2.0/quast.py -t 10 -o quast_out genome.fasta -m 1
# Assess completeness of genome annotation
busco -i pep.fasta -c 10 -o busco_out -m prot -f -l ./database/busco_download/insecta_odb10 --offline
# Identify chimeric and broken genes. 
python ./Broccoli-master/broccoli.py -dir pep -threads 10 -path_diamond diamond
# Codes used for detailed correction procedures are from https://github.com/fedemantica/bilaterian_GE/tree/main/Analysis/1_PRELIMINARY_ANNOTATION_FIXES.