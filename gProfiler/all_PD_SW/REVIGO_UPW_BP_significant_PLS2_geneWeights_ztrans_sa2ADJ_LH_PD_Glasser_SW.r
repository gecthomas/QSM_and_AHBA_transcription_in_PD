

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
revigo.data <- rbind(c("GO:0007268","chemical synaptic transmission", 3.474,-5.121, 2.163, 2.780,-6.8794,0.795,0.000),
c("GO:0010273","detoxification of copper ion", 0.012,-0.974,-5.918, 0.477,-5.8041,0.836,0.000),
c("GO:0098609","cell-cell adhesion", 5.326, 5.890,-4.554, 2.966,-1.5849,0.981,0.000),
c("GO:1902930","regulation of alcohol biosynthetic process", 0.202, 2.699,-3.924, 1.556,-4.8601,0.839,0.011),
c("GO:0045926","negative regulation of growth", 1.293, 1.930, 7.647, 2.352,-1.7872,0.947,0.031),
c("GO:0006882","cellular zinc ion homeostasis", 0.144,-6.625,-1.692, 1.415,-4.1290,0.740,0.035),
c("GO:1901615","organic hydroxy compound metabolic process", 2.689, 0.373, 0.793, 2.669,-2.6147,0.973,0.035),
c("GO:1903532","positive regulation of secretion by cell", 1.922,-3.013, 5.994, 2.524,-2.4288,0.740,0.048),
c("GO:0031175","neuron projection development", 4.876, 6.018, 1.344, 2.927,-4.2774,0.688,0.055),
c("GO:0009719","response to endogenous stimulus", 9.175, 5.194,-5.802, 3.202,-1.6176,0.955,0.063),
c("GO:0006928","movement of cell or subcellular component",10.987,-1.652,-0.601, 3.280,-1.3389,0.923,0.067),
c("GO:0009636","response to toxic substance", 1.264,-3.285,-5.468, 2.342,-1.9911,0.917,0.161),
c("GO:0007267","cell-cell signaling", 9.025,-2.527, 2.137, 3.195,-6.4318,0.891,0.222),
c("GO:0030030","cell projection organization", 7.963, 3.379,-1.175, 3.140,-2.2963,0.888,0.239),
c("GO:0042391","regulation of membrane potential", 2.204,-6.792,-0.466, 2.583,-2.1473,0.828,0.246),
c("GO:0060322","head development", 4.091, 4.861, 3.969, 2.851,-3.7214,0.848,0.254),
c("GO:0030323","respiratory tube development", 1.016, 5.313, 1.907, 2.248,-1.5806,0.836,0.265),
c("GO:0072001","renal system development", 1.621, 5.514, 4.062, 2.450,-3.3366,0.830,0.283),
c("GO:0001655","urogenital system development", 1.823, 5.004, 3.156, 2.501,-2.5202,0.841,0.287),
c("GO:0009065","glutamine family amino acid catabolic process", 0.144, 3.921,-4.732, 1.415,-1.8166,0.905,0.292),
c("GO:0032989","cellular component morphogenesis", 5.822, 5.889, 0.804, 3.004,-3.0058,0.753,0.384),
c("GO:0007399","nervous system development",12.770, 6.155, 2.903, 3.345,-9.8153,0.797,0.398),
c("GO:0070050","neuron cellular homeostasis", 0.052,-6.328,-1.633, 1.000,-1.3363,0.795,0.410),
c("GO:0019725","cellular homeostasis", 4.784,-6.799,-0.982, 2.919,-1.9122,0.713,0.448),
c("GO:0048468","cell development",11.056, 5.683, 2.960, 3.283,-2.0406,0.768,0.450),
c("GO:0097501","stress response to metal ion", 0.023,-0.038,-6.560, 0.699,-5.1938,0.863,0.450),
c("GO:0060341","regulation of cellular localization", 4.876,-1.948, 6.673, 2.927,-1.3770,0.835,0.476),
c("GO:0014063","negative regulation of serotonin secretion", 0.023,-3.127, 5.725, 0.699,-1.8789,0.799,0.515),
c("GO:0071294","cellular response to zinc ion", 0.110,-0.760,-6.573, 1.301,-5.1720,0.842,0.517),
c("GO:0043271","negative regulation of ion transport", 0.750,-1.545, 6.516, 2.117,-1.4226,0.833,0.532),
c("GO:0043269","regulation of ion transport", 3.485,-2.485, 6.297, 2.782,-1.3984,0.818,0.551),
c("GO:0032880","regulation of protein localization", 5.603,-2.252, 6.635, 2.988,-3.2387,0.828,0.562),
c("GO:0030072","peptide hormone secretion", 1.373,-4.880, 3.091, 2.378,-2.2274,0.612,0.572),
c("GO:0007420","brain development", 3.895, 6.297, 2.265, 2.830,-3.2631,0.767,0.573),
c("GO:0061687","detoxification of inorganic compound", 0.023,-1.610,-4.807, 0.699,-5.1938,0.916,0.590),
c("GO:0046688","response to copper ion", 0.162,-1.401,-6.453, 1.462,-2.4952,0.847,0.593),
c("GO:0009887","animal organ morphogenesis", 5.666, 5.962, 2.426, 2.993,-2.4683,0.765,0.595),
c("GO:0023061","signal release", 2.441,-4.016, 4.509, 2.627,-2.7244,0.731,0.619),
c("GO:0000904","cell morphogenesis involved in differentiation", 3.820, 6.117, 0.628, 2.822,-3.6035,0.709,0.623),
c("GO:0071241","cellular response to inorganic substance", 0.998,-0.646,-6.422, 2.241,-2.0233,0.837,0.629),
c("GO:0051046","regulation of secretion", 4.033,-3.320, 6.012, 2.845,-1.8845,0.765,0.637),
c("GO:0098754","detoxification", 0.565,-2.251,-5.290, 1.996,-1.6273,0.904,0.637),
c("GO:0051049","regulation of transport",10.519,-2.673, 6.425, 3.261,-2.1096,0.813,0.646),
c("GO:0099536","synaptic signaling", 3.485,-4.794, 2.080, 2.782,-6.3936,0.816,0.652),
c("GO:0022008","neurogenesis", 8.442, 6.242, 1.833, 3.166,-4.5901,0.718,0.654),
c("GO:0006875","cellular metal ion homeostasis", 2.827,-6.653,-1.237, 2.691,-2.9063,0.671,0.658),
c("GO:1901617","organic hydroxy compound biosynthetic process", 1.171, 0.057,-2.421, 2.310,-3.7932,0.886,0.661),
c("GO:0007417","central nervous system development", 5.182, 6.507, 1.997, 2.954,-2.6820,0.766,0.661),
c("GO:0010043","response to zinc ion", 0.306,-1.138,-6.435, 1.732,-1.4808,0.840,0.667));

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
ex <- tail(one.data[order(abs(one.data$log10_p_value)),],8)
p1 <- p1 + geom_point( aes( plot_X, plot_Y, colour = log10_p_value, size = -log10_p_value), alpha = I(0.7) ) + scale_size_area();
p1 <- p1 + scale_colour_gradientn( colours = c("darkred","red","lightcoral", "white"), limits = c( min(one.data$log10_p_value), max(one.data$log10_p_value)), name="");
p1 <- p1 + geom_point( aes(plot_X, plot_Y, size = -log10_p_value), shape = 21, fill = "transparent", colour = I (alpha ("black", 0.6) )) + scale_size_area();
p1 <- p1 + scale_size( range=c(5,20), name = NULL, breaks = NULL, labels = NULL)
p1 <- p1 + theme_minimal()
p1 <- p1 + theme(axis.text = element_text(size = 12))
p1 <- p1 + theme(axis.title = element_text(size = 18))
#p1 <- p1 + geom_label( data = ex, aes(plot_X, plot_Y, label = description),label.padding = unit(0.15, "lines"), colour = I(alpha("black", 1)), fill=rgb(1,1,1,0.8), size = 5, hjust = "inward",vjust="outward");
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
ggsave(paste(PWD,"/REVIGO_nolabel_UPW_BP_significant_PLS2_geneWeights_ztrans_sa2ADJ_LH_PD_Glasser_SW.png",sep=""), 
       scale=1.2, plot=p1, width=15, height=10, units="cm")