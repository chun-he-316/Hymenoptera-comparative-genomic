#!/usr/bin/python3
import pandas as pd
from Bio.AlignIO.MafIO import MafIndex
import os
df = pd.read_csv("27species.Bter.4d.Conservation.bed", sep="\t", header=0)
df.columns = ["chr", "s", "e", "id", "frame", "strand"]


def is_all_hyphens(string):
    return string.strip("-").strip() == ""


w = open("CE.27speciesAligned.txt", "w+")
for file in os.listdir("./BterRefMaf/"):
    if file.endswith(".maf"):
        LG = file.split(".")[0]+"."+file.split(".")[1]
        # print(LG)
        idx = MafIndex(LG+".mafindex", "./BterRefMaf/" +
                       file, "Bombus_terrestris."+LG)
        dfchr = df[df["chr"] == LG]
        for index, row in dfchr.iterrows():
            s = row["s"]
            e = row["e"]
            multiple_alignment = idx.get_spliced([s], [e], strand=1)
            # print(multiple_alignment)
            specieslist = []
            study_species = 0
            outgroup = 0
            for seqrec in multiple_alignment:
                if not str(seqrec.id).startswith("Anc"):
                    if is_all_hyphens(seqrec.seq) == False:
                        specieslist.append(seqrec.id.split(".")[0])
            specieslist1 = list(set(specieslist))
            count = len(specieslist1)
            if count == 27:
                w.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (
                    row["id"], row["chr"], row['s'], row["e"], row["id"], row["frame"], row["strand"], count))
w.close()
