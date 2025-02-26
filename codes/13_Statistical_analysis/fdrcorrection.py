#!/usr/bin/python3
import pandas as pd
import statsmodels.stats.multitest as ssm
from statsmodels.stats.multitest import multipletests
df = pd.read_excel("GainAndLoss.rate.xlsx", header=0)
data = []
pvalues = list(df["Pvalue"])  # Specifies the pvalue values to be corrected
rejected, pvaluecorrected, _, _ = multipletests(
    pvalues, method='fdr_bh', is_sorted=False)
data.append(pvaluecorrected)
result = pd.DataFrame(
    data, index=["P.adj"])
result = result.T
result.to_csv("GainAndLoss.rate.adjustP.txt", sep="\t", index=False)
