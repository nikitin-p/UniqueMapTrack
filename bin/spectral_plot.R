#!/usr/bin/env Rscript
#
# Produce a combined spectral k-mer plot for all genomes.
# Usage: spectral_plot.R <input_dir> <output.pdf>

library(ggplot2)
library(RColorBrewer)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
  stop("Usage: spectral_plot.R <input_dir> <output.pdf>")
}

input_dir <- args[1]
output_pdf <- args[2]

bin_files <- list.files(input_dir, pattern = "_mul_spectral_plot\\.tsv$", full.names = TRUE)
if (length(bin_files) == 0) {
  stop("No *_mul_spectral_plot.tsv files found in ", input_dir)
}

all_data <- list()

for (bin_file in bin_files) {
  genome_name <- sub("_mul_spectral_plot\\.tsv$", "", basename(bin_file))

  raw_file <- file.path(input_dir, paste0(genome_name, "_mul_raw.tsv"))
  max_file <- file.path(input_dir, paste0(genome_name, "_mul_max.txt"))

  binned <- read.delim(bin_file, stringsAsFactors = FALSE)
  colnames(binned) <- c("idx", "bin", "count")

  if (file.exists(raw_file)) {
    raw <- read.delim(raw_file, stringsAsFactors = FALSE)
    genome_size <- sum(raw$count)
  } else {
    genome_size <- sum(binned$count)
  }

  if (file.exists(max_file)) {
    max_kmer <- as.integer(readLines(max_file, n = 1))
  } else {
    max_kmer <- NA
  }

  binned <- binned[binned$count > 0, ]

  if (nrow(binned) == 0) next

  binned$bin <- as.character(binned$bin)
  last_idx <- nrow(binned)
  if (!is.na(max_kmer) && binned$bin[last_idx] == "more") {
    binned$bin[last_idx] <- as.character(max_kmer)
  } else if (!is.na(max_kmer)) {
    binned$bin[last_idx] <- as.character(max_kmer)
  }

  binned$genome <- genome_name
  binned$genome_size <- genome_size
  binned$proportion <- binned$count / sum(binned$count)

  all_data[[genome_name]] <- binned
}

df <- do.call(rbind, all_data)
rownames(df) <- NULL

df$bin <- factor(df$bin, levels = unique(df$bin[order(as.numeric(gsub("[^0-9]", "", df$bin)))]))

format_size <- function(n) {
  if (n >= 1e9) {
    return(sprintf("~%.1f Gb", n / 1e9))
  } else if (n >= 1e6) {
    return(sprintf("~%.1f Mb", n / 1e6))
  } else if (n >= 1e3) {
    return(sprintf("~%.1f kb", n / 1e3))
  } else {
    return(sprintf("%d bp", n))
  }
}

genome_labels <- unique(df[, c("genome", "genome_size")])
genome_labels$size_label <- sapply(genome_labels$genome_size, format_size)

n_bins <- length(levels(df$bin))
palette <- rev(brewer.pal(min(n_bins, 11), "RdBu"))
if (n_bins > 11) {
  palette <- colorRampPalette(palette)(n_bins)
}

n_genomes <- length(unique(df$genome))
plot_width <- max(10, n_genomes * 4)
plot_height <- 15

p <- ggplot(df, aes(x = genome, y = proportion, fill = bin)) +
  geom_bar(stat = "identity", position = "fill", width = 0.7) +
  scale_fill_manual(values = palette, name = "k-mer length") +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = NULL, y = "Proportion") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
    axis.text.y = element_text(size = 10),
    legend.position = "right",
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  geom_text(
    data = genome_labels,
    aes(x = genome, y = 1.02, label = size_label),
    inherit.aes = FALSE,
    size = 3.5,
    vjust = 0
  ) +
  coord_cartesian(ylim = c(0, 1.08), clip = "off")

ggsave(output_pdf, p, width = plot_width, height = plot_height, units = "cm")

cat("Saved:", output_pdf, "\n")
