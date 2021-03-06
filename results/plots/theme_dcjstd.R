


theme_dcjstd <- function(base_size = 12, base_family = "")
{
    structure(
        list(
            panel.background = theme_rect(fill   = '#eaeaea',
                                          colour = '#d0d0d0'),

            panel.grid.major = theme_line(colour = "white"), 

            panel.grid.minor = theme_line(colour = "white", size = 0.25),


            axis.text.x = theme_text(family     = base_family, 
                                     size       = base_size * 0.8,
                                     lineheight = 0.9,
                                     colour     = "black", 
                                     vjust      = 1),

            axis.text.y = theme_text(family     = base_family, 
                                     size       = base_size * 0.8,
                                     lineheight = 0.9,
                                     colour     = "black", 
                                     hjust      = 1),

            axis.title.x = theme_text(family = base_family,
                                      size   = base_size, 
                                      vjust  = 1),

            axis.title.y = theme_text(family = base_family, 
                                      size   = base_size,
                                      angle  = 90,
                                      vjust  = 0.2)
        ),

        class = "options"
    )
}


#theme_grey <-
#function (base_size = 12, base_family = "") 
#{
    #structure(
        #list(
            #axis.line = theme_blank(),

            #axis.text.x = theme_text(family     = base_family, 
                                     #size       = base_size * 0.8,
                                     #lineheight = 0.9,
                                     #colour     = "grey50", 
                                     #vjust      = 1),

            #axis.text.y = theme_text(family     = base_family, 
                                     #size       = base_size * 0.8,
                                     #lineheight = 0.9,
                                     #colour     = "grey50", 
                                     #hjust      = 1),

            #axis.ticks = theme_segment(colour = "grey50"), 

            #axis.title.x = theme_text(family = base_family,
                                      #size   = base_size, 
                                      #vjust  = 0.5),

            #axis.title.y = theme_text(family = base_family, 
                                      #size   = base_size,
                                      #angle  = 90,
                                      #vjust  = 0.5),

            #axis.ticks.length = unit(0.15, "cm"),

            #axis.ticks.margin = unit(0.1, "cm"),
            
            #legend.background = theme_rect(colour = "white"), 

            #legend.key = theme_rect(fill = "grey95", colour = "white"), 

            #legend.key.size = unit(1.2, "lines"), legend.key.height = NA, 

            #legend.key.width = NA,
            
            #legend.text = theme_text(family = base_family, 
                                     #size   = base_size * 0.8),

            #legend.text.align = NA, 

            #legend.title = theme_text(family = base_family,
                                      #size   = base_size * 0.8,
                                      #face   = "bold",
                                      #hjust  = 0),
                                      
            #legend.title.align = NA, 

            #legend.position = "right",

            #legend.direction = "vertical", 

            #legend.box = NA,
            
            #panel.background = theme_rect(fill = "grey90", colour = NA),

            #panel.border = theme_blank(),

            #panel.grid.major = theme_line(colour = "white"), 

            #panel.grid.minor = theme_line(colour = "grey95", size = 0.25), 

            #panel.margin = unit(0.25, "lines"),
            
            #strip.background = theme_rect(fill = "grey80", colour = NA),
            
            #strip.text.x = theme_text(family = base_family, size = base_size * 0.8),

            #strip.text.y = theme_text(family = base_family, size = base_size * 0.8, angle = -90),
            #plot.background = theme_rect(colour = NA, fill = "white"),
            
            #plot.title = theme_text(family = base_family, size = base_size * 1.2),
            
            #plot.margin = unit(c(1, 1, 0.5, 0.5), "lines")),
            
            #class = "options")
#}



