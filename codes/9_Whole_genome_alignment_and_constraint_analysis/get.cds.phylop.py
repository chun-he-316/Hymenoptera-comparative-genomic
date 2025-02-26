#!/usr/bin/python3
import re
from collections import defaultdict
import pandas as pd
import numpy as np
df = pd.read_csv("27species.Bter.PhyloP.4d.wig.bed",
                 sep="\t", header=0)
df.columns = ['chr', "s", "e", "id", "-log10p"]
w = open("protein.meanPhyloP.txt", "w+")
cdsadict = defaultdict(list)
with open("Bombus_terrestris.gtf", "r")as f:
    lines = f.readlines()
for line in lines:
    line = line.strip()
    if line.split("\t")[2] == "CDS":
        s = line.split("\t")[3]
        e = line.split("\t")[4]
        chr = line.split("\t")[0]
        protein_id = re.search('protein_id "(\S+)";', line).group(1)
        trans_id = re.search('transcript_id "(\S+)";', line).group(1)
        cdsadict[protein_id].append([chr, s, e, trans_id])
for protein in cdsadict.keys():
    allscores = []
    cdslen = 0
    for cds in cdsadict[protein]:
        df1 = df[df["chr"] == cds[0]]
        subset = df1[(df1['s'] >= int(cds[1])) & (df1['e'] <= int(cds[2]))]
        scores = list(subset["-log10p"])
        allscores = allscores+scores
        trans_id = cds[3]
        cdslen = cdslen+int(cds[2])-int(cds[1])+1
    if len(allscores) > 0:
        maxscore = max(allscores)
        minscore = min(allscores)
        meanscore = np.mean(allscores)
        print(protein, trans_id, meanscore, maxscore,
              minscore, cdslen, len(allscores))
        w.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (protein, trans_id,
                meanscore, maxscore, minscore, cdslen, len(allscores)))
w.close()
