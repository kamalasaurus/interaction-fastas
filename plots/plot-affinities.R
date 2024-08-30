affinities <- read.csv("/Users/kamal/Documents/NYU/bergelson-huang-lab/interaction-fastas/binding-affinities/affinities.tsv", sep="\t")

full_affinities <- read.csv("/Users/kamal/Documents/NYU/bergelson-huang-lab/interaction-fastas/binding-affinities/affinities-merged.tsv", sep="\t")

png("/Users/kamal/Documents/NYU/bergelson-huang-lab/interaction-fastas/plots/affinities_hist.png")

par(mfrow = c(2, 2))
hist(affinities[, 2])
plot(full_affinities$fraction_disordered, full_affinities$affinity)
plot(full_affinities$ptm, full_affinities$affinity)
plot(full_affinities$iptm, full_affinities$affinity)
dev.off()

plot(full_affinities$ranking_score, full_affinities$affinity)

#(0.2*pTM+0.8*ipTM)

plot(0.2*full_affinities$ptm + 0.8*full_affinities$iptm, full_affinities$affinity)
