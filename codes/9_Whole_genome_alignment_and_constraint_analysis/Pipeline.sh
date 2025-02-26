# 1. Whole genome alignment
docker run -v $(pwd):/dir/to/cactus/cactus-v2.8.1 --security-opt seccomp:unconfined --rm quay.io/comparative-genomics-toolkit/cactus:v2.8.1 cactus /dir/to/cactus/cactus-v2.8.1/js /dir/to/cactus/cactus-v2.8.0/evolver27species.txt /dir/to/cactus/cactus-v2.8.0/evolver27species.hal
docker run -v $(pwd):/dir/to/cactus/cactus-v2.8.1 --security-opt seccomp:unconfined --rm quay.io/comparative-genomics-toolkit/cactus:v2.8.1 cactus-hal2maf /dir/to/cactus/cactus-v2.8.1/js_hal2maf /dir/to/cactus/cactus-v2.8.1/evolver27species.hal /dir/to/cactus/cactus-v2.8.1/evolver27species.BterRef.maf.gz --refGenome Bombus_terrestris --coverage --chunkSize 500000 --dupeMode single --logFile /dir/to/cactus/cactus-v2.8.1/evolver27species.BterRef.maf.gz.log

# split mafs
mafSplit _.bed BterRefMaf evolver27species.BterRef.maf -byTarget -useFullSequenceName

# 2. Generate .mod file using PhyloFit
awk '$3=="CDS"' Bombus_terrestris.gff3 > Bter.genes.gff
# split gff
awk '{print $1}' Bter.genes.gff|sort|uniq > Bombus_terrestris.genes.gff.list
for name in `cat Bombus_terrestris.genes.gff.list`;do echo $name;awk -v t=$name '$1==t{OFS="\t";$1="Bombus_terrestris."t;print $0}' Bter.genes.gff > Bombus_terrestris.gffs/Bombus_terrestris.genes.${name}.gff;done
# To run PhyloFit, we need to extract the 4d-sites.
for name in `cat Bombus_terrestris.genes.gff.list`;do echo $name;msa_view BterRefMaf/${name}.maf --4d --features Bombus_terrestris.gffs/Bombus_terrestris.genes.${name}.gff > BterRef.4d-codons_ss/4d-codons.${name}.ss;done

for name in `cat Bombus_terrestris.genes.gff.list`;do echo $name;msa_view BterRef.4d-codons_ss/4d-codons.${name}.ss --in-format SS --out-format SS --tuple-size 1 > BterRef.4d-sites/4d-sites.${name}.ss;done

ll BterRef.4d-sites/4d-sites.*|awk '$5!=0'|awk '{print $9}' > BterRef.z.nonzero.list
for name in `cat BterRef.z.nonzero.list`;do echo $name;cp $name ./BterRef.4d_merge/;done

msa_view --unordered-ss --out-format SS --aggregate Bombus_terrestris,Apis_mellifera,Macropis_europaea,Ampulex_compressa,Ooceraea_biroi,Vespa_crabro,Gonatopus_flavifemur,Nasonia_vitripennis,Pteromalus_puparum,Ceratosolen_solmsi,Eupristina_verticillata,Eretmocerus_hayati,Trichogramma_pretiosum,Telenomus_remus,Leptopilina_boulardi,Belonocnema_kinseyi,Cotesia_glomerata,Microplitis_demolitor,Chelonus_insularis,Habrobracon_hebetor,Aphidius_gifuensis,Ichneumon_xanthorius,Buathra_laborator,Orussus_abietinus,Neodiprion_lecontei,Tenthredo_mesomela,Athalia_rosae,Anc25,Anc24,Anc23,Anc22,Anc21,Anc20,Anc19,Anc18,Anc17,Anc16,Anc15,Anc14,Anc13,Anc12,Anc11,Anc10,Anc09,Anc08,Anc07,Anc06,Anc05,Anc04,Anc03,Anc02,Anc01,Anc00 ./BterRef.4d_merge/4d-sites.*.ss > Bombus_terrestris.all-4d.sites.ss

# Finally calculate PhyloFit model:
phyloFit --tree 27species.tree.txt --subst-mod REV --msa-format SS --out-root 27species.BterRef.4d.mod Bombus_terrestris.all-4d.sites.ss

