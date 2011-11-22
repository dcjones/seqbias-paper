
d <- '../p_max'

ns <- c('1', '2', '3', '4', '5', '6', '7', '8', '9',
        '10', '11', '12', '13')


xs <- NULL
for (n in ns) {
    fn <- sprintf('%s/pois.%s.tab', d, n)
    ys <- read.table(fn, header = T)
    ys$n <- n
    xs <- rbind(xs, ys)
}


ys <- read.table(paste('../20110610/', '/pois/mortazavi.tab', sep = ''), header = T)
ys <- subset(ys, method == 'Unadjusted')[,c('sample', 'gene', 'L')]
xs <- merge(xs, ys, by = c('sample', 'gene'))
names(xs) <- c('sample', 'gene', 'method', 'mu', 'L', 'n', 'L.base')


r2 <- function(L, L.base) { 1 - L / L.base }
xs$r2 <- r2(xs$L, xs$L.base)
med <- tapply(xs$r2, INDEX = list(xs$sample, xs$method, xs$n), FUN = median)

library(reshape)

med <- melt(med)
names(med) <- c('sample', 'method', 'n', 'med')



library(Cairo)
library(ggplot2)
source('theme_dcjstd.R')

CairoSVG('pois-p_max.svg', width = 12, height = 6)
p <- qplot(data = med, x = n - 1, y = med, geom = 'line')
p <- p + geom_point()
#p <- p + ylim(c(0, max(med$med)))
p <- p + scale_x_continuous(name = 'p_max')
p <- p + scale_y_continuous(name = 'Median Goodness of Fit', limits = c(0, max(med$med)))
p <- p + theme_dcjstd()
print(p)

dev.off()






