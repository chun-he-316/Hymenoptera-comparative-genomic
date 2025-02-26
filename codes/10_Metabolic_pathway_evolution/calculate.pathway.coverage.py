#!/usr/bin/python3
from collections import defaultdict
adict = defaultdict(list)
adict1 = defaultdict(list)
descrip = {}
descriptionadict = {}
with open("ko00001.keg", "r")as f:
    lines = f.readlines()
for line in lines:
    line = line.strip()
    if line.startswith("C"):
        if len(line.split(":")) > 1:
            pathway = line.split(":")[1].split("]")[0]
            descriptionadict[pathway] = ' '.join(
                line.split("[")[0].split()[2:])
            adict[pathway] = []
    elif line.startswith("D"):
        if len(line.split("EC:")) > 1:
            EC = line.split("EC:")[1].split("]")[0]
            for i in EC.split()[:]:
                adict[pathway].append(i)
for key in adict.keys():
    adict1[key] = list(set(adict[key]))
sawfly = ["Athalia_rosae", "Rhogogaster_chlorosoma", "Tenthredo_mesomela", "Tenthredo_notha",
          "Diprion_similis", "Neodiprion_lecontei", "Neodiprion_virginianus", "Neodiprion_fabricii"]
pathway2sawflyECadict = defaultdict(list)
for key in adict.keys():
    allEC = adict1[key]
    allsawflyECS = []
    for spec in sawfly:
        with open(spec+"_eggnog.emapper.annotations", "r")as f:
            lines = f.readlines()
        for line in lines:
            line = line.strip()
            if not line.startswith("#"):
                if line.split("\t")[10] != "-":
                    for i in line.split("\t")[10].split(",")[:]:
                        allsawflyECS.append(i)
    res = list(set(allEC) & set(allsawflyECS))
    sawflyNum = len(res)
    sawflyECS = list(set(res))
    pathway2sawflyECadict[key] = sawflyECS

species = ["Ampulex_compressa", ..., "Mischocyttarus_mexicanus"]
p = open("pathway.coverage.sawflyReference.txt", "w+")
p.write(f"pathway")
for spec in species:
    p.write("\t%s" % (spec))
p.write("\n")
for key in adict.keys():
    sawflyECS = pathway2sawflyECadict[key]
    if len(sawflyECS) > 0:
        p.write(key)
        for spec in species:
            ECS = []
            with open("spec"+"_eggnog.emapper.annotations", "r")as f:
                lines = f.readlines()
            for line in lines:
                line = line.strip()
                if not line.startswith("#"):
                    if line.split("\t")[10] != "-":
                        for i in line.split("\t")[10].split(",")[:]:
                            ECS.append(i)
            f.close()
            res = list(set(sawflyECS) & set(ECS))
            specNum = str(len(res))
            if len(sawflyECS) > 0:
                coverage = str(float(len(res)/len(sawflyECS)))
            else:
                coverage = "-"
            p.write("\t%s" % (coverage))
        p.write("\n")
p.close()
