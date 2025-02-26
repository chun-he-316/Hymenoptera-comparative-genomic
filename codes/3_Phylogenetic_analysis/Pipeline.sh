# Use the multiple alignment file produced by orthofinder to construct phylogenetic tree.
iqtree -s SpeciesTreeAlignment.fa -m MFP -B 1000 -T 112 
# The datafile.hy.nex file contains the calibration points, which are then utilized to estimate divergence times with r8s.
r8s -b -f datafile.hy.nex > r8s.output.txt