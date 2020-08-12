

# A plotting R script produced by the REVIGO server at http://revigo.irb.hr/
# If you found REVIGO useful in your work, please cite the following reference:
# Supek F et al. "REVIGO summarizes and visualizes long lists of Gene Ontology
# terms" PLoS ONE 2011. doi:10.1371/journal.pone.0021800


# --------------------------------------------------------------------------
# If you don't have the ggplot2 package installed, uncomment the following line:
# install.packages( "ggplot2" );
library( ggplot2 );
# --------------------------------------------------------------------------
# If you don't have the scales package installed, uncomment the following line:
# install.packages( "scales" );
library( scales );


# --------------------------------------------------------------------------
# Here is your data from REVIGO. Scroll down for plot configuration options.

revigo.names <- c("term_ID","description","frequency_%","plot_X","plot_Y","plot_size","log10_p_value","uniqueness","dispensability");
revigo.data <- rbind(c("GO:0010273","detoxification of copper ion", 0.012, 5.252, 0.143, 0.477,-5.2832,0.584,0.000),
c("GO:0046916","cellular transition metal ion homeostasis", 0.496,-2.999, 5.094, 1.940,-2.5884,0.640,0.000),
c("GO:0034773","histone H4-K20 trimethylation", 0.035, 2.489,-7.282, 0.845,-1.5205,0.891,0.001),
c("GO:0089718","amino acid import across plasma membrane", 0.006,-5.856,-0.688, 0.301,-2.2655,0.596,0.007),
c("GO:0007399","nervous system development",12.770, 2.262, 6.665, 3.345,-3.3477,0.897,0.015),
c("GO:0098876","vesicle-mediated transport to the plasma membrane", 0.594,-3.502,-5.193, 2.017,-1.6722,0.787,0.117),
c("GO:0006893","Golgi to plasma membrane transport", 0.294,-2.575,-5.645, 1.716,-1.4988,0.791,0.352),
c("GO:0097501","stress response to metal ion", 0.023, 5.241,-1.938, 0.699,-4.5638,0.690,0.450),
c("GO:0071294","cellular response to zinc ion", 0.110, 5.351,-1.248, 1.301,-1.9164,0.665,0.517),
c("GO:0015800","acidic amino acid transport", 0.144,-5.614,-2.082, 1.415,-1.5408,0.656,0.584),
c("GO:0061687","detoxification of inorganic compound", 0.023, 5.147, 2.150, 0.699,-4.5638,0.778,0.590),
c("GO:0055076","transition metal ion homeostasis", 0.658,-3.533, 4.990, 2.061,-2.5432,0.693,0.644),
c("GO:0001504","neurotransmitter uptake", 0.138,-4.647, 0.924, 1.398,-2.2290,0.614,0.668));

one.data <- data.frame(revigo.data);
names(one.data) <- revigo.names;
one.data <- one.data [(one.data$plot_X != "null" & one.data$plot_Y != "null"), ];
one.data$plot_X <- as.numeric( as.character(one.data$plot_X) );
one.data$plot_Y <- as.numeric( as.character(one.data$plot_Y) );
one.data$plot_size <- as.numeric( as.character(one.data$plot_size) );
one.data$log10_p_value <- as.numeric( as.character(one.data$log10_p_value) );
one.data$frequency <- as.numeric( as.character(one.data$frequency) );
one.data$uniqueness <- as.numeric( as.character(one.data$uniqueness) );
one.data$dispensability <- as.numeric( as.character(one.data$dispensability) );
#head(one.data);


# --------------------------------------------------------------------------
# Names of the axes, sizes of the numbers and letters, names of the columns,
# etc. can be changed below
one.data <- one.data[order(-one.data$log10_p_value),]

p1 <- ggplot( data = one.data );
ex <- tail(one.data[order(abs(one.data$log10_p_value)),],5)
p1 <- p1 + geom_point( aes( plot_X, plot_Y, colour = log10_p_value, size = -log10_p_value), alpha = I(0.7) ) + scale_size_area();
p1 <- p1 + scale_colour_gradientn( colours = c("darkred","red","lightcoral", "white"), limits = c( min(one.data$log10_p_value), max(one.data$log10_p_value)), name="log10 p-value" );
p1 <- p1 + geom_point( aes(plot_X, plot_Y, size = -log10_p_value), shape = 21, fill = "transparent", colour = I (alpha ("black", 0.6) )) + scale_size_area();
p1 <- p1 + scale_size( range=c(5,20), name = NULL, breaks = NULL, labels = NULL)
p1 <- p1 + theme_minimal()
p1 <- p1 + theme(axis.text = element_text(size = 12))
p1 <- p1 + theme(axis.title = element_text(size = 18))
p1 <- p1 + geom_label( data = ex, aes(plot_X, plot_Y, label = description),label.padding = unit(0.15, "lines"), colour = I(alpha("black", 1)), fill=rgb(1,1,1,0.8), size = 5, hjust = "inward",vjust="outward");
p1 <- p1 + geom_point( data = ex, aes(plot_X, plot_Y), shape=19, size = 1.5, colour="black")
p1 <- p1 + labs (y = "semantic space x", x = "semantic space y");
p1 <- p1 + theme(legend.key = element_blank(), legend.position = c(0.16,0.07), legend.direction = "horizontal",legend.text = element_text(size=12),legend.title = element_text(size=13)) ;
one.x_range = max(one.data$plot_X) - min(one.data$plot_X);
one.y_range = max(one.data$plot_Y) - min(one.data$plot_Y);
p1 <- p1 + xlim(min(one.data$plot_X)-one.x_range/40,max(one.data$plot_X)+one.x_range/40);
p1 <- p1 + ylim(min(one.data$plot_Y)-one.y_range/40,max(one.data$plot_Y)+one.y_range/40);


# -----------------------------------------------------------------------
# Output the plot to screen

plot(p1);

# Uncomment the line below to also save the plot to a file.
# The file type depends on the extension (default=pdf).

PWD <- getwd()
ggsave(paste(PWD,"/REVIGO_UPW_BP_significant_PLS2_geneWeights_ztrans_ADJ_LH_PD_Glasser_SW.png",sep=""), 
       scale=1.2, plot=p1, width=15, height=10, units="cm")
