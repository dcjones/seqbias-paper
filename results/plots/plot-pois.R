

source('config.R')

# build dataframe

ws <- c('bullard.tab', 'katze.tab', 'mortazavi.tab',
        'trapnell.tab', 'wetterbom.tab')

xs <- NULL
for (w in ws) {
    x  <- read.table(paste(d, '/pois/', w, sep = ''), header = T)
    xs <- rbind(xs, x)
}



# join with unadjusted likelihood for easy comparison
ys <- subset(xs, method == 'Unadjusted')[,c('sample', 'gene', 'L')]
xs <- merge(xs, ys, by = c('sample', 'gene'))
names(xs) <- c('sample', 'gene', 'method', 'mu', 'L', 'L.base')



# mcfadden's pseudo-R2
r2 <- function(L, L.base) { 1 - L / L.base }




# the boxplots are plotted seperately, then combined, so that they can be put no
# seperate scales.

library(Cairo)
library(ggplot2)
source('theme_dcjstd.R')


#CairoPNG('pois-boxplot-simple.png',
         #width = 600, height = 2000)

#p <- qplot(data = xs, y = r2(L, L.base), x = method, geom = 'boxplot')
#p <- p + facet_grid(sample ~ .)
#p <- p + coord_flip()
#print(p)

#dev.off()


# reorder
xs$method <- factor(xs$method,
                    levels = c('Hansen/A', 'Li/GLM', 'Li/MART', 'Jones'))



for (w in levels(xs$sample)) {

    ys <- subset(xs, sample == w & method != 'Unadjusted')
    print(head(ys))

    CairoSVG(paste('pois-boxplot', w, 'svg', sep = '.'),
             width = 4, height = 1.5)

    p <- qplot(data = ys, y = r2(L, L.base), x = method,
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
}



# TODO: compute median values.

xs$r2 <- r2(xs$L, xs$L.base)
med <- tapply(xs$r2, INDEX = list(xs$sample, xs$method), FUN = median)
print(round(med, digits=3))


