



source('config.R')

ws <- c('bullard.tab', 'katze.tab', 'mortazavi.tab',
        'trapnell.tab', 'wetterbom.tab')

xs <- NULL
for (w in ws) {
    x  <- read.table(paste(d_old, '/kl/', w, sep = ''), header = T)
    x  <- subset(x, method != 'Jones')
    x  <- rbind(x, read.table(paste(d, '/kl/', w, sep = ''), header = T))

    xs <- rbind(xs, x)
}


# reorder this factor so the plot is drawn in a flattering manner
xs$method <- factor(xs$method, levels = c(
                                          'Unadjusted',
                                          'Hansen/A',
                                          'Li/GLM',
                                          'Li/MART',
                                          'Jones'
                                          ))

# reorder this factor so that it is drawn in the same order as every other plot
xs$sample <- factor(xs$sample, levels = c(
                                         'Wetterbom',
                                         'Katze',
                                         'Bullard',
                                         'Mortazavi',
                                         'Trapnell'))

library(Cairo)
library(ggplot2)
source('theme_dcjstd.R')


xs <- subset(xs, k == 1 | k == 4)
xs <- subset(xs, -20 <= pos & pos <= 20)


scl <- 2.8
CairoSVG('kl.svg', width = 6 * scl, height = 1.8 * scl)

xs$k <- factor(xs$k)

p <- qplot(data = xs, x = pos, y = div, color = method,
           geom = 'line')
p <- p + facet_grid(k ~ sample, scale = 'free')


p <- p + scale_color_manual(
            name = 'Method',
            labels = list(
                          'Jones'    = 'BN',
                          'Li/MART'  = 'MART',
                          'Li/GLM'   = 'GLM',
                          'Hansen/A' = '7mer',
                          'Unadjusted' = 'Unadjusted'
                          ),
            values = c('grey70',
                       '#f0c956ff',
                       '#b8359eff',
                       '#357db8ff',
                       '#e31919ff'
                       ))


                             

# get rid of grid lines, since they get fucket up on this plot anyway
p <- p + theme_dcjstd()

#p <- p + structure(list(panel.grid.minor = theme_blank(),
                        #panel.grid.major = theme_blank()),
                   #class = "options")

print(p)

dev.off()



# TODO



