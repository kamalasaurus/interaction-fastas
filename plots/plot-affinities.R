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

full_affinities$confidence = 0.2*full_affinities$ptm + 0.8*full_affinities$iptm

plot(0.2*full_affinities$ptm + 0.8*full_affinities$iptm, full_affinities$affinity)

plot(full_affinities$fraction_disordered, 0.2*full_affinities$ptm + 0.8*full_affinities$iptm)

var(full_affinities$affinity)

matrix_data <- as.matrix(full_affinities[, c("fraction_disordered", "affinity")])

# Define the breaks for the ranges
breaks <- c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)

# Use the cut function to create a factor for the ranges
full_affinities$disordered_bin <- cut(full_affinities$fraction_disordered, breaks = breaks, include.lowest = TRUE)

# Split the data frame into subsets based on the disordered_bin column
split_data <- split(full_affinities, full_affinities$disordered_bin)

metrix <- lapply(split_data, function(df) {
  mu <- mean(df$affinity, na.rm = TRUE)
  si <- var(df$affinity, na.rm = TRUE)
  bin <- df$disordered_bin[1]
  return(list(mu = mu, si = si, bin = bin))
})

# Convert the list of lists to a data frame
matrix_data <- do.call(rbind, metrix)
metrix_df <- as.data.frame(matrix_data)
metrix_df

split_df <- as.data.frame(do.call(rbind, split_data))


library(ggplot2)

plot1 <- ggplot(split_df, aes(x = disordered_bin, y = affinity)) +
  geom_boxplot() +
  labs(title = "Box Plot of Affinity by Fraction Disordered",
       x = "Fraction Disordered",
       y = "Mean Affinity") +
  theme_minimal()

plot1a <- ggplot(split_df, aes(x = disordered_bin, y = affinity)) +
  geom_violin() +
  labs(title = "Box Plot of Affinity by Fraction Disordered",
       x = "Fraction Disordered",
       y = "Mean Affinity") +
  theme_minimal()

plot1 <- ggplot(split_df, aes(x = disordered_bin, y = affinity)) +
  geom_boxplot() +
  labs(title = "Box Plot of Affinity by Fraction Disordered",
       x = "Fraction Disordered",
       y = "Mean Affinity") +
  geom_jitter(height = 0, width = NULL) +
  theme_minimal()

ggsave("boxplot_affinity_by_fraction_disordered.png", plot = plot1, width = 8, height = 6, device = "png", bg = "white")

plot2 <- ggplot(split_df, aes(x = disordered_bin, y = confidence)) +
  geom_boxplot() +
  labs(title = "Box Plot of Confidence by Fraction Disordered",
       x = "Fraction Disordered",
       y = "Confidence (0.2*pTM+0.8*ipTM)") +
  theme_minimal()

plot2a <- ggplot(split_df, aes(x = disordered_bin, y = confidence)) +
  geom_violin() +
  labs(title = "Box Plot of Confidence by Fraction Disordered",
       x = "Fraction Disordered",
       y = "Confidence (0.2*pTM+0.8*ipTM)") +
  theme_minimal()

ggsave("histogram_affinity.png", plot = plot2, width = 8, height = 6, device = "png", bg = "white")


# Use the cut function to create a factor for the ranges
full_affinities$confidence_bin <- cut(full_affinities$confidence, breaks = breaks, include.lowest = TRUE)

# Split the data frame into subsets based on the disordered_bin column
split_conf_data <- split(full_affinities, full_affinities$confidence_bin)

split_conf_df <- as.data.frame(do.call(rbind, split_conf_data))

plot3 <- ggplot(split_conf_df, aes(x = confidence_bin, y = affinity)) +
  geom_boxplot() +
  labs(title = "Box Plot of Affinity by Confidence",
       x = "Confidence (0.2*pTM+0.8*ipTM)",
       y = "Mean Affinity") +
  theme_minimal()

plot3a <- ggplot(split_conf_df, aes(x = confidence_bin, y = affinity)) +
  geom_violin() +
  labs(title = "Box Plot of Affinity by Confidence",
       x = "Confidence (0.2*pTM+0.8*ipTM)",
       y = "Mean Affinity") +
  theme_minimal()

ggsave("confidence_affinity.png", plot = plot3, width = 8, height = 6, device = "png", bg = "white")



#library(dplyr)

# Ensure the fraction_disordered column exists
#if (!"fraction_disordered" %in% colnames(full_affinities)) {
#  stop("The column 'fraction_disordered' does not exist in the data frame.")
#}

# Create a new column for binned fraction_disordered
#full_affinities <- full_affinities %>%
#  mutate(disordered_bin = cut(fraction_disordered, breaks = seq(0, 1, by = 0.1), include.lowest = TRUE))

# Calculate variance of affinity for each bin
#variance_data <- full_affinities %>%
#  group_by(disordered_bin) %>%
#  summarise(variance_affinity = var(affinity, na.rm = TRUE))

# Create the bar plot
#ggplot(variance_data, aes(x = disordered_bin, y = variance_affinity)) +
#  geom_bar(stat = "identity") +
#  labs(title = "Variance of Affinity by Fraction Disordered Intervals",
#       x = "Fraction Disordered Intervals",
#       y = "Variance of Affinity") +
#  theme_minimal()