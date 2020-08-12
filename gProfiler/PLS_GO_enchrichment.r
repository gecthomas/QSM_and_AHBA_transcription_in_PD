PLS_GO_enrichment <- function(sig_gWeight_root, wdir, threshold = 0.05, cmethod="gSCS", max_term_size=2500){
  # ---------- DESCRIPTION ---------- 
  #
  # Take the FDR corrected geneWeight info (output from PLS_FDR_WC_FDR.r) and run enrichment analyses
  # using the g:profileR toolbox
  # 
  # Run this AFTER running PLS_FDR_WC.r
  #
  # Author: George Thomas 
  # Last edited July 2020
  #
  # ---------- INPUTS ----------
  #
  # sig_gWeight_root is root name of a .csv file with columns:
  # geneID/geneIDX/Zscore/pval/qval/signficance
  # (output of PLS_FDR_WC.r)
  #
  # wdir is the analysis directory (containing sig_gWeight .csv file)
  #
  # theshold is the alpha g:Profiler will report terms over (default = 0.05)
  #
  # cmethod is the correction method g:profiler will use: gSCS/Bonferroni/FDR
  # (default is g:SCS recommended by g:profiler - see docs)
  #
  # max_term_size - terms containing this many or more genes will be discarded as too general 
  # (default is 2500 consistent with existing literature)
  #
  # ---------- OUTPUTS ----------
  #
  # will go into wdir
  #
  # .csv file called "GO_UPW_<sig_gWeight_root>.csv"
  # contains information about terms significantly enriched in the significantly upweighted gene list
  #
  # .csv file called "GO_DNW_<sig_gWeight_root>.csv"
  # contains information about terms significantly enriched in the significantly downweighted gene list
  #
  # for more info about column entries see documentation
  #
  # --------- DEPENDENCIES ----------
  #
  # description of g:profiler including g:SCS correction algorithm
  # https://biit.cs.ut.ee/gprofiler/page/docs
  #
  # R toolbox documentation:
  # https://cran.r-project.org/web/packages/gprofiler2/gprofiler2.pdf
  # 
  #
  # ---------- CODE STARTS HERE ----------
  
  # load required libraries 
  library(gprofiler2)
  library(rvest)
  library(httr)
  
  # load bootsrapped gene weights from .csv file
  fid1 <- sig_gWeight_root
  PLS <- read.csv(file=paste(getwd(),"/",wdir,fid1,".csv",sep=""), header=TRUE)
  
  # separate out genes with a positive / negative zscore
  # select only genes that are significantly weight, and include adjusted pvals
  upw.genes <- subset(PLS, zscores>0 & significant)
  upw.genes <- as.character(upw.genes[order(upw.genes$adj.pvals),]$geneIDs)
  dnw.genes <- subset(PLS, zscores<0 & significant)
  dnw.genes <- as.character(dnw.genes[order(dnw.genes$adj.pvals),]$geneIDs)
  
  ##### gProfiler starts here
  
  # run for upweighted and downweighted genes separately
  # N.B. ordered_query=TRUE means pvals are taken into account when doing enrichment test
  # N.B. uncomment / edit sources if you only want GO specific GO annotations 
  upw.results <- gprofiler2::gost(query=upw.genes, organism="hsapiens", 
                                  ordered_query=TRUE, user_threshold=threshold, correction_method=cmethod
                                  #, sources=c("GO:BP","GO:CC","KEGG","REAC","WP")
                                  )
  
  dnw.results <- gprofiler2::gost(query=dnw.genes, organism="hsapiens",
                                  ordered_query=TRUE, user_threshold=threshold, correction_method=cmethod
                                  #, sources=c("GO:BP","GO:CC","KEGG","REAC","WP")
                                  )
  
  # tidy the results a bit and remove GO terms >= max_term_size
  filtered.upw.results <- subset(upw.results$result, upw.results$result$term_size<max_term_size)
  filtered.upw.results <- subset(filtered.upw.results, select =c(source, term_name, 
                                                                term_id, p_value, significant, 
                                                                term_size, query_size, intersection_size, 
                                                                precision, recall, effective_domain_size))
  filtered.dnw.results <- subset(dnw.results$result, dnw.results$result$term_size<max_term_size)
  filtered.dnw.results <- subset(filtered.dnw.results, select =c(source, term_name, 
                                                                 term_id, p_value, significant, 
                                                                 term_size, query_size, intersection_size, 
                                                                 precision, recall, effective_domain_size))
  
  # save spreadsheets in wdir
  write.csv(filtered.upw.results,file=paste(getwd(),"/",wdir,"GO_UPW_",fid1,".csv",sep=""))
  write.csv(filtered.dnw.results,file=paste(getwd(),"/",wdir,"GO_DNW_",fid1,".csv",sep=""))

# revigo (THIS BIT DOESN'T WORK did revigo analyses on the website manually) ------------------------------------------------------------------

  # doesn't work = I couldn't figure out how to make it work
  
  # Not sure how to extract the "plot_Y" and "plot_X" info from the revigo results page, although was able to extract other results info
  # I think that info relies on running flash on the page, not sure how to run from here with rvest/httr
  # I.e. leaving this for now, not too much of a pain to do it on the website (until chrome stops supporting flash)
  
#  ##### REVIGO 
#  library(rvest)
#  library(httr)
#  revigo.session <- html_session("http://revigo.irb.hr/")
#  revigo.form <- html_form(revigo.session)[[1]] 
#  
#  # UPWEIGHTED
#  
#  # make query
#  goList.upw <- subset(filtered.dnw.results, filtered.dnw.results$source == "GO:BP")
#  goList.upw <- subset(goList.upw, select = c(term_id,p_value))
#  REVIGO.query.upw <- ""
#  for (u in nrow(goList.upw)) {
#    REVIGO.query.upw <- paste(REVIGO.query.upw,goList.resulupw$term_id[u]," ",
#                             goList.upw$p_value[u],"\n",sep = "")
#  }
#  revigo.form.upw <- set_values(revigo.form,'goList' = goList.upw, 'cutoff'=0.7, 
#                                      'isPValue'="yes",'goSizes'= 9606,'whatIsBetter'="higher")
#  result.page.upw <- submit_form(revigo.session, revigo.form.upw, submit='startRevigo')
#  revigo.table.upw <- html_table(result.page.upw)[[1]]
#  names(revigo.table.upw) <- revigo.table.upw[2,]
#  revigo.table.upw <- revigo.table.upw[3:nrow(revigo.table.upw),]
  
}