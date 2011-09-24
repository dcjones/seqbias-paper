

source('config.R')

# build dataframe

ws <- c('bullard.tab', 'katze.tab', 'mortazavi.tab',
        'trapnell.tab', 'wetterbom.tab')


xs <- NULL
for (w in ws) {
    x  <- read.table(paste(d_old, '/pois/', w, sep = ''), header = T)
    x <- subset(x, method != 'Jones')
    x <- rbind(x, read.table(paste(d, '/pois/', w, sep = ''), header = T))

    xs <- rbind(xs, x)
}



# join with unadjusted likelihood for easy comparison
ys <- subset(xs, method == 'Unadjusted')[,c('sample', 'gene', 'L')]
xs <- merge(xs, ys, by = c('sample', 'gene'))
names(xs) <- c('sample', 'gene', 'method', 'mu', 'L', 'L.base')

xs$sample <- factor(tolower(xs$sample))


# read test regions (so we no how many positions were included the
# log-likelihood calculation)
ks.all <- NULL
for (w in c('bullard', 'katze', 'mortazavi', 'trapnell', 'wetterbom')) {
    fn <- paste('../exons/', w, '01.test.bed', sep = '')
    ks <- read.table(fn, header = F)
    names(ks) <- c('seqname', 'start', 'end', 'name', 'score', 'strand')
    ks$gene   <- factor(as.character(0:(length(ks[,1]) - 1)))
    ks$sample <- w
    ks$k      <- ks$end - ks$start
    ks <- ks[,c('sample', 'gene', 'k')]
    ks.all <- rbind(ks.all, ks)
}

xs <- merge(xs, ks.all, by = c('sample', 'gene'))


# mcfadden's pseudo-R2
r2.mcfadden <- function(L, L.base, n) { (1 - L / L.base) }

# nagelkerke's R2
r2.nagelkerke <- function(L, L.base, n) { 1 - exp( (2/n) * (L.base - L)) }

r2 <- r2.mcfadden
#r2 <- r2.nagelkerke


# reorder
xs$method <- factor(xs$method,
                    levels = c('Hansen/A', 'Li/GLM', 'Li/MART', 'Jones'))

xs$r2 <- r2(xs$L, xs$L.base, xs$k)
med <- tapply(xs$r2, INDEX = list(xs$sample, xs$method), FUN = median)


# the boxplots are plotted seperately, then combined, so that they can be put no
# seperate scales.

library(Cairo)
library(ggplot2)
source('theme_dcjstd.R')


#cairopng('pois-boxplot-simple.png',
         #width = 600, height = 2000)

#p <- qplot(data = xs, y = r2(l, l.base), x = method, geom = 'boxplot')
#p <- p + facet_grid(sample ~ .)
#p <- p + coord_flip()
#print(p)

#dev.off()

for (w in levels(xs$sample)) {

    ys <- subset(xs, sample == w & method != 'Unadjusted')

    CairoSVG(paste('pois-boxplot', w, 'svg', sep = '.'),
             width = 4, height = 1.5)

    p <- qplot(data = ys, y = r2, x = method,
               geom = 'boxplot', outlier.colour = alpha('black', 0.3))
    p <- p + scale_x_discrete(name   = 'Method',
                              labels = list('Hansen/A' = '7mer',
                                            'Li/MART'  = 'MART',
                                            'Li/GLM'   = 'GLM',
                                            'Jones'    = 'BN'))
    p <- p + coord_flip()
    p <- p + theme_dcjstd()
    print(p)

    dev.off()

    # Nonparametric tests that BN shown an improved log-likelihood
    zs.bn <- subset(ys, method == 'Jones')
    for (v in levels(ys$method)) {
        zs <- subset(ys, method == v)
        print(paste(w, v))
        p <- wilcox.test(zs.bn$L, zs$L, alternative = 'greater', paired = T, exact = T)
        print(p$p.value)
    }
}



print(round(med, digits=3))






