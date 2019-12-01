#---- Goal ------------------------------------------------------------------####

# Make plots of simulated vs. observed:
# 1) monthly mean groundwater heads for each year
# 2) total annual streamflow
# 3) monthly mean streamflow for each year
# 4) Alameda Ck at Welch Ck and at San Antonio Ck flows when Alameda Ck at Welch Ck < 100 cfs: 
#    plotted on same plot
# 5) Alameda Ck at Welch Ck and at SAPS bridge flows when Alameda Ck at Welch Ck < 100 cfs: plotted on same plots
# 6) Alameda Ck at SAPS bridge and Alameda Ck at San Antonio Ck flows when Alameda Ck at Welch Ck < 100 cfs: plotted on same plots
# 7) plot streamflow losses between Welch Ck and San Antonio Ck by subtracting Welch Ck minus San Antonio Ck
# 8) plot streamflow losses between Welch Ck and Saps Bridge by subtracting Welch Ck minus Saps Bridge
# 9) plot streamflow losses between Saps Bridge and San Antonio Ck by subtracting Saps Bridge minus San Antonio Ck 
# 10) daily groundwater heads 
# 11) daily streamflows
# 12) daily lake stages


# Calculate metrics for each of the plots above: 
# percent error for all, except for daily flows do Kling-Gupta or Nash-Sutcliffe efficiency





#--------------------------------------------------------------------------------#
#---- PREPARE -------------------------------------------------------------------#
#--------------------------------------------------------------------------------#




#---- Set up -----------------------------------------------------------------####


# install packages
#install.packages("tidyverse")


# load packages
library(tidyverse)
library(lubridate)


# set working directory
setwd("C:/git_repos/alameda/pestPrep")


# assign simulation start and end dates
start_date <- '2008-10-01'
end_date <- '2014-09-30'


# create list of streamflow gauging station names
sf_names <- list('streamflow_AlamedaCreekBelowCalaverasCreek',
                 'streamflow_AlamedaCreekBelowWelchCreek',
                 'streamflow_AlamedaCreekAtSAPSbridge',
                 'streamflow_AlamedaCreekAboveSanAntonioCreek',
                 'streamflow_AlamedaCreekAboveArroyoDeLaLaguna',
                 'streamflow_AlamedaCreekNearNiles')


# create list of streamflow gauging station names for plotting
sf_names_pretty <- list('Alameda Creek below Calaveras Creek',
                        'Alameda Creek below Welch Creek',
                        'Alameda Creek at SAPS bridge',
                        'Alameda Creek above San Antonio Creek',
                        'Alameda Creek above Arroyo de la Laguna',
                        'Alameda Creek near Niles')


# precip names
precip_names <- list('san_antonio', 
                     'mount_hamilton',
                     'alameda_east',
                     'calaveras',
                     'sunol')


# create list of lake names
lakeNames <- list('No_Name_Pond',
                  'Pond_F6',
                  'Ready_Mix_Pond',
                  'Pond_F5',
                  'Pond_F4', 
                  'Pond_F3W',
                  'Pond_F3E',
                  'Pond_F2',
                  'Pond_SMP_32')


# create list of lake names for plotting
lakeNamesPretty <- list('No Name Pond',
                        'Pond F6',
                        'Ready Mix Pond',
                        'Pond F5',
                        'Pond F4',
                        'Pond F3W',
                        'Pond F3E',
                        'Pond F2',
                        'Pond SMP 32')





#---- Read in -----------------------------------------------------------------####


# read in simulated and observed groundwater
hobs <- read.table('./gsflow/output/modflow/hobs.out', header=FALSE, 
                   skip=1, col.names=c('sim','obs','name'))


# read in simulated streamflow
sf_sim <- list()
for (i in 1:length(sf_names)){
  sf_sim[[i]] <- read.table(paste0('./gsflow/output/modflow/', sf_names[[i]], '.out'), 
                            skip=2, header=FALSE, na.strings=-999,
                            col.names=c('Time','Stage','Depth','GWHead','MidptFlow',
                                        'StreamLoss','GWRech','ChngeUZStor','VolUZStor'))
}


# read in observed streamflow and precip
sf_obs <- read.table('./gsflow/input/prms_lower/alameda_data_20191115.prms', 
                     skip=36, header=FALSE, na.strings= '-999')


# read in simulated lake stages
lakeSim <- list()
for (i in 1:length(lakeNames)){
  lakeSim[[i]] <- read.table(paste0('./gsflow/output/modflow/subbasin_runoff/', lakeNames[[i]], '.out'), 
                             skip=3, header=FALSE, na.strings= '-999', blank.lines.skip = TRUE,
                             col.names=c('Time','Stage','Volume','Vol Change','Precip','Evap','LAK-Runoff',
                                         'UZF-Runoff', 'GW-Inflw', 'GW-Outflw', 'LAK-to-UZF', 'SW-Inflw', 
                                         'SW-Outflw', 'Withdrawal', 'Lake-Inflx', 'Total-Cond', 'Percent_Err'))
}
names(lakeSim) <- lakeNames




