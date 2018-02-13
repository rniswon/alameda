####------------------------- SET UP ------------------------------####

# clean up
rm(list=ls())

# set working directory
setwd('C:/gsflow_lowerGSFLOWupperPRMS')





####------------------------- READ IN ------------------------------####


# create list of streamflow gauging station names
lakeNames <- list('ACDD_Reservoir',
                'No_Name_Pond',
                'Pond_F6',
                'Ready_Mix_Pond',
                'Pond_F5',
                'Pond_F4', 
                'Pond_F3W',
                'Pond_F3E',
                'Pond_F2',
                'Pond_SMP_32',
                'San_Antonio_Reservoir',
                'Calaveras_Reservoir')


# create list of streamflow gauging station names for plotting
lakeNamesPretty <- list('ACDD Reservoir',
                      'No Name Pond',
                      'Pond F6',
                      'Ready Mix Pond',
                      'Pond F5',
                      'Pond F4',
                      'Pond F3W',
                      'Pond F3E',
                      'Pond F2',
                      'Pond SMP 32',
                      'San Antonio Reservoir',
                      'Calaveras Reservoir')


# read in simulated lake stages
lakeSim <- list()
for (i in 1:length(lakeNames)){
  lakeSim[[i]] <- read.table(paste0('./gsflow/output/modflow/', lakeNames[[i]], '.out'), 
                           skip=3, header=FALSE, na.strings= '-999', blank.lines.skip = TRUE,
                           col.names=c('Time','Stage','Volume','Vol Change','Precip','Evap','LAK-Runoff',
                                       'UZF-Runoff', 'GW-Inflw', 'GW-Outflw', 'LAK-to-UZF', 'SW-Inflw', 
                                       'SW-Outflw', 'Withdrawal', 'Lake-Inflx', 'Total-Cond', 'Percent_Err'))
}
names(lakeSim) <- lakeNames




# read in observed lake stages
lakeObs <- read.csv(file = 'lakeStageAllWideCut.csv', header=TRUE, na.strings='-999')
lakeObs$date <- as.Date(lakeObs$date)
lakeObs <- data.frame(date = lakeObs$date, ymd = lakeObs$ymd, ACDD = NA, NoNamePond = NA, pondF6 = lakeObs$F6,
                      readyMixPond = lakeObs$ReadyMix, pondF5 = NA, pondF4 = lakeObs$F4, pondF3W = lakeObs$F3W,
                      pondF3E = lakeObs$F3E, pondF2 = lakeObs$F2, pondSMP32 = NA,
                      sanAntonioReservoir = lakeObs$SanAntonioReservoir, 
                      calaverasReservoir = lakeObs$CalaverasReservoir)
                      






####------------------------- PLOT ------------------------------####



# plot
for (i in 1:length(lakeSim)){
    
    
    # calculate min and max
    yMin <- min(lakeSim[[i]]$Stage, lakeObs[,i+2], na.rm=TRUE)
    yMax <- max(lakeSim[[i]]$Stage, lakeObs[,i+2], na.rm=TRUE)
    
    
    # plot
    png(filename = paste0('./R_outputs/plots/stage_00', i, '_', lakeNames[[i]], '.png'), width=6.5, height=4.5, units='in', res=140)
    par(mar=c(5,6,4,2))
    plot(lakeObs$date, lakeSim[[i]]$Stage, 
         main = paste0('Lake ',i, ': ', lakeNamesPretty[[i]]),
         typ='l', xaxs='i', yaxs='i', xlab="Date",
         ylab=NA, las=1,
         ylim = c(yMin, yMax + (0.05*yMax)), col='blue')
    title(ylab='Lake stage (ft)', line=4, cex.axis=1.5)
    lines(lakeObs$date, lakeObs[,(i+2)], typ='l',lty=2, col='red')
    grid(nx=NA, ny=NULL)
    abline(v=pretty(extendrange(lakeObs$date)),
           col='lightgray', lty='dotted')
    legend('topright', c('Simulated','Observed'), col=c('blue','red'), 
           lty=c(1,2), bty='n', bg='white') 
    dev.off()
    
  
}





