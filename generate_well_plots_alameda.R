####------------------------- SET UP ------------------------------####

# clean up
rm(list=ls())

# set working directory
setwd('C:/gsflow_lowerGSFLOWupperPRMS')


####------------------------- READ IN ------------------------------####

hobs <- read.table('./gsflow/output/modflow/hobs.out', header=FALSE, skip=1, col.names=c('sim','obs','name'))



####------------------------- REFORMAT ------------------------------####

hobs$name <- as.character(hobs$name)
hobs$id   <- sapply(strsplit(hobs[,'name'], "\\_"), `[[`, 1)
hobs$date <- sapply(strsplit(hobs[,'name'], "\\_"), `[[`, 2)
hobs$date <- as.Date(hobs$date, "%Y%m%d")
gwNames <- unique(hobs$id)



####------------------------- PLOT ------------------------------####


for(i in (1:length(gwNames))){
  
  # subset
  wel <- subset(hobs, hobs$id==gwNames[i])
  
  # calculate min and max
  yMin <- min(wel$sim, wel$obs, na.rm=TRUE)
  yMax <- max(wel$sim, wel$obs, na.rm=TRUE)
  
  # plot
  if(nrow(wel)!=0){
    png(paste('./R_outputs/plots/gw_',gwNames[i],'.png',sep=''), height=600, width=700, res=130)
    plot(wel$date, wel$sim, col="blue", typ='l', xlab='Date', ylab='Head (ft)', 
         ylim=c(yMin - (0.05*yMin), (yMax+(0.05*yMax))), las=1,
         main = paste0('Groundwater Well: ', gwNames[i]))
    lines(wel$date, wel$obs, col='red')
    grid(nx=NA, ny=NULL)
    abline(v=pretty(extendrange(wel$date)),
           col='lightgray', lty='dotted')    
    legend("topright", c('Simulated', 'Observed'), col=c('blue','red'), lty=c(1,1), bty='n')
    dev.off()
  }
  
}
