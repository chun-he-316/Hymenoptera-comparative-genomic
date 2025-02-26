#!/usr/bin/python3
import pandas as pd
import numpy as np
from scipy.stats.contingency import odds_ratio
from scipy.stats import chi2_contingency
df = pd.read_excel("OG.branch.probabilities.xlsx",
                   sheet_name="count", header=0)
odddata = pd.DataFrame()
pvaluedata = pd.DataFrame()
w = open("chi2.txt", "w+")
for index, row in df.iterrows():
    a = int(row["Parasitoidacount"])
    b = int(row["stingercount"])  #
    c = 81-a
    d = 159-b
    array = np.array([[a, b], [c, d]])
    chi2 = chi2_contingency(array)
    oddratio = odds_ratio(array)
    interval = oddratio.confidence_interval(confidence_level=0.95)
    w.write("%s\t%s\t%s\t%s\t%s\t%s\n" % (
        row["OG"], chi2.statistic, chi2.pvalue, oddratio.statistic, interval.low, interval.high))
w.close()
