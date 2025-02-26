# The domains were identified using hmmscan and then CAFE5 was used to perform the same domain family evolution analysis as the gene family analysis.
hmmscan --tblout pep.domain.tblout -E 0.00001 --cpu 112 ./pfamA/Pfam-A.hmm pep.fasta
# Use PfamScan to identify domains of proteins
perl ./PfamScan/pfam_scan.pl -fasta pep.fasta -dir {path to pfamA database} -outfile PfamScanRes
# Use domRates to detect domain rearrangement events.
./DomRates/build/domRates -t species.tree.txt -a PfamScanRes --outgroup "Athalia_rosae;Rhogogaster_chlorosoma;Tenthredo_mesomela;Tenthredo_notha;Diprion_similis;Neodiprion_lecontei;Neodiprion_virginianus;Neodiprion_fabricii" -o rearrangement_freqs.txt -s stats_file.txt
# Visualization of domain rearrangement events
python ./DomRates/src/visualization_domrates_tree.py -t species.tree.txt -s stats_file.txt -o tree_event_distr