#---- Goal -------------------------------------------------------------------####

# The purpose of this script is to extract the min and max values from the streamflow data,
# and then reformat them for the pest control file.





#---- Set up ------------------------------------------------------------------####

# clear workspace
rm(list=ls())

# install packages
# install.packages("plyr")
# install.packages("ggplot2")
# install.packages("stringr")
# install.packages("reshape2")
# install.packages("dplyr")
# install.packages("plotly")
# install.packages("devtools")
# install.packages("leaflet")
# install_github("rstudio/leaflet")
# install.packages("zoo")
# devtools::install_github("guiastrennec/ggplus")
# install.packages("scales")
# install.packages("rstudioapi")


# load libraries
library(plyr)
library(dplyr)
library(ggplot2)
library(reshape2)
library(stringr)
library(zoo)
library(scales)
library(lubridate)
library(tidyr)


# Set working directory
setwd("F:/SunolValleyProject/GSFLOW/Applications/SunolValley/Input_preparation/PEST_prep/prep_transient_pest_files")





#---- Read in data ------------------------------------------------------------------####


# read in streamflow data
prms_data <- read.csv("./observational_data/alameda_data_20170906.csv", header=TRUE, na.strings = "-999")







#---- Reformat ------------------------------------------------------------------####


# drop all non-streamflow or date columns
sf_wide <- prms_data[, c(1:19)]
sf_wide <- sf_wide %>% 
  select(., -hour, -minute, -second)

# create date column
sf_wide$date <- paste(sf_wide$year, sf_wide$mon, sf_wide$day, sep="-") %>% 
  ymd() 

# remove old date columns and place new one as the first column
sf_wide <- sf_wide %>% 
  select(-year, -month, -day) %>%
  select(date, everything())

# add column with number of days since the start of the modeling time period
model_start_date <- ymd("2008-10-01") # change this once done with calibration and running gsflow to 10/1/1995
model_end_date <- ymd("2014-09-30")
sf_wide$toffset <- sf_wide$date - model_start_date

# cut down to start and end dates (but exclude the actual start date)
sf_wide <- sf_wide %>% 
  filter(., sf_wide$date > model_start_date & sf_wide$date <= model_end_date)

# create long version
sf_long <- sf_wide %>% gather(., key="variable", value="value", -date, -toffset)

  
  

#---- Plot ----------------------------------------------------------------------------------####


# plot each time series
ggplot(sf_long, aes(date, value)) + 
  geom_point() + 
  geom_line() + 
  facet_wrap(~variable, scales="free_y")




#---- Extract min and max values -------------------------------------------------------------####


# # function to find inflection points
# inflect <- function(x, threshold = 1){
#   up   <- sapply(1:threshold, function(n) c(x[-(seq(n))], rep(NA, n)))
#   down <-  sapply(-1:-threshold, function(n) c(rep(NA,abs(n)), x[-seq(length(x), length(x) - abs(n) + 1)]))
#   a    <- cbind(x,up,down)
#   list(minima = which(apply(a, 1, min) == a[,1]), maxima = which(apply(a, 1, max) == a[,1]))
# }
# 
# # choose threshold
# # notes: 
# # n=100: about one min and max per year, but misses peaks within a year
# # n=50: similar to n=100
# # n=25 or 30: looks pretty good, but now starting to pick up multiple values within the valleys
# # n=10: getting a bunch that are neither peaks nor valleys
# n_min <- 20
# n_max <- 20
# 
# # apply function to find minima and maxima
# bottoms <- sapply(n_min, function(x) inflect(sf_long$value, threshold = x)$minima)
# tops <- sapply(n_max, function(x) inflect(sf_long$value, threshold = x)$maxima)
# 
# # create separate data frame for bottoms and tops
# bottoms_df <- sf_long[bottoms, ]
# tops_df <- sf_long[tops, ]
# 
# # call the minima and maxima as such
# bottoms_df <- rename(bottoms_df, minima = value)
# tops_df <- rename(tops_df, maxima = value)
# 
# 
# # join with sf_long by site and date
# sf_long <- full_join(sf_long, bottoms_df, by=c("variable", "toffset", "date"))
# sf_long <- full_join(sf_long, tops_df, by=c("variable", "toffset", "date"))
# 
# # extract sites
# sites <- unique(sf_long$variable)





