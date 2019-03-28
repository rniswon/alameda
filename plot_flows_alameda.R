####------------------------- NOTES ------------------------------####

# to do:
# 1) remove the value from day 1461 (set to NA) but record which ones had that high 
#    value (and what the value was) - place on slide
# 2) include map of streamflow and gw stations in powerpoint
# 3) move y axis label back a bit - done
# 4) change x-axis grid lines to be on the year - done
# 5) consider plotting each year separately 



####------------------------- SET UP ------------------------------####

# clean up
rm(list=ls())

# set working directory
setwd('C:/git_repos/alameda/pestPrep')


####------------------------- READ IN ------------------------------####

# create list of streamflow gauging station names
sfNames <- list('streamflow_IndianCreek',
                'streamflow_SanAntonioCreekAtIndianCreekRd',
                'streamflow_ArroyoHondo',
                'streamflow_SanAntonioCreek',
                'streamflow_CalaverasCreek',
                'streamflow_AlamedaCreekAboveACDD', 
                'streamflow_AlamedaCreekBelowACDD',
                'streamflow_AlamedaCreekBelowCalaverasCreek',
                'streamflow_AlamedaCreekBelowWelchCreek',
                'streamflow_AlamedaCreekNearNiles',
                'streamflow_AlamedaCreekAboveSanAntonioCreek',
                'streamflow_AlamedaCreekAboveArroyoDeLaLaguna')

# create list of streamflow gauging station names for plotting
sfNamesPretty <- list('Indian Creek',
                      'San Antonio Creek at Indian Creek Rd.',
                      'Arroyo Hondo',
                      'San Antonio Creek',
                      'Calaveras Creek',
                      'Alameda Creek above ACDD',
                      'Alameda Creek below ACDD',
                      'Alameda Creek below Calaveras Creek',
                      'Alameda Creek below Welch Creek',
                      'Alameda Creek near Niles',
                      'Alameda Creek above San Antonio Creek',
                      'Alameda Creek above Arroyo de la Laguna')


# read in GSFLOW-simulated streamflow data 
sfSim <- list()
for (i in 1:length(sfNames)){
  sfSim[[i]] <- read.table(paste0('./gsflow/output/modflow/', sfNames[[i]], '.out'), 
                           skip=2, header=FALSE, na.strings=-999,
                           col.names=c('Time','Stage','Depth','GWHead','MidptFlow','StreamLoss','GWRech','ChngeUZStor','VolUZStor'))
}
names(sfSim) <- sfNames


# read in observed streamflow data 
sfObs <- read.table('./gsflow/input/prms_lower/alameda_data_20170906.prms', skip=36, header=FALSE, na.strings= '-999')
sfObs <- sfObs[,1:18]  # may need to make this 19 after including Arroyo de la Laguna at Verona in output streamflow
names(sfObs) <- c(list('year', 'month', 'day', 'hour', 'minute', 'second'), sfNames[1:12])   # to exclude Calaveras Creek - reach below reservoir
sfObs$date <- seq(as.Date('1995-10-01'), as.Date('2014-09-30'), by='day')
sfObs <- subset(sfObs, subset=sfObs$date >= as.Date('2010-10-01') & sfObs$date <= as.Date('2014-09-30'))

# 
# # read in PRMS-simulated data for Arroyo Hondo and Upper Alameda
# statvar <- read.table(file = './gsflow/output/prms/statvar.dat', skip = 255, header = FALSE, na.strings= '-999')
# statvarHeadings <- read.table(file = './gsflow/output/prms/statvar.dat', skip = 1, header = FALSE, 
#                               na.strings= '-999', nrows=254)
# statvarHeadingsMod <- c('obsNum', 'year', 'month', 'day', 'hour', 'minute', 'second', as.character(statvarHeadings[,1]))
# names(statvar) <- statvarHeadingsMod
# prmsSim <- statvar[,c(1:7, 10, 13)]
# names(prmsSim)[8:9] <- c("ArroyoHondo", "UpperAlameda")




####------------------------- REFORMAT ------------------------------####


# Because the simulated values don't have a time stamp, need to give them one.  
# According to the transient control file, dates range from 10-1-2010 to 9-30-2014
sfDates <- seq(as.Date('2010-10-01'), as.Date('2014-09-30'), by='day')

