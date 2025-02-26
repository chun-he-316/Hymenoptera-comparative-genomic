# Quality control
fastp -i *_R1.fastq.gz -I *_R2.fastq.gz -o *_R1.clean.fastq.gz -O *_R2.clean.fastq.gz -c -h *.fastp.html -j *.fastp.json 
# Build index
salmon index -t transcript.fasta -i SalmonIndex -k 31 --keepDuplicates
# Calculate expression
salmon quant -i SalmonIndex -l A -1 *_R1.clean.fastq.gz -2 *_R2.clean.fastq.gz -o *_quant  --validateMappings 