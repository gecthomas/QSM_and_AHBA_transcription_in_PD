PLS_FDR_WC <- function(gWeight_root, wdir, threshold = 0.05, min.p=10^-300) {
  # ---------- DESCRIPTION ----------  
  #
  # For a list of Z-scores (gWeight_root), calculate an FDR corrected p value using 
  # an FDR inverse quantile transformation correction to account for winners curse bias
  #
  # Run this BEFORE running PLS_GO_enrichment.r
  #
  # Author: George Thomas 
  # Last edited July 2020
  #
  # ---------- INPUTS ----------
  #
  # gWeight_root is root name of a .csv file  in wdir with columns:
  # geneID/geneIDX/bootstrapped geneWeight
  #
  # wdir is the analysis directory (containing gWeight .csv file)
  #
  # threshold is the desired FDR threshold (default alpha = 0.05)
  #
  # min.p - minimum p-value admitted (to avoid zero p-values/adjusted p-values which 
  # give troubles with inverse cdf) very large zs corresponding to min.p (i.e z > 37) are 
  # not adjusted, as their bias is essentially zero)
  #
  # ---------- OUTPUTS ----------
  #
  # will go into wdir
  #
  # .csv file called "significant_<gWeight_root>.csv" containing columns:
  # geneID/geneIDX/Zscore/pval/qval/signficance
  #
  # .png file called "significant_<gWeight_root>.csv" 
  # will be a histogram with Z score distribution and significance thresholds
  #
  # ---------- DOCUMENTATION ----------
  #
  # Code for FDR correction taken from https://github.com/bacanusa/FIQT
  # Reference Bigdeli, 2019, Bioinformatics
  #
  # ---------- CODE STARTS HERE ---------
  
  # load required libraries
  library(ggplot2)
  
  # load bootsrapped gene weights from .csv file
  fid1 <- gWeight_root
  gWeights <- read.csv(file=paste(getwd(),"/",wdir,fid1,".csv",sep=""), header=FALSE)
  # separate out the info
  geneIDs <- as.character(gWeights$V1)
  geneIDX <- gWeights$V2
  zscores <- gWeights$V3
  
  # do FDR correction (see documentation above)
  pvals<-2*pnorm(abs(zscores),low=F)
  pvals[pvals<min.p]<- min.p
  adj.pvals<-p.adjust(pvals,method="fdr")
  mu.zscores<-sign(zscores)*qnorm(adj.pvals/2,low=F)
  mu.zscores[abs(zscores)>qnorm(min.p/2,low=F)]<-zscores[abs(zscores)>qnorm(min.p/2,low=F)]
  significant <- as.factor(adj.pvals<0.05)
  
  # make a new dataframe with all the input data as well as pvals, qvals and significance status
  corr.gWeights <- data.frame(geneIDs,geneIDX,zscores,pvals,adj.pvals,significant)
  
  # find the Z score cut off for uncorrected pval significance
  uncorr.thr <- c(zscores[length(zscores)-sum(pvals<0.05&zscores<0)], 
                  zscores[sum(pvals<0.05&zscores>0)])
  # find the Z score cut off for corrected qval significance
  corr.thr <- c(zscores[length(zscores)-sum(adj.pvals<0.05&zscores<0)], 
                 zscores[sum(adj.pvals<0.05&zscores>0)])
  
  # plot a histogram with Z score distribution and significance thresholds and make it look nice
  p1 <- ggplot(data=corr.gWeights, aes(x=corr.gWeights$zscores)) +
    geom_histogram(bins=50,aes(y=stat(count)/sum(count)),color="black",fill="white") +
    theme_light() +
    ggtitle("Distribution of gene weightings") +
    ylab("Relative frequency") +
    xlab("Bootstrapped Z-score") +
    theme(plot.title=element_text(lineheight=.8,size=18,face="bold"), 
          axis.title=element_text(size=18,face="bold"), 
          axis.text=element_text(size=18)) +
    scale_x_continuous(breaks=seq(-8,8,2)) +
    geom_vline(xintercept=uncorr.thr, color = "green4",linetype = "dashed",size=1) +
    geom_vline(xintercept=corr.thr,color = "green4",size=1)
  
  # save the plot as a .png in wdir
  ggsave(filename=paste(getwd(),"/",wdir,"FDR_correction_", fid1,".png", sep=""), plot=p1, units="cm", height=15, width=15, dpi=600, scale=1)
  
  # save results (now with p-value, q-value and significance status) as a .csv in wdir
  write.csv(corr.gWeights, file=paste(getwd(),"/",wdir,"significant_", fid1,".csv", sep=""))
}