# read in observed lake stages
lakeObs <- read.csv(file = './GIS/lakes/lakeStageAllWideCut_2008.csv', header=TRUE, na.strings='-999')
lakeObs$date <- as.Date(lakeObs$date)
lakeObs <- data.frame(date = lakeObs$date, ymd = lakeObs$ymd, NoNamePond = NA, pondF6 = lakeObs$F6,
                      readyMixPond = lakeObs$ReadyMix, pondF5 = NA, pondF4 = lakeObs$F4, pondF3W = lakeObs$F3W,
                      pondF3E = lakeObs$F3E, pondF2 = lakeObs$F2, pondSMP32 = NA)






#-------------------------------------------------------------------------------------------#
#---- REFORMAT -----------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------#



#---- Reformat groundwater --------------------------------------------------------------####

hobs$name <- as.character(hobs$name)
hobs$id   <- sapply(strsplit(hobs[,'name'], "\\_"), `[[`, 1)
hobs$date <- sapply(strsplit(hobs[,'name'], "\\_"), `[[`, 2)
hobs$date <- as.Date(hobs$date, "%Y%m%d")
gw_names <- unique(hobs$id)




#---- Reformat simulated streamflow ----------------------------------------------------####

# assign names
names(sf_sim) <- sf_names

# assign time stamp to simulated values 
sf_dates <- seq(as.Date(start_date), as.Date(end_date), by='day')

# Check to make sure their lengths are equivalent before merging:
for (i in 1:length(sf_sim)){
  
  if (length(sf_dates == nrow(sf_sim[[i]]))){
    
    sf_sim[[i]]$date <- sf_dates
  }
  
}



#---- Reformat observed streamflow and precip ---------------------------------------------------####


sf_obs <- sf_obs[,c(1:6, 14,15,20,17,18,16, 21:25)]  
names(sf_obs) <- c(list('year', 'month', 'day', 'hour', 'minute', 'second'), sf_names, precip_names)   
sf_obs$date <- seq(as.Date('1995-10-01'), as.Date('2014-09-30'), by='day')
sf_obs <- subset(sf_obs, subset=sf_obs$date >= as.Date(start_date) & sf_obs$date <= as.Date(end_date))




#---- Reformat simulated and observed streamflow: place in data frame together -------------------------####

# reformat simulated flow
sf_sim_df <- bind_rows(sf_sim, .id="id")
sf_sim_df <- sf_sim_df %>% 
  dplyr::select(., id, date, MidptFlow) %>%
  dplyr::rename(., sim = MidptFlow) %>%
  mutate(., sim = sim/86400)  # convert to cfs

# reformat observed flow
sf_obs_r <- sf_obs %>%
  dplyr::select(., 
                -year, -month, -day, -hour, -minute, -second, -san_antonio, 
                -mount_hamilton, -alameda_east, -calaveras, -sunol) %>%
  gather(., key="id", value="obs", -date)


# create a data frame of simulated and observed streamflow
sf_obs_sim <- left_join(sf_obs_r, sf_sim_df, by=c("id", "date"))

# place in long format
sf_obs_sim <- sf_obs_sim %>% 
  gather(., key="type", value="value", sim, obs)

# add year, month, hyd_year, and hyd_month columns
sf_obs_sim <- sf_obs_sim %>%
  mutate(., 
         year = year(date),
         month = month(date),
         hyd_month = case_when(month == 10 ~ 1,
                               month == 11 ~ 2, 
                               month == 12 ~ 3,
                               month == 1 ~ 4,
                               month == 2 ~ 5,
                               month == 3 ~ 6,
                               month == 4 ~ 7,
                               month == 5 ~ 8, 
                               month == 6 ~ 9,
                               month == 7 ~ 10,
                               month == 8 ~ 11,
                               month == 9 ~ 12),
         hyd_year = case_when(month %in% c(10:12) ~ year + 1,
                              month %in% c(1:9) ~ year))





#----------------------------------------------------------------------------------------------#
#---- PLOT ------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#



#---- Plot monthly mean groundwater heads for each year-------------------------------------####

# create month and year columns
hobs_my <- hobs %>%
  mutate(., 
         month = month(date),
         year = year(date))

# calculate mean by month and year, create hydrologic year and month columns
hobs_mean <- hobs_my %>% 
  group_by(., id, year, month) %>%
  dplyr::select(., -name, -date) %>%
  summarise_all(., mean, na.rm=TRUE) %>%
  gather(., key="type", value="value", sim, obs) %>%
  mutate(., 
         hyd_month = case_when(month == 10 ~ 1,
                               month == 11 ~ 2, 
                               month == 12 ~ 3,
                               month == 1 ~ 4,
                               month == 2 ~ 5,
                               month == 3 ~ 6,
                               month == 4 ~ 7,
                               month == 5 ~ 8, 
                               month == 6 ~ 9,
                               month == 7 ~ 10,
                               month == 8 ~ 11,
                               month == 9 ~ 12),
         hyd_year = case_when(month %in% c(10:12) ~ year + 1,
                              month %in% c(1:9) ~ year))

