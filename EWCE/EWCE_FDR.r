EWCE_FDR <- function(sig_genes_root, bg_genes_root, ctd_data_root, outdir, permutations=10000, threshold=20, pwidth = 10, pheight = 10) { 
  # run EWCE on the top X% of genes significant at pFDR < q(=0.05)
  
	# load libraries
	library(EWCE)
	library(ggplot2)
	library(cowplot)
	library(limma)
	library(readxl)

	# give input files (FDR and full list)
	fid1 <- sig_genes_root
	fid2 <- bg_genes_root

	# set reps and threshold (%)
	reps<-permutations
	thr<-threshold
	
	# load ctd data
	ctd_data <- readRDS(paste(ctd_data_root,".rds",sep=""))
	
	# load and tidy gene_lists
	gene_list <- read.csv(file=paste(getwd(),"/",outdir,fid1,".csv",sep=""), header = TRUE)
	
	upw.hits <- subset(gene_list, zscores>0 & significant)
	upw.hits <- as.character(upw.hits[order(upw.hits$adj.pvals),]$geneIDs)
	thr.up <- round((length(upw.hits)*thr)/100)
	thr.upw.hits <- upw.hits[1:thr.up]

	dnw.hits <- subset(gene_list, zscores<0 & significant)
	dnw.hits <- as.character(dnw.hits[order(dnw.hits$adj.pvals),]$geneIDs)
	thr.dn <- round((length(dnw.hits)*thr)/100)
	thr.dnw.hits <- dnw.hits[1:thr.dn]

	# load and tidy background list
	bg_list <- read.csv(file=paste(getwd(),"/",fid2,".csv",sep=""), header = FALSE)
	genes.bg <- as.character(bg_list$V1)
	genes.bg <- trimws(genes.bg[trimws(genes.bg) != ""])

	# run analysis
	upw.results <- bootstrap.enrichment.test(sct_data=ctd_data, hits=thr.upw.hits, bg=genes.bg, reps=reps, annotLevel=1, geneSizeControl=TRUE, genelistSpecies="human", sctSpecies="human")
	dnw.results <- bootstrap.enrichment.test(sct_data=ctd_data, hits=thr.dnw.hits, bg=genes.bg, reps=reps, annotLevel=1, geneSizeControl=TRUE, genelistSpecies="human", sctSpecies="human")
	
	# plot results
	pscl <- 1.5; 
	p1 <- ewce.plot(upw.results$results, mtc_method="BH")
	ggsave(filename=paste(getwd(),"/",outdir,ctd_data_root,"_TOP_",threshold,"pc_CELL_ENRICHMENT_UP_", fid1,".png", sep=""), plot=p1$plain, units="cm", height=pheight*0.6, width=pwidth, dpi=600, scale=pscl)

	p2 <- ewce.plot(dnw.results$results, mtc_method="BH")
	ggsave(filename=paste(getwd(),"/",outdir,ctd_data_root,"_TOP_",threshold,"pc_CELL_ENRICHMENT_DN_", fid1,".png", sep=""), plot=p2$plain, units="cm", height=pheight*0.6, width=pwidth, dpi=600, scale=pscl)

	res1 <- data.frame(upw.results$results, list="upweighted")
	res2 <- data.frame(dnw.results$results, list="downweighted")
	merged_results <- rbind(res1, res2)
	p3 <- ewce.plot(total_res=merged_results, mtc_method="BH")
	ggsave(filename=paste(getwd(),"/",outdir,ctd_data_root,"_TOP_",threshold,"pc_CELL_ENRICHMENT_UPnDOWN_", fid1,".png", sep=""), plot=p3$plain, units="cm", height=pheight, width=pwidth, dpi=600, scale=pscl)

}
