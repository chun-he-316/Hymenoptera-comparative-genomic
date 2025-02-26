library(constellatoR)
OGs <- "Orthogroups.tsv" # from orthofinder
GOsdir= "131species.eggnog" # the dir includes eggnog annotation results of all species
species <- c("Ampulex_compressa",...,"Mischocyttarus_mexicanus")

GOsfromOGs <- prepareGOsfromOGs(OGs, GOsdir, species = species,cores=28)
tested_OGs <- c("OG0009248", "OG0009250", "OG0009251", "OG0009252", "OG0009253", "OG0009254", "OG0009258", "OG0009261", "OG0009267", "OG0009268", "OG0009269", "OG0009271")

semSim <- getSemSim(GOsfromOGs = GOsfromOGs, selectedOGs = tested_OGs)
simMat <- getSimMat(GOsfromOGs = GOsfromOGs, selectedOGs = tested_OGs, semSim = semSim)
write.table(simMat, 'simMat.txt', col.names = NA, sep = '\t', quote = FALSE)
clusters <- clusterOGs(simMat)
write.table(clusters, 'clusters.txt', col.names = NA, sep = '\t', quote = FALSE)