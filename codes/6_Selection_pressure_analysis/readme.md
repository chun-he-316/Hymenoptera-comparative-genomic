Detect positively selected genes

```
hyphy absrel --alignment cds.aligned.fasta --tree species.treefile.txt --output hyphy.absrel.output --branches Foreground
```

In order to compare selection pressure between Parasitoida and Aculeata clades, we need to calculated the dN/dS ratio for each branch in the phylogenetic tree using the free-ratio model in PAML 4.9. We also performed the one-ratio model and compared it to the free-ratio model via a likelihood-ratio test to determine if the free-ratio model provided a significantly better fit to the data.

```shell
# Alternative hypothesis: dN/dS varies across branches. Calculate the dN/dS ratio for each branch in the phylogenetic tree using the free-ratio model (model = 1, NSsites = 0 in Alter.ctl).
./paml4.9j/bin/codeml Alter.ctl
# Null hypothesis: all branches have a consistent dN/dS. Calculate the dN/dS ratio using the one-ratio model (model = 0, NSsites = 0 in Null.ctl).
./paml4.9j/bin/codeml Null.ctl
```

From the result files of the two hypotheses, ΔLRT and df are calculated according to `ΔLRT = abs(2 × (lnL1-lnL0)), df = np1-np0`. For example:
Alternative hypothesis:lnL(ntime: 52 np:105): -38433.917349 +0.000000
Null hypothesis:lnL(ntime: 52 np:104): -38431.911492 +0.000000
Then `ΔLRT = abs(2 × (-38433.917349 + 38431.911492)) = 4.011714, df = 105 - 104`
Use the command `chi2 1 4.011714` in linux systems to calculate the P value
If the likelihood-ratio test favors the alternative model and the chi-square test yields a P value < 0.05, we used the corresponding dN/dS from the free-ratio model for subsequent Mann-Whitney U tests.