# plot
for (i in 1:length(gw_names)){
  
  # open plotting device
  file_name <- paste0("./analyze_gsflow_outputs/plots/gw_monthly_mean_", gw_names[i], ".jpg")
  jpeg(filename=file_name, width = 8, height = 8, 
       units = "in", quality = 75, res = 300) 
  
  # filter by gw well
  this_plot <- hobs_mean %>%
    dplyr::filter(., id == gw_names[i]) %>%
    ggplot(data=.) +
    geom_line(aes(x=hyd_month, y=value, color=type)) + 
    geom_point(aes(x=hyd_month, y=value, color=type)) + 
    facet_wrap(~hyd_year) + 
    scale_x_continuous(breaks=c(1:12), labels = c(10,11,12,1:9)) +
    theme_bw() + 
    theme(legend.title = element_blank()) + 
    ggtitle(paste0("Groundwater well: ", gw_names[i])) + 
    xlab("\nMonth") + 
    ylab("Groundwater head (ft.)\n")  
  
  # print plot
  print(this_plot)
  
  # close plotting device
  dev.off()
  
}







#---- Plot total annual streamflow ------------------------------------------------------------------------####


# calculate total annual streamflow 
sf_annual_sum <- sf_obs_sim %>%
  mutate(., value = (value * 86400 * 365)/43559.9) %>%
  group_by(., id, type, hyd_year) %>%
  summarize_at(., c("value"), sum, na.rm=TRUE) %>%
  dplyr::filter(., hyd_year != 2009, hyd_year != 2010)


# plot
for (i in 1:length(sf_names)){
  
  # open plotting device
  file_name <- paste0("./analyze_gsflow_outputs/plots/sf_annual_sum_", sf_names[i], ".jpg")
  jpeg(filename=file_name, width = 8, height = 8, 
       units = "in", quality = 75, res = 300) 
  
  # plot
  this_plot <- sf_annual_sum %>% 
    dplyr::filter(., id==sf_names[i]) %>%
    ggplot(data = .) +
    geom_bar(aes(x=hyd_year, y=value, fill=type), stat='identity', position='dodge') +
    theme_bw() + 
    theme(legend.title = element_blank()) + 
    ggtitle(paste0("Streamflow gauge: ", sf_names[i])) + 
    xlab("\nHydrologic Year") + 
    ylab("Annual streamflow volume (acre-ft/yr)\n") 
    
  # print plot
  print(this_plot)
  
  # close plotting device
  dev.off()
  
}


  




#---- Plot monthly mean streamflow for each year ---------------------------------------------------####


# calculate monthly mean streamflow
sf_monthly_mean <- sf_obs_sim %>%
  dplyr::filter(., hyd_year != 2009, hyd_year != 2010) %>%
  group_by(., id, type, year, hyd_year, month, hyd_month) %>%
  summarize_at(., c("value"), mean, na.rm=TRUE) 

# plot
for (i in 1:length(sf_names)){
  
  # open plotting device
  file_name <- paste0("./analyze_gsflow_outputs/plots/sf_monthly_mean_", sf_names[i], ".jpg")
  jpeg(filename=file_name, width = 8, height = 8, 
       units = "in", quality = 75, res = 300) 
  
  # plot
  this_plot <- sf_monthly_mean %>% 
    dplyr::filter(., id==sf_names[i]) %>%
    ggplot(data = .) +
    geom_line(aes(x=hyd_month, y=value, color=type), linetype="dashed", size=1.25) + 
    geom_point(aes(x=hyd_month, y=value, color=type)) + 
    facet_wrap(~hyd_year, scales="free") + 
    scale_x_continuous(breaks=c(1:12), labels = c(10,11,12,1:9)) +
    theme_bw() + 
    theme(legend.title = element_blank()) + 
    ggtitle(paste0("Streamflow gauge: ", sf_names[i])) + 
    xlab("\nMonth") + 
    ylab("Streamflow (cfs)\n")  
  
  # print plot
  print(this_plot)
  
  # close plotting device
  dev.off()
  
  
}





#---- Plot daily Alameda Ck at Welch Ck and at San Antonio Ck flows when Alameda Ck at Welch Ck < 100 cfs (on same plot) --------####

# prep simulated flow
df_sim <- sf_obs_sim %>%
  dplyr::filter(., type=="sim", id %in% c("streamflow_AlamedaCreekBelowWelchCreek", "streamflow_AlamedaCreekAboveSanAntonioCreek")) %>%
  spread(., key=id, value=value) %>%
  dplyr::filter(., streamflow_AlamedaCreekBelowWelchCreek < 100) %>%
  gather(., key=id, value=value, streamflow_AlamedaCreekBelowWelchCreek, streamflow_AlamedaCreekAboveSanAntonioCreek) %>%
  mutate(., type="sim")


