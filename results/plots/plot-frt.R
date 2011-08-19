
library(Cairo)
library(ggplot2)
source('theme_dcjstd.R')

xs <- read.table('../frtseq/freqs.tab', header = T)
xs$kmer <- factor(xs$kmer, levels = c('a', 'c', 'g', 't', 'div'))

scale = 0.9

CairoSVG('frt.svg', width = scale * 12, height = scale * 6)
ys <- subset(xs, kmer != 'div')
p <- qplot(data = ys, x = pos, y = freq, geom = 'line')
p <- p + facet_grid(kmer ~ .)
p <- p + theme_dcjstd()
print(p)
dev.off()


CairoSVG('frt-div.svg', width = scale * 12, height = scale * 2)
ys <- subset(xs, kmer == 'div')
p <- qplot(data = ys, x = pos, y = freq, geom = 'line')
p <- p + facet_grid(kmer ~ ., scales = 'free')
p <- p + theme_dcjstd()
print(p)