#---- Plot with minima and maxima ----------------------------------------------------------####

# 
# png(filename= "./streamflow_identify_min_max.png", width = 12, height=9, units="in", res=300)
# 
# 
# # plot each time series
# ggplot(sf_long, aes(date)) + 
#   geom_point(aes(y=value), colour="black") + 
#   geom_line(aes(y=value), colour="black") + 
#   geom_point(aes(y=minima), colour="red") + 
#   geom_point(aes(y=maxima), colour="red") + 
#   facet_wrap(~variable, scales="free_y")
# 
# dev.off()




# #---- Create data frame of just minima and maxima ----------------------------------------------------------####
# 
# 
# # filter to only keep minima and maxima
# sf_min_max <- sf_long %>% 
#   dplyr::filter(., !is.na(minima) | !(is.na(maxima)))
# 
# # remove minima and maxima columns
# sf_min_max <- sf_min_max %>% 
#   dplyr::select(-minima, -maxima)





#---- Remove multiple low flow values in a row ----------------------------------------------------------####


# remove na
sf_long <- na.omit(sf_long)

# create value_cut column
sf_long$value_cut <- sf_long$value

# create vector of flow cutoff values 
flow_cutoff <- c(50, 50, 50, 50, 50, 50, 50, 50, 300, 50, 50, 200)

sites <- unique(sf_long$variable)
num_sites <- length(sites)
runs_list <- list()
for (i in 1:num_sites){
  
  # filter by site
  sf_long_filt <- sf_long %>% filter(., variable == sites[i])
  
  # assign all values < flow_cutoff to 0 
  idx <- which(sf_long_filt$value_cut < flow_cutoff[i])
  sf_long_filt$value_cut[idx] <- 0
  
  # calculate runs
  runs = rle(sf_long_filt$value_cut)
  tmp <- rep(runs$lengths, times = runs$lengths)
  runs <- data.frame(sf_long_filt, run_length=tmp)
  
  # assign each separate run a separate group id
  runs$group_id <- 1
  this_group_id <- 1
  num_row <- nrow(runs)
  for (j in 2:num_row){
    
    # if both value_cut and run_length are different from the prevous row, then advance the group id by 1
    if (runs$value_cut[j] != runs$value_cut[j-1]){
      
      # advance group id counter
      this_group_id <- this_group_id + 1
      
      # assign group id
      runs$group_id[j] <- this_group_id 
      
    }else{
      
      runs$group_id[j] <- this_group_id
      
    }
    
  }
  
  
  # store in list
  runs_list[[i]] <- runs
  
  
}






# TO DO: consider not having a value=0 condition below (plot first and see how it looks) so that any repeated values are 
# reduced in number (which will mostly be low flows)
# extract every n 0 values in each run of 0s
# loop through sites
for (i in 1:length(runs_list)){
  
  # extract data frame for a site
  df <- runs_list[[i]]
  
  # loop through group ids
  group_id <- unique(df$group_id)
  for (j in 1:length(group_id)){
    
    # identify rows in the same group
    idx_group <- which(df$group_id == group_id[j])

    # if run_length > 3  
    if (df$run_length[idx_group][1] > 3){
      
      # find indices of first, middle, and last rows of the group
      idx_selected <- c(idx_group[1], idx_group[ceiling(length(idx_group)/2)], idx_group[length(idx_group)])
      idx_not_selected <- idx_group[!idx_group %in% idx_selected]
      
      # remove the non-selected points
      df <- df[-idx_not_selected, ]
      
    }
    
  }
  
  runs_list[[i]] <- df
  
}



# place all data frames from list into one data frame
runs_all <- bind_rows(runs_list)





#---- Extract min and max values after removing repeated low flow values -------------------------------------------------------------####