# prep observed flow
df_obs <- sf_obs_sim %>%
  dplyr::filter(., type=="obs", id %in% c("streamflow_AlamedaCreekBelowWelchCreek", "streamflow_AlamedaCreekAboveSanAntonioCreek")) %>%
  spread(., key=id, value=value) %>%
  dplyr::filter(., streamflow_AlamedaCreekBelowWelchCreek < 100) %>%
  gather(., key=id, value=value, streamflow_AlamedaCreekBelowWelchCreek, streamflow_AlamedaCreekAboveSanAntonioCreek) %>%
  mutate(., type="obs")

# place in one data frame
df_sim_obs <- bind_rows(df_obs, df_sim)

# plot on normal scale
file_name <- paste0("./analyze_gsflow_outputs/plots/sf_welch_sanant_lt100cfs.jpg")
jpeg(filename=file_name, width = 8, height = 8, 
     units = "in", quality = 75, res = 300) 
this_plot <- df_sim_obs %>% 
  ggplot(data=.) +
  geom_point(aes(x=date, y=value, color=id)) +
  facet_wrap(~type, nrow=2) +
  theme_bw() + 
  theme(legend.title = element_blank()) + 
  ggtitle(paste0("Flows at Alameda Ck at Welch Ck and San Antonio Ck when flow < 100 cfs at Welch Ck")) + 
  xlab("\nDate") + 
  ylab("Streamflow (cfs)\n") 
print(this_plot)
dev.off()

# plot on log scale
file_name <- paste0("./analyze_gsflow_outputs/plots/sf_welch_sanant_lt100cfs_log.jpg")
jpeg(filename=file_name, width = 8, height = 8, 
     units = "in", quality = 75, res = 300) 
this_plot <- df_sim_obs %>% 
  ggplot(data=.) +
  geom_point(aes(x=date, y=value, color=id)) +
  facet_wrap(~type, nrow=2) +
  scale_y_log10() + 
  theme_bw() + 
  theme(legend.title = element_blank()) + 
  ggtitle(paste0("Flows at Alameda Ck at Welch Ck and San Antonio Ck when flow < 100 cfs at Welch Ck, log scale")) + 
  xlab("\nDate") + 
  ylab("Streamflow (cfs)\n") 
print(this_plot)
dev.off()






#---- Plot daily Alameda Ck at Welch Ck and at SAPS Bridge flows when Alameda Ck at Welch Ck < 100 cfs (on same plot) --------####


# prep simulated flow
df_sim <- sf_obs_sim %>%
  dplyr::filter(., type=="sim", id %in% c("streamflow_AlamedaCreekBelowWelchCreek", "streamflow_AlamedaCreekAtSAPSbridge")) %>%
  spread(., key=id, value=value) %>%
  dplyr::filter(., streamflow_AlamedaCreekBelowWelchCreek < 100) %>%
  gather(., key=id, value=value, streamflow_AlamedaCreekBelowWelchCreek, streamflow_AlamedaCreekAtSAPSbridge) %>%
  mutate(., type="sim")


# prep observed flow
df_obs <- sf_obs_sim %>%
  dplyr::filter(., type=="obs", id %in% c("streamflow_AlamedaCreekBelowWelchCreek", "streamflow_AlamedaCreekAtSAPSbridge")) %>%
  spread(., key=id, value=value) %>%
  dplyr::filter(., streamflow_AlamedaCreekBelowWelchCreek < 100) %>%
  gather(., key=id, value=value, streamflow_AlamedaCreekBelowWelchCreek, streamflow_AlamedaCreekAtSAPSbridge) %>%
  mutate(., type="obs")

# place in one data frame
df_sim_obs <- bind_rows(df_obs, df_sim)

# plot on normal scale
file_name <- paste0("./analyze_gsflow_outputs/plots/sf_welch_saps_lt100cfs.jpg")
jpeg(filename=file_name, width = 8, height = 8, 
     units = "in", quality = 75, res = 300) 
this_plot <- df_sim_obs %>% 
  ggplot(data=.) +
  geom_point(aes(x=date, y=value, color=id)) +
  facet_wrap(~type, nrow=2) +
  theme_bw() + 
  theme(legend.title = element_blank()) + 
  ggtitle(paste0("Flows at Alameda Ck at Welch Ck and SAPS bridge when flow < 100 cfs at Welch Ck")) + 
  xlab("\nDate") + 
  ylab("Streamflow (cfs)\n") 
print(this_plot)
dev.off()

# plot on log scale
file_name <- paste0("./analyze_gsflow_outputs/plots/sf_welch_saps_lt100cfs_log.jpg")
jpeg(filename=file_name, width = 8, height = 8, 
     units = "in", quality = 75, res = 300) 
