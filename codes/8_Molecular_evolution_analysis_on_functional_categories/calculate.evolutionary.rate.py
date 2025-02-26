#!/usr/bin/python3
# This python code was used to calculate normalized evolutionary rate. We have to make sure that the topologies of the species tree and the gene tree are the same. For each OG in each category, the normalized evolutionary rate was estimated by averaging the ratio of amino acid substitution rates of interspecific homologous proteins to inter-species amino acid substitution rates.
from Bio import Phylo
import numpy as np
import os
speciestree = Phylo.read('27species.rooted.tree.txt',
                         'newick')  # species phylogenetic tree
speciesbranchLenlist = []
speciesnamelist = []
for i in speciestree.find_clades():
    speciesnamelist.append(i.name)
    speciesbranchLenlist.append(i.branch_length)
w = open('OG.EvolutionRate.txt', "w+")
# Specify the folder that contains the gene trees
for file in os.listdir("OG.treefiles.Rooted/"):
    if file.endswith(".nwk"):
        OG = file.split(".")[0]
        tree = Phylo.read('./OG.treefiles.Rooted/'+file, 'newick')
        genebranchLenlist = []
        genenamelist = []
        for i in tree.find_clades():
            genebranchLenlist.append(i.branch_length)
            genenamelist.append(i.name)
        normalValuelist = []
        for index in range(1, len(genebranchLenlist)):
            print(genebranchLenlist[index])
            print(index)
            normalValue = genebranchLenlist[index]/speciesbranchLenlist[index]
            normalValuelist.append(normalValue)
        result = np.mean(normalValuelist)
        w.write("%s\t%s\n" % (OG, result))
w.close()
