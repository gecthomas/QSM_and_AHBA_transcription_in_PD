

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
revigo.data <- rbind(c("GO:0050778","positive regulation of immune response", 4.501, 5.784,-1.381, 2.893,-7.4989,0.421,0.000),
c("GO:0098883","synapse disassembly", 0.006,-5.064, 0.315, 0.301,-8.9957,0.964,0.000),
c("GO:0070661","leukocyte proliferation", 1.570,-4.396,-2.292, 2.436,-5.6091,0.893,0.008),
c("GO:0007159","leukocyte cell-cell adhesion", 2.874,-1.844, 1.071, 2.698,-4.7496,0.847,0.014),
c("GO:0045408","regulation of interleukin-6 biosynthetic process", 0.092,-0.455,-6.583, 1.230,-5.1733,0.768,0.033),
c("GO:0050865","regulation of cell activation", 3.174, 5.871, 5.658, 2.741,-6.3420,0.657,0.051),
c("GO:0006887","exocytosis", 4.986,-3.999,-3.894, 2.937,-1.5030,0.881,0.054),
c("GO:0001775","cell activation", 7.900,-3.845,-0.693, 3.137,-6.0742,0.943,0.063),
c("GO:0035588","G-protein coupled purinergic receptor signaling pathway", 0.133,-3.469, 3.515, 1.380,-4.7212,0.879,0.074),
c("GO:0046456","icosanoid biosynthetic process", 0.271,-2.274,-1.444, 1.681,-1.8309,0.948,0.102),
c("GO:0098542","defense response to other organism", 2.874, 1.586, 6.302, 2.698,-5.3215,0.873,0.108),
c("GO:0009607","response to biotic stimulus", 5.107,-0.977, 3.930, 2.947,-4.0590,0.931,0.118),
c("GO:0042107","cytokine metabolic process", 0.635,-2.141,-3.473, 2.045,-3.3705,0.974,0.129),
c("GO:0001816","cytokine production", 3.745,-2.221,-5.386, 2.813,-2.5234,0.913,0.132),
c("GO:0032930","positive regulation of superoxide anion generation", 0.058, 0.868,-5.715, 1.041,-1.8920,0.882,0.153),
c("GO:0035587","purinergic receptor signaling pathway", 0.179,-3.689, 3.859, 1.505,-3.9114,0.895,0.239),
c("GO:0051050","positive regulation of transport", 5.349, 3.079,-6.970, 2.968,-1.3088,0.824,0.294),
c("GO:0019221","cytokine-mediated signaling pathway", 3.260,-2.551, 4.598, 2.753,-3.1499,0.846,0.318),
c("GO:0002448","mast cell mediated immunity", 0.289, 7.870,-1.557, 1.708,-2.0254,0.622,0.337),
c("GO:0002540","leukotriene production involved in inflammatory response", 0.012, 1.029, 7.007, 0.477,-1.6763,0.885,0.349),
c("GO:0002495","antigen processing and presentation of peptide antigen via MHC class II", 0.548, 7.818,-0.516, 1.982,-3.5689,0.639,0.363),
c("GO:0019882","antigen processing and presentation", 1.339, 6.946,-0.400, 2.367,-2.1834,0.643,0.407),
c("GO:0006952","defense response", 8.904, 2.044, 6.519, 3.189,-4.7496,0.905,0.408),
c("GO:1904141","positive regulation of microglial cell migration", 0.006, 5.673,-3.368, 0.301,-1.4580,0.628,0.410),
c("GO:1902563","regulation of neutrophil activation", 0.035, 6.313, 0.782, 0.845,-2.6695,0.566,0.411),
c("GO:0034097","response to cytokine", 4.714,-1.641, 5.510, 2.913,-2.4589,0.918,0.464),
c("GO:0032103","positive regulation of response to external stimulus", 1.518, 2.994,-6.059, 2.422,-1.6985,0.799,0.505),
c("GO:0042116","macrophage activation", 0.329, 7.059, 1.624, 1.763,-4.8508,0.568,0.510),
c("GO:0001774","microglial cell activation", 0.104, 7.097, 2.059, 1.279,-3.3847,0.601,0.512),
c("GO:0002888","positive regulation of myeloid leukocyte mediated immunity", 0.104, 6.589,-2.208, 1.279,-4.0031,0.535,0.529),
c("GO:0002682","regulation of immune system process", 8.344, 7.788, 0.055, 3.160,-9.0958,0.548,0.540),
c("GO:0002291","T cell activation via T cell receptor contact with antigen bound to MHC molecule on antigen presenting cell", 0.046, 5.482, 1.106, 0.954,-1.9879,0.537,0.541),
c("GO:0016064","immunoglobulin mediated immune response", 1.206, 7.932,-0.615, 2.322,-1.7995,0.553,0.561),
c("GO:0002250","adaptive immune response", 2.845, 7.620, 0.602, 2.694,-4.4498,0.575,0.564),
c("GO:0045576","mast cell activation", 0.340, 7.388, 1.659, 1.778,-2.9365,0.566,0.566),
c("GO:0002252","immune effector process", 6.896, 7.695,-0.051, 3.078,-6.0640,0.574,0.584),
c("GO:0002269","leukocyte activation involved in inflammatory response", 1.069, 5.643, 2.529, 2.270,-3.3847,0.508,0.585),
c("GO:0002920","regulation of humoral immune response", 0.294, 6.639,-1.444, 1.716,-1.4513,0.575,0.601),
c("GO:0001819","positive regulation of cytokine production", 2.256, 1.521,-6.538, 2.593,-4.3279,0.689,0.607),
c("GO:0002538","arachidonic acid metabolite production involved in inflammatory response", 0.012, 0.879, 6.967, 0.477,-1.6763,0.885,0.645),
c("GO:0002697","regulation of immune effector process", 1.922, 7.410,-0.889, 2.524,-5.4989,0.495,0.646),
c("GO:0006954","inflammatory response", 3.785, 1.835, 6.851, 2.818,-2.5735,0.895,0.646),
c("GO:0006955","immune response",11.858, 6.317, 0.788, 3.313,-8.2628,0.528,0.653),
c("GO:0002683","negative regulation of immune system process", 2.152, 7.307,-1.020, 2.573,-1.5476,0.524,0.656),
c("GO:1902107","positive regulation of leukocyte differentiation", 0.773, 5.377,-2.379, 2.130,-2.8041,0.462,0.662),
c("GO:0002699","positive regulation of immune effector process", 0.958, 6.322,-1.877, 2.223,-5.4724,0.471,0.680),
c("GO:0032602","chemokine production", 0.439,-1.183,-6.478, 1.886,-1.4111,0.816,0.686),
c("GO:0002694","regulation of leukocyte activation", 2.977, 6.964, 0.507, 2.713,-6.9788,0.403,0.688),
c("GO:1903557","positive regulation of tumor necrosis factor superfamily cytokine production", 0.340, 1.191,-6.770, 1.778,-2.4791,0.717,0.690),
c("GO:0098609","cell-cell adhesion", 5.326,-3.194, 1.322, 2.966,-1.4581,0.881,0.695),
c("GO:0060333","interferon-gamma-mediated signaling pathway", 0.496, 4.228, 2.507, 1.940,-1.4523,0.583,0.697),
c("GO:0033003","regulation of mast cell activation", 0.237, 6.747, 0.745, 1.623,-2.4495,0.489,0.699));

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
p1 <- p1 + scale_colour_gradientn( colours = c("darkblue", "blue","lightblue"), limits = c( min(one.data$log10_p_value), max(one.data$log10_p_value)), name="log10 p-value" );
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
ggsave(paste(PWD,"/REVIGO_DNW_BP_significant_PLS2_geneWeights_ztrans_ADJ_LH_PD_Glasser_SW.png",sep=""), 
       scale=1.2, plot=p1, width=15, height=10, units="cm")