this_plot <- df_sim_obs %>% 
  ggplot(data=.) +
  geom_point(aes(x=date, y=value, color=id)) +
  facet_wrap(~type, nrow=2) +
  scale_y_log10() + 
  theme_bw() + 
  theme(legend.title = element_blank()) + 
  ggtitle(paste0("Flows at Alameda Ck at Welch Ck and SAPS bridge when flow < 100 cfs at Welch Ck, log scale")) + 
  xlab("\nDate") + 
  ylab("Streamflow (cfs)\n") 
print(this_plot)
dev.off()





#---- Plot daily Alameda Ck at SAPS bridge and at San Antonio Ck flows when Alameda Ck at Welch Ck < 100 cfs (on same plot) --------####



# prep simulated flow
df_sim <- sf_obs_sim %>%
  dplyr::filter(., type=="sim", id %in% c("streamflow_AlamedaCreekBelowWelchCreek", "streamflow_AlamedaCreekAtSAPSbridge", "streamflow_AlamedaCreekAboveSanAntonioCreek")) %>%
  spread(., key=id, value=value) %>%
  dplyr::filter(., streamflow_AlamedaCreekBelowWelchCreek < 100) %>%
  gather(., key=id, value=value, streamflow_AlamedaCreekAtSAPSbridge, streamflow_AlamedaCreekAboveSanAntonioCreek) %>%
  mutate(., type="sim")


# prep observed flow
df_obs <- sf_obs_sim %>%
  dplyr::filter(., type=="obs", id %in% c("streamflow_AlamedaCreekBelowWelchCreek", "streamflow_AlamedaCreekAtSAPSbridge", "streamflow_AlamedaCreekAboveSanAntonioCreek")) %>%
  spread(., key=id, value=value) %>%
  dplyr::filter(., streamflow_AlamedaCreekBelowWelchCreek < 100) %>%
  gather(., key=id, value=value, streamflow_AlamedaCreekAtSAPSbridge, streamflow_AlamedaCreekAboveSanAntonioCreek) %>%
  mutate(., type="obs")

# place in one data frame
df_sim_obs <- bind_rows(df_obs, df_sim) %>%
  dplyr::filter(., id != streamflow_AlamedaCreekBelowWelchCreek)

# plot on normal scale
file_name <- paste0("./analyze_gsflow_outputs/plots/sf_saps_sanant_lt100cfs.jpg")
jpeg(filename=file_name, width = 8, height = 8, 
     units = "in", quality = 75, res = 300) 
this_plot <- df_sim_obs %>% 
  ggplot(data=.) +
  geom_point(aes(x=date, y=value, color=id)) +
  facet_wrap(~type, nrow=2) +
  theme_bw() + 
  theme(legend.title = element_blank()) + 
  ggtitle(paste0("Flows at Alameda Ck at SAPS bridge and San Antonio Ck when flow < 100 cfs at Welch Ck")) + 
  xlab("\nDate") + 
  ylab("Streamflow (cfs)\n") 
print(this_plot)
dev.off()

# plot on log scale
file_name <- paste0("./analyze_gsflow_outputs/plots/sf_saps_sanant_lt100cfs_log.jpg")
jpeg(filename=file_name, width = 8, height = 8, 
     units = "in", quality = 75, res = 300) 
this_plot <- df_sim_obs %>% 
  ggplot(data=.) +
  geom_point(aes(x=date, y=value, color=id)) +
  facet_wrap(~type, nrow=2) +
  scale_y_log10() + 
  theme_bw() + 
  theme(legend.title = element_blank()) + 
  ggtitle(paste0("Flows at Alameda Ck at SAPS bridge and San Antonio Ck when flow < 100 cfs at Welch Ck, log scale")) + 
  xlab("\nDate") + 
  ylab("Streamflow (cfs)\n") 
print(this_plot)
dev.off()






#---- Plot streamflow losses between Welch Ck and San Antonio Ck ---------------------------------------------------####

# prep simulated flow
df_sim <- sf_obs_sim %>%
  dplyr::filter(., type=="sim", id %in% c("streamflow_AlamedaCreekBelowWelchCreek", "streamflow_AlamedaCreekAboveSanAntonioCreek")) %>%
  spread(., key=id, value=value) %>%
  mutate(., diff = streamflow_AlamedaCreekAboveSanAntonioCreek - streamflow_AlamedaCreekBelowWelchCreek) %>%
  gather(., key=id, value=value, diff) %>%
  mutate(., type="sim")


# prep observed flow
df_obs <- sf_obs_sim %>%
  dplyr::filter(., type=="obs", id %in% c("streamflow_AlamedaCreekBelowWelchCreek", "streamflow_AlamedaCreekAboveSanAntonioCreek")) %>%
  spread(., key=id, value=value) %>%
  mutate(., diff = streamflow_AlamedaCreekAboveSanAntonioCreek - streamflow_AlamedaCreekBelowWelchCreek) %>%
  gather(., key=id, value=value, diff) %>%
  mutate(., type="obs")

# place in one data frame together
df_sim_obs <- bind_rows(df_obs, df_sim)


