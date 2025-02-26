#!/usr/bin/python3
from Bio import AlignIO
import os

for file in os.listdir("BterRefMaf/"):
    if file.endswith("maf"):
        for multiple_alignment in AlignIO.parse("BterRefMaf/"+file, "maf"):
            print("printing a new multiple alignment")
            # print(multiple_alignment)

            for seqrec in multiple_alignment:
                if seqrec.id.startswith("Bombus_terrestris"):
                    # print(seqrec.annotations)
                    print(
                        "on chr %s starts at %s on the %s strand of a sequence %s in length, and runs for %s bp"
                        % (
                            file.split(".")[0]+"."+file.split(".")[1],
                            seqrec.annotations["start"],
                            seqrec.annotations["strand"],
                            seqrec.annotations["srcSize"],
                            seqrec.annotations["size"],
                        )
                    )
with open("AlignIO.seqrec.txt", "r")as f:
    lines = f.readlines()
length = 0
for line in lines:
    line = line.strip()
    if line.startswith("on"):
        len = line.split()[-2]
        length = length+int(len)

print(length)