# function to find inflection points
inflect <- function(x, threshold = 1){
  up   <- sapply(1:threshold, function(n) c(x[-(seq(n))], rep(NA, n)))
  down <-  sapply(-1:-threshold, function(n) c(rep(NA,abs(n)), x[-seq(length(x), length(x) - abs(n) + 1)]))
  a    <- cbind(x,up,down)
  list(minima = which(apply(a, 1, min) == a[,1]), maxima = which(apply(a, 1, max) == a[,1]))
}

# choose threshold
# notes: 
# n=100: about one min and max per year, but misses peaks within a year
# n=50: similar to n=100
# n=25 or 30: looks pretty good, but now starting to pick up multiple values within the valleys
# n=10: getting a bunch that are neither peaks nor valleys
n_min <- 3
n_max <- 3

# apply function to find minima and maxima
bottoms <- sapply(n_min, function(x) inflect(runs_all$value, threshold = x)$minima)
tops <- sapply(n_max, function(x) inflect(runs_all$value, threshold = x)$maxima)

# create separate data frame for bottoms and tops
bottoms_df <- runs_all[bottoms, ]
tops_df <- runs_all[tops, ]

# call the minima and maxima as such
bottoms_df <- rename(bottoms_df, minima = value)
tops_df <- rename(tops_df, maxima = value)


# join with sf_long by site and date
runs_all <- full_join(runs_all, bottoms_df, by=c("variable", "toffset", "date", "run_length", "group_id", "value_cut"))
runs_all <- full_join(runs_all, tops_df, by=c("variable", "toffset", "date", "run_length", "group_id", "value_cut"))

# extract sites
sites <- unique(runs_all$variable)





#---- Plot with minima and maxima after removing repeated low flow values ----------------------------------------------------------####


png(filename= "./streamflow_identify_min_max.png", width = 12, height=9, units="in", res=300)


# join runs_all and sf_long for plotting
runs_all_plot <- full_join(runs_all, sf_long, by=c("variable", "date", "toffset", "value", "value_cut"))


# plot each time series
ggplot(runs_all_plot, aes(date)) + 
  geom_point(aes(y=value), colour="black") + 
  geom_line(aes(y=value), colour="black") + 
  geom_point(aes(y=minima), colour="red") + 
  geom_point(aes(y=maxima), colour="red") + 
  facet_wrap(~variable, scales="free_y")



dev.off()




#---- Create data frame of just minima and maxima ----------------------------------------------------------####


# filter to only keep minima and maxima
sf_min_max <- runs_all %>% 
  dplyr::filter(., !is.na(minima) | !(is.na(maxima)))

# remove minima and maxima columns
sf_min_max <- sf_min_max %>% 
  dplyr::select(-minima, -maxima)












#---- Convert to cfd ----------------------------------------------------------####


# convert from cfs to cfd
num_seconds_per_day = 86400
sf_min_max$value <- sf_min_max$value * num_seconds_per_day





#---- Prep for pest control file export ----------------------------------------------------------####


# create a character version of the date
sf_min_max <- sf_min_max %>% 
  dplyr::mutate(., date_char = gsub("-", "", as.character(date))) 

# create a site ID column
site_id <- paste0("s", c(1,3:13))   # because San Antonio Creek at Indican Creek Rd got dropped above
sf_min_max$site_id <- "NA"
for (i in 1:length(sites)){
  
  idx <- which(sf_min_max$variable %in% sites[i]) 
  sf_min_max$site_id[idx] <- site_id[i]
  
}

# create obsnme, weight, and obsgnme columns
# select columns for export
sf_min_max <- sf_min_max %>%
  dplyr::mutate(., obsnme = paste0(site_id, "_", date_char),
                weight = 0.001,
                obsgnme = "Q_Obs") %>%
  select(., obsnme, value, weight, obsgnme)
  



#---- Export for pest control file ----------------------------------------------------------####


write.table(sf_min_max, file = "./modflow_files/pst_control_file_obs/streamflow_obs_for_pst.txt", row.names = FALSE, col.names=FALSE, quote=FALSE)