# plot
file_name <- paste0("./analyze_gsflow_outputs/plots/sf_sanant_minus_welch.jpg")
jpeg(filename=file_name, width = 12, height = 8, 
     units = "in", quality = 75, res = 300) 
this_plot <- df_sim_obs %>% 
  ggplot(data=.) +
  geom_point(aes(x=date, y=value, color=type), shape=1) +
  facet_wrap(~hyd_year, scales="free") + 
  theme_bw() + 
  theme(legend.title = element_blank()) + 
  ggtitle(paste0("Flow difference: (Alameda Ck at San Antonio Ck) - (Alameda Ck at Welch Ck)")) + 
  xlab("\nDate") + 
  ylab("Streamflow difference (cfs)\n") 
print(this_plot)
dev.off()






#---- Plot streamflow losses between Welch Ck and SAPS bridge ---------------------------------------------------####


# prep simulated flow
df_sim <- sf_obs_sim %>%
  dplyr::filter(., type=="sim", id %in% c("streamflow_AlamedaCreekBelowWelchCreek", "streamflow_AlamedaCreekAtSAPSbridge")) %>%
  spread(., key=id, value=value) %>%
  mutate(., diff = streamflow_AlamedaCreekAtSAPSbridge - streamflow_AlamedaCreekBelowWelchCreek) %>%
  gather(., key=id, value=value, diff) %>%
  mutate(., type="sim")


# prep observed flow
df_obs <- sf_obs_sim %>%
  dplyr::filter(., type=="obs", id %in% c("streamflow_AlamedaCreekBelowWelchCreek", "streamflow_AlamedaCreekAtSAPSbridge")) %>%
  spread(., key=id, value=value) %>%
  mutate(., diff = streamflow_AlamedaCreekAtSAPSbridge - streamflow_AlamedaCreekBelowWelchCreek) %>%
  gather(., key=id, value=value, diff) %>%
  mutate(., type="obs")

# place in one data frame together
df_sim_obs <- bind_rows(df_obs, df_sim)


# plot
file_name <- paste0("./analyze_gsflow_outputs/plots/sf_saps_minus_welch.jpg")
jpeg(filename=file_name, width = 12, height = 8, 
     units = "in", quality = 75, res = 300) 
this_plot <- df_sim_obs %>% 
  ggplot(data=.) +
  geom_point(aes(x=date, y=value, color=type), shape=1) +
  facet_wrap(~hyd_year, scales="free") + 
  theme_bw() + 
  theme(legend.title = element_blank()) + 
  ggtitle(paste0("Flow difference: (Alameda Ck at SAPS bridge) - (Alameda Ck at Welch Ck)")) + 
  xlab("\nDate") + 
  ylab("Streamflow difference (cfs)\n") 
print(this_plot)
dev.off()



#---- Plot streamflow losses between SAPS bridge and San Antonio Ck ---------------------------------------------------####



# prep simulated flow
df_sim <- sf_obs_sim %>%
  dplyr::filter(., type=="sim", id %in% c("streamflow_AlamedaCreekAtSAPSbridge", "streamflow_AlamedaCreekAboveSanAntonioCreek")) %>%
  spread(., key=id, value=value) %>%
  mutate(., diff = streamflow_AlamedaCreekAboveSanAntonioCreek - streamflow_AlamedaCreekAtSAPSbridge) %>%
  gather(., key=id, value=value, diff) %>%
  mutate(., type="sim")


# prep observed flow
df_obs <- sf_obs_sim %>%
  dplyr::filter(., type=="obs", id %in% c("streamflow_AlamedaCreekAtSAPSbridge", "streamflow_AlamedaCreekAboveSanAntonioCreek")) %>%
  spread(., key=id, value=value) %>%
  mutate(., diff = streamflow_AlamedaCreekAboveSanAntonioCreek - streamflow_AlamedaCreekAtSAPSbridge) %>%
  gather(., key=id, value=value, diff) %>%
  mutate(., type="obs")

# place in one data frame together
df_sim_obs <- bind_rows(df_obs, df_sim)


# plot
file_name <- paste0("./analyze_gsflow_outputs/plots/sf_sanant_minus_saps.jpg")
jpeg(filename=file_name, width = 12, height = 8, 
     units = "in", quality = 75, res = 300) 
this_plot <- df_sim_obs %>% 
  ggplot(data=.) +
  geom_point(aes(x=date, y=value, color=type), shape=1) +
  facet_wrap(~hyd_year, scales="free") + 
  theme_bw() + 
  theme(legend.title = element_blank()) + 
  ggtitle(paste0("Flow difference: (Alameda Ck at San Antonio Ck) - (Alameda Ck at SAPS bridge)")) + 
  xlab("\nDate") + 
  ylab("Streamflow difference (cfs)\n") 
print(this_plot)
dev.off()