# 3. Run PhastCons
ls BterRefMaf/*.maf|awk '{print "phastCons --target-coverage 0.3 --expected-length 45 --rho 0.3 --most-conserved",$1".PhastCons.4d.conserved.bed",$1,"27species.BterRef.4d.mod.mod>"$1".PhastCons.4d.wig"}' > Zscripts.4d.PhastCons  
bash Zscripts.4d.PhastCons
cat *4d.conserved.bed > 27species.Bter.4d.Conservation.bed 
cut -c6- 27species.Bter.4d.Conservation.bed > 27species.Bter.4d.Conservation.bed6

# 4. Run phyloP
ls BterRefMaf/*.maf|awk '{print "phyloP --mode CONACC --method LRT --wig-scores 27species.BterRef.noAnc.4d.mod.mod",$1,">",$1".PhyloP.wig"}' > Zscripts.4d.noAnc.PhyloP
bash Zscripts.4d.noAnc.PhyloP
cat *PhastCons.4d.wig > 27species.Bter.PhastCons.4d.wig    
cat *PhyloP.wig > 27species.Bter.PhyloP.4d.wig 

# 5. Calculate reference genome size aligned to at least one species.
python get.aligned.based.py

# 6. Estimate the number of constrained and accelerated bases.
~/software/bedops/bin/wig2bed --do-not-sort < 27species.Bter.PhyloP.4d.wig > 27species.Bter.PhyloP.4d.wig.bed &
awk '$5 > 0' 27species.Bter.PhyloP.4d.wig.bed | wc -l # constrained bases
awk '$5 < 0' 27species.Bter.PhyloP.4d.wig.bed | wc -l # accelerated bases

# 7. Calculate average phyloP score of the coding sequence of each gene.
python get.cds.phylop.py

# 8. Atac-seq analysis
# Sequence trimming
trimmomatic SE -threads 56 -phred33 SRRXXXXX.fastq.gz SRRXXXXX.Nextera.trimmed.fastq.gz -trimlog  SRRXXXXX.Nextera.trimlog ILLUMINACLIP:NexteraPE-PE.fa:2:30:10 SLIDINGWINDOW:4:15 LEADING:3 TRAILING:3 MINLEN:36 HEADCROP:10 > SRRXXXXX.trimmed.log 
# Alignment 
bowtie2-build ../08_WGA/01_softmasked/EDTA/Bombus_terrestris.genome.fa.new.masked Bter
bowtie2 --very-sensitive -X 2000 -x Bter -p 20 -U SRRXXXXX.trimmed.fastq.gz -S SRRXXXXX.sam

samtools view -@ 20 -b SRRXXXXX.sam > SRRXXXXX.sam.bam
samtools sort -@ 20 SRRXXXXX.sam.bam -o SRRXXXXX.sorted.bam

# Remove reads unmapped, mate unmapped, not primary alignment, reads failing platform, duplicates
picard MarkDuplicates I=SRRXXXXX.sorted.bam O=SRRXXXXX.sorted.picard.bam M=dups.SRRXXXXX.txt REMOVE_DUPLICATES=true
samtools view -h -b -q 30 -F 1804 SRRXXXXX.sorted.picard.bam > SRRXXXXX.sorted.picard.rmMulti.bam

# Remove mitochondrial reads
samtools view -h SRRXXXXX.sorted.picard.rmMulti.bam | grep -v 'chrM' | samtools view -bS -o SRRXXXXX.final.bam

# Peak calling
macs2 callpeak -f BAM -t SRRXXXXX.final.bam -n SRRXXXXX.final.bam -g 392948208 --outdir ./SRRXXXXX_macs2/ --bdg -q 0.05
sort -k8,8nr SRRXXXXX_peaks.narrowPeak > SRRXXXXX_peaks.sorted.narrowPeak
idr --samples SRRXXXXX1_peaks.sorted.narrowPeak SRRXXXXX2_peaks.sorted.narrowPeak --input-file-type narrowPeak --rank p.value --output-file SRRXXXXX-idr --plot --log-output-file SRRXXXXX.idr.log # SRRXXXXX1 and SRRXXXXX2 represent two duplicates of the same developmental stage.
cat adult-idr pupae-idr  larva-idr egg-idr > all.stages.idr
sort -k1,1 -k2,2n all.stages.idr > all.stages.idr.sorted
bedtools merge -d 5 -i all.stages.idr.sorted > all.stages.idr.sorted.merge

# 9. Conserved elements (CE) analysis
# Get CEs conserved across all species in our 27-way alignment.
python get.conserved.CE.py

# Get CEs intersect with CDS.
bedtools intersect -a CE.27speciesAligned.txt -b Bter.cds.bed -wa > CE.insertsetCDS.bed
# Then remove CEs in 27species.Bter.4d.Conservation.insertsetCDS.bed from 27species.Bter.4d.Conservation.bed to get CNEs longer than 20 bp.
awk '$3 - $2 > 20' CE.27speciesAligned.txt | grep -v -F -f CE.insertsetCDS.bed > 27species.Bter.4d.CNE.longer20bp.bed
# Obtain conserved non-coding elements that intersect with accessible chromatin regions supported by ATAC-Seq.
bedtools intersect -a 27species.Bter.4d.CNE.longer20bp.bed -b all.stages.idr.sorted.merge -wa > overlaps.CNE.atac-seq.bed