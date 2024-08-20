affinities <- read.csv("/Users/kamal/Documents/NYU/bergelson-huang-lab/interaction-fastas/binding-affinities/affinities.tsv", sep="\t")

png("/Users/kamal/Documents/NYU/bergelson-huang-lab/interaction-fastas/plots/affinities_hist.png")
hist(affinities[, 2])
dev.off()