# #---- Plot daily groundwater with precip---------------------------------------------------####
# 
# 
# for(i in (1:length(gw_names))){
#   
#   # subset
#   wel <- subset(hobs, hobs$id==gw_names[i])
#   
#   # calculate min and max
#   y_min <- min(wel$sim, wel$obs, na.rm=TRUE)
#   y_max <- max(wel$sim, wel$obs, na.rm=TRUE)
#   
#   # plot
#   if(nrow(wel)!=0){
#     
#     png(paste('./analyze_gsflow_outputs/plots/gw_daily_',gw_names[i],'.png',sep=''), height=600, width=700, res=130)
#     par(mar=c(5,4,4,5) + 0.1)
#     
#     plot(wel$date, wel$sim, col="blue", typ='l', xlab='Date', ylab='Head (ft)', 
#          ylim=c(y_min - (0.05*y_min), (y_max+(0.05*y_max))), las=1,
#          main = paste0('Groundwater Well: ', gw_names[i]))
#     lines(wel$date, wel$obs, col='red')
#     
#     par(new=TRUE)
#     plot(sf_obs$date, sf_obs$san_antonio, type='l', lty=3, col="palegoldenrod", xaxt="n", yaxt="n", xlab="", 
#          ylab="", ylim=rev(range(sf_obs$san_antonio)))
#     axis(4)
#     mtext("Precipitation (inches)", side=4, line=3)
#     
#     grid(nx=NA, ny=NULL)
#     abline(v=pretty(extendrange(wel$date)),
#            col='lightgray', lty='dotted')    
#     legend("topright", c('Sim. head', 'Obs. head', 'Precip.'), col=c('blue','red', 'palegoldenrod'), lty=c(1,1,3), bty='n')
#     dev.off()
#     
#   }
#   
# }
# 




#---- Plot daily groundwater with Welch Creek streamflow ---------------------------------------------------####


for(i in (1:length(gw_names))){
  
  # subset
  wel <- subset(hobs, hobs$id==gw_names[i])
  
  # calculate min and max
  y_min <- min(wel$sim, wel$obs, na.rm=TRUE)
  y_max <- max(wel$sim, wel$obs, na.rm=TRUE)
  
  # plot
  if(nrow(wel)!=0){
    
    png(paste('./analyze_gsflow_outputs/plots/gw_daily_',gw_names[i],'.png',sep=''), height=600, width=700, res=130)
    par(mar=c(5,4,4,5) + 0.1)
    
    plot(wel$date, wel$sim, col="blue", typ='l', xlab='Date', ylab='Head (ft)', 
         ylim=c(y_min - (0.05*y_min), (y_max+(0.05*y_max))), las=1,
         main = paste0('Groundwater Well: ', gw_names[i]))
    lines(wel$date, wel$obs, col='red')
    
    par(new=TRUE)
    plot(sf_obs$date, sf_obs$streamflow_AlamedaCreekBelowWelchCreek, type='l', lty=3, col="palegoldenrod", xaxt="n", yaxt="n", xlab="", 
         ylab="", ylim=rev(range(sf_obs$streamflow_AlamedaCreekBelowWelchCreek, na.rm=TRUE)))
    axis(4)
    mtext("Streamflow (cfs)", side=4, line=3)
    
    grid(nx=NA, ny=NULL)
    abline(v=pretty(extendrange(wel$date)),
           col='lightgray', lty='dotted')    
    legend("topright", c('Sim. head', 'Obs. head', 'Streamflow'), col=c('blue','red', 'palegoldenrod'), lty=c(1,1,3), bty='n')
    dev.off()
    
  }
  
}





#---- Plot observed San Antonio precip with observed Welch Creek flow ---------------------------------------------------####


png('./analyze_gsflow_outputs/plots/observed_san_antonio_precip_welch_creek_flow.png', height=600, width=700, res=130)
par(mar=c(5,4,4,5) + 0.1)

plot(sf_obs$date, sf_obs$streamflow_AlamedaCreekBelowWelchCreek, col="blue", typ='l', xlab='Date', ylab='Streamflow (cfs)', las=1,
     main = 'Observed San Antonio precip. and Welch Creek flow')
lines(sf_obs$date, sf_obs$streamflow_AlamedaCreekBelowWelchCreek, col='blue', lwd=2)

par(new=TRUE)
plot(sf_obs$date, sf_obs$san_antonio, type='l', lty=3, col="palegoldenrod", xaxt="n", yaxt="n", xlab="", 
     ylab="", ylim=rev(range(sf_obs$san_antonio, na.rm=TRUE)))
axis(4)
mtext("Precipitation (in)", side=4, line=3)

grid(nx=NA, ny=NULL)
abline(v=pretty(extendrange(wel$date)),
       col='lightgray', lty='dotted')    
legend("topright", c('Streamflow',  'Precipitation'), col=c('blue', 'palegoldenrod'), 
       lty=c(1,3), bty='n', lwd=c(2,1))
dev.off()







#---- Plot daily streamflow with precip: log scale and normal scale ---------------------------------------------------####