# Check to make sure their lengths are equivelent before merging:
for (i in 1:length(sfSim)){
  
  if (length(sfDates == nrow(sfSim[[i]]))){
    
    sfSim[[i]]$date <- sfDates
  }
  
}




####------------------------- PLOT ------------------------------####



# remove the 1461th point from certain plots
for (i in 1:length(sfSim)){

  if (i %in% c(4,5,7,8,9,13)){
    sfSim[[i]]$MidptFlow[1461] <- NA
  }

}




# plot
for (i in 1:(length(sfSim)-1)){
  
  
  
  if (i == 3){
    
    # also plot PRMS Arroyo Hondo streamflow here
    
    # calculate min and max
    yMin <- min(sfSim[[i]]$MidptFlow / 86400, sfObs[,(i+6)], prmsSim$ArroyoHondo, na.rm=TRUE)
    yMax <- max(sfSim[[i]]$MidptFlow / 86400, sfObs[,(i+6)], prmsSim$ArroyoHondo, na.rm=TRUE)
    
    # plot
    png(filename = paste0('./pre_calibration_plots/00', i, sfNames[[i]], '.png'), width=6.5, height=4.5, units='in', res=140)
    par(mar=c(5,6,4,2))
    plot(sfSim[[i]]$date, sfSim[[i]]$MidptFlow / 86400, 
         main = paste0('Streamflow: ', sfNamesPretty[[i]]),
         typ='l', xaxs='i', yaxs='i', xlab="Date",
         ylab=NA, las=1,
         ylim = c(0, yMax + (0.05*yMax)), col='blue')
    title(ylab=expression(paste('Streamflow (', ft^3~ s^-1, ')', sep='')), line=4, cex.axis=1.5)
    lines(sfObs$date, sfObs[,(i+6)], typ='l',lty=2, col='red')
    lines(sfObs$date, prmsSim$ArroyoHondo, typ = 'l', lty = 3, col = "green")
    grid(nx=NA, ny=NULL)
    abline(v=pretty(extendrange(sfSim[[i]]$date)),
           col='lightgray', lty='dotted')
    legend('topright', c('GSFLOW Simulated','Observed', 'PRMS simulated'), col=c('blue','red', 'green'), 
           lty=c(1,2,3), bty='n', bg='white') 
    dev.off()
    
    # plot on log scale
    png(filename = paste0('./pre_calibration_plots/00', i, sfNames[[i]], '_log.png'), width=6.5, height=4.5, units='in', res=140)
    par(mar=c(5,6,4,2))
    plot(sfSim[[i]]$date, (sfSim[[i]]$MidptFlow / 86400) + 0.1, 
         main = paste0('Streamflow: ', sfNamesPretty[[i]]),
         typ='l', xlab='Date', xaxs='i', yaxs='i', 
         ylab=NA, las=1,
         log="y", ylim = c(0.1, yMax + (0.05*yMax)), col='blue')
    title(ylab=expression(paste('Streamflow (', ft^3~ s^-1, ')', sep='')), line=4, cex.axis=1.5)
    lines(sfObs$date, sfObs[,(i+6)] + 0.1, typ='l',lty=2, col='red')
    lines(sfObs$date, prmsSim$ArroyoHondo, typ = 'l', lty = 3, col = "green")
    grid(nx=NA, ny=NULL)
    abline(v=pretty(extendrange(sfSim[[i]]$date)),
           col='lightgray', lty='dotted')
    legend('topright', c('GSFLOW Simulated','Observed', 'PRMS simulated'), col=c('blue','red', 'green'), 
           lty=c(1,2,3), bty='n', bg='white') 
    dev.off()
    
    
    
  }else if (i == 5){
    
    # also plot CalaverasReachBelowReservoir here 
    
    # calculate min and max
    yMin <- min(sfSim[[i]]$MidptFlow / 86400, sfObs[,(i+6)], sfSim[[13]]$MidptFlow / 86400, na.rm=TRUE)
    yMax <- max(sfSim[[i]]$MidptFlow / 86400, sfObs[,(i+6)],  sfSim[[13]]$MidptFlow / 86400, na.rm=TRUE)
    
    # plot
    png(filename = paste0('./pre_calibration_plots/00', i, sfNames[[i]], '.png'), width=6.5, height=4.5, units='in', res=140)
    par(mar=c(5,6,4,2))
    plot(sfSim[[i]]$date, sfSim[[i]]$MidptFlow / 86400, 
         main = paste0('Streamflow: ', sfNamesPretty[[i]]),
         typ='l', xaxs='i', yaxs='i', xlab="Date",
         ylab=NA, las=1,
         ylim = c(0, yMax + (0.05*yMax)), col='blue')
    title(ylab=expression(paste('Streamflow (', ft^3~ s^-1, ')', sep='')), line=4, cex.axis=1.5)
    lines(sfObs$date, sfObs[,(i+6)], typ='l',lty=2, col='red')
    lines(sfObs$date, sfSim[[13]]$MidptFlow / 86400, typ = 'l', lty = 3, col = "green")
    grid(nx=NA, ny=NULL)
    abline(v=pretty(extendrange(sfSim[[i]]$date)),
           col='lightgray', lty='dotted')
    legend('topright', c('Simulated - gauge reach','Observed', 'Simulated - reach below reservoir'), 
           col=c('blue','red', 'green'), lty=c(1,2,3), bty='n', bg='white') 
    dev.off()
    
    # plot on log scale
    png(filename = paste0('./pre_calibration_plots/00', i, sfNames[[i]], '_log.png'), width=6.5, height=4.5, units='in', res=140)
    par(mar=c(5,6,4,2))
    plot(sfSim[[i]]$date, (sfSim[[i]]$MidptFlow / 86400) + 0.1, 
         main = paste0('Streamflow: ', sfNamesPretty[[i]]),
         typ='l', xlab='Date', xaxs='i', yaxs='i', 
         ylab=NA, las=1,
         log="y", ylim = c(0.1, yMax + (0.05*yMax)), col='blue')
    title(ylab=expression(paste('Streamflow (', ft^3~ s^-1, ')', sep='')), line=4, cex.axis=1.5)
    lines(sfObs$date, sfObs[,(i+6)] + 0.1, typ='l',lty=2, col='red')
    lines(sfObs$date, sfSim[[13]]$MidptFlow / 86400, typ = 'l', lty = 3, col = "green")
    grid(nx=NA, ny=NULL)
    abline(v=pretty(extendrange(sfSim[[i]]$date)),
           col='lightgray', lty='dotted')
    legend('topright', c('Simulated - gauge reach','Observed', 'Simulated - reach below reservoir'), 
           col=c('blue','red', 'green'), lty=c(1,2,3), bty='n', bg='white') 
    dev.off()
    
    
    
  }else if (i == 6){
    
    # also plot PRMS Upper Alameda streamflow here
    
    # calculate min and max
    yMin <- min(sfSim[[i]]$MidptFlow / 86400, sfObs[,(i+6)], prmsSim$UpperAlameda, na.rm=TRUE)
    yMax <- max(sfSim[[i]]$MidptFlow / 86400, sfObs[,(i+6)], prmsSim$UpperAlameda, na.rm=TRUE)
    
    # plot
    png(filename = paste0('./pre_calibration_plots/00', i, sfNames[[i]], '.png'), width=6.5, height=4.5, units='in', res=140)
    par(mar=c(5,6,4,2))
    plot(sfSim[[i]]$date, sfSim[[i]]$MidptFlow / 86400, 
         main = paste0('Streamflow: ', sfNamesPretty[[i]]),
         typ='l', xaxs='i', yaxs='i', xlab="Date",
         ylab=NA, las=1,
         ylim = c(0, yMax + (0.05*yMax)), col='blue')
    title(ylab=expression(paste('Streamflow (', ft^3~ s^-1, ')', sep='')), line=4, cex.axis=1.5)
    lines(sfObs$date, sfObs[,(i+6)], typ='l',lty=2, col='red')
    lines(sfObs$date, prmsSim$UpperAlameda, typ = 'l', lty = 3, col = "green")
    grid(nx=NA, ny=NULL)
    abline(v=pretty(extendrange(sfSim[[i]]$date)),
           col='lightgray', lty='dotted')
    legend('topright', c('GSFLOW Simulated','Observed', 'PRMS simulated'), col=c('blue','red', 'green'), 
           lty=c(1,2,3), bty='n', bg='white') 
    dev.off()
    
    # plot on log scale
    png(filename = paste0('./pre_calibration_plots/00', i, sfNames[[i]], '_log.png'), width=6.5, height=4.5, units='in', res=140)
    par(mar=c(5,6,4,2))
    plot(sfSim[[i]]$date, (sfSim[[i]]$MidptFlow / 86400) + 0.1, 
         main = paste0('Streamflow: ', sfNamesPretty[[i]]),
         typ='l', xlab='Date', xaxs='i', yaxs='i', 
         ylab=NA, las=1,
         log="y", ylim = c(0.1, yMax + (0.05*yMax)), col='blue')
    title(ylab=expression(paste('Streamflow (', ft^3~ s^-1, ')', sep='')), line=4, cex.axis=1.5)
    lines(sfObs$date, sfObs[,(i+6)] + 0.1, typ='l',lty=2, col='red')
    lines(sfObs$date, prmsSim$UpperAlameda, typ = 'l', lty = 3, col = "green")
    grid(nx=NA, ny=NULL)
    abline(v=pretty(extendrange(sfSim[[i]]$date)),
           col='lightgray', lty='dotted')
    legend('topright', c('GSFLOW Simulated','Observed', 'PRMS simulated'), col=c('blue','red', 'green'), 
           lty=c(1,2,3), bty='n', bg='white') 
    dev.off()
    
    
    
  }else {
    
    # calculate min and max
    yMin <- min(sfSim[[i]]$MidptFlow / 86400, sfObs[,(i+6)], na.rm=TRUE)
    yMax <- max(sfSim[[i]]$MidptFlow / 86400, sfObs[,(i+6)], na.rm=TRUE)
    
    # plot
    png(filename = paste0('./pre_calibration_plots/00', i, sfNames[[i]], '.png'), width=6.5, height=4.5, units='in', res=140)
    par(mar=c(5,6,4,2))
    plot(sfSim[[i]]$date, sfSim[[i]]$MidptFlow / 86400, 
         main = paste0('Streamflow: ', sfNamesPretty[[i]]),
         typ='l', xaxs='i', yaxs='i', xlab="Date",
         ylab=NA, las=1,
         ylim = c(0, yMax + (0.05*yMax)), col='blue')
    title(ylab=expression(paste('Streamflow (', ft^3~ s^-1, ')', sep='')), line=4, cex.axis=1.5)
    lines(sfObs$date, sfObs[,(i+6)], typ='l',lty=2, col='red')
    grid(nx=NA, ny=NULL)
    abline(v=pretty(extendrange(sfSim[[i]]$date)),
           col='lightgray', lty='dotted')
    legend('topright', c('Simulated','Observed'), col=c('blue','red'), 
           lty=c(1,2), bty='n', bg='white') 
    dev.off()
    
    # plot on log scale
    png(filename = paste0('./pre_calibration_plots/00', i, sfNames[[i]], '_log.png'), width=6.5, height=4.5, units='in', res=140)
    par(mar=c(5,6,4,2))
    plot(sfSim[[i]]$date, (sfSim[[i]]$MidptFlow / 86400) + 0.1, 
         main = paste0('Streamflow: ', sfNamesPretty[[i]]),
         typ='l', xlab='Date', xaxs='i', yaxs='i', 
         ylab=NA, las=1,
         log="y", ylim = c(0.1, yMax + (0.05*yMax)), col='blue')
    title(ylab=expression(paste('Streamflow (', ft^3~ s^-1, ')', sep='')), line=4, cex.axis=1.5)
    lines(sfObs$date, sfObs[,(i+6)] + 0.1, typ='l',lty=2, col='red')
    grid(nx=NA, ny=NULL)
    abline(v=pretty(extendrange(sfSim[[i]]$date)),
           col='lightgray', lty='dotted')
    legend('topright', c('Simulated','Observed'), col=c('blue','red'), 
           lty=c(1,2), bty='n', bg='white') 
    dev.off()
    
  }
  
 
  
}