# plot
for (i in 1:length(sf_sim)){
  
  
  # calculate min and max - regular scale
  y_min <- min(sf_sim[[i]]$MidptFlow / 86400, sf_obs[,(i+6)], na.rm=TRUE)
  y_max <- max(sf_sim[[i]]$MidptFlow / 86400, sf_obs[,(i+6)], na.rm=TRUE)
  
  
  # plot on regular scale
  png(filename = paste0('./analyze_gsflow_outputs/plots/00', i, '_', sf_names[[i]], '.png'), 
      width=6.5, height=4.5, units='in', res=140)
  par(mar=c(5,6,4,5) + 0.1)
  
  plot(sf_sim[[i]]$date, sf_sim[[i]]$MidptFlow / 86400, 
       main = paste0('Streamflow: ', sf_names_pretty[[i]]),
       typ='l', xaxs='i', yaxs='i', xlab="Date",
       ylab=NA, las=1,
       ylim = c(0, y_max + (0.05*y_max)), col='blue')
  title(ylab=expression(paste('Streamflow (', ft^3~ s^-1, ')', sep='')), line=4, cex.axis=1.5)
  lines(sf_obs$date, sf_obs[,(i+6)], typ='l',lty=2, col='red')
  
  par(new=TRUE)
  plot(sf_obs$date, sf_obs$san_antonio, type='l', lty=3, col="palegoldenrod", xaxt="n", yaxt="n", xlab="", 
       ylab="", ylim=rev(range(sf_obs$san_antonio)))
  axis(4)
  mtext("Precipitation (inches)", side=4, line=3)
  
  grid(nx=NA, ny=NULL)
  abline(v=pretty(extendrange(sf_sim[[i]]$date)),
         col='lightgray', lty='dotted')
  legend('topright', c('Sim. flow','Obs. flow', 'Precip.'), col=c('blue','red', 'palegoldenrod'), 
         lty=c(1,2,3), bty='n', bg='white') 
  dev.off()
  
  
  
  
  # plot on log scale
  png(filename = paste0('./analyze_gsflow_outputs/plots/00', i, '_', sf_names[[i]], '_log.png'), 
      width=6.5, height=4.5, units='in', res=140)
  par(mar=c(5,6,4,5) + 0.1)
  
  plot(sf_sim[[i]]$date, (sf_sim[[i]]$MidptFlow / 86400) + 0.1,
       main = paste0('Streamflow: ', sf_names_pretty[[i]]),
       typ='l', xlab='Date', xaxs='i', yaxs='i',
       ylab=NA, las=1,
       log="y", ylim = c(0.1, y_max + (0.05*y_max)), col='blue')
  title(ylab=expression(paste('log[ Streamflow (', ft^3~ s^-1, ') ]', sep='')), line=4, cex.axis=1.5)
  lines(sf_obs$date, sf_obs[,(i+6)] + 0.1, typ='l',lty=2, col='red')
  
  par(new=TRUE)
  plot(sf_obs$date, sf_obs$san_antonio, type='l', lty=3, col="palegoldenrod", xaxt="n", yaxt="n", xlab="", 
       ylab="", ylim=rev(range(sf_obs$san_antonio)))
  axis(4)
  mtext("Precipitation (inches)", side=4, line=3)
  
  grid(nx=NA, ny=NULL)
  abline(v=pretty(extendrange(sf_sim[[i]]$date)),
         col='lightgray', lty='dotted')
  legend('topright', c('Sim. flow','Obs. flow', 'Precip.'), col=c('blue','red', 'palegoldenrod'),
         lty=c(1,2,3), bty='n', bg='white')
  dev.off()
  
  
}









#----- Plot daily simulated vs. observed lake stages ---------------------------------------------####



# plot
for (i in 1:length(lakeSim)){
  
  
  # calculate min and max
  yMin <- min(lakeSim[[i]]$Stage, lakeObs[,(i+2)], na.rm=TRUE)
  yMax <- max(lakeSim[[i]]$Stage, lakeObs[,(i+2)], na.rm=TRUE)
  
  
  # plot
  png(filename = paste0('./analyze_gsflow_outputs/plots/lake_00', i+1, '_', lakeNames[[i]], '.png'), width=6.5, height=4.5, units='in', res=140)
  par(mar=c(5,6,4,2))
  plot(lakeObs$date, lakeSim[[i]]$Stage, 
       main = paste0('Lake ',i+1, ': ', lakeNamesPretty[[i]]),
       typ='l', xaxs='i', yaxs='i', xlab="Date",
       ylab=NA, las=1,
       ylim = c((yMin-(0.05*yMin)), (yMax + (0.05*yMax))), col='blue')
  title(ylab='Lake stage (ft)', line=4, cex.axis=1.5)
  lines(lakeObs$date, lakeObs[,(i+2)], typ='l',lty=2, col='red')
  grid(nx=NA, ny=NULL)
  abline(v=pretty(extendrange(lakeObs$date)),
         col='lightgray', lty='dotted')
  legend('topright', c('Simulated','Observed'), col=c('blue','red'), 
         lty=c(1,2), bty='n', bg='white') 
  dev.off()
  
  
}

