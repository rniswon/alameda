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
n_min <- 20
n_max <- 20

# apply function to find minima and maxima
bottoms <- sapply(n_min, function(x) inflect(sf_long$value, threshold = x)$minima)
tops <- sapply(n_max, function(x) inflect(sf_long$value, threshold = x)$maxima)

# create separate data frame for bottoms and tops
bottoms_df <- sf_long[bottoms, ]
tops_df <- sf_long[tops, ]

# call the minima and maxima as such
bottoms_df <- rename(bottoms_df, minima = value)
tops_df <- rename(tops_df, maxima = value)


# join with sf_long by site and date
sf_long <- full_join(sf_long, bottoms_df, by=c("variable", "toffset", "date"))
sf_long <- full_join(sf_long, tops_df, by=c("variable", "toffset", "date"))

# extract sites
sites <- unique(sf_long$variable)



#---- Plot with minima and maxima ----------------------------------------------------------####


# plot each time series
ggplot(sf_long, aes(date)) + 
  geom_point(aes(y=value), colour="black") + 
  geom_line(aes(y=value), colour="black") + 
  geom_point(aes(y=minima), colour="red") + 
  geom_point(aes(y=maxima), colour="red") + 
  facet_wrap(~variable, scales="free_y")





#---- Create data frame of just minima and maxima ----------------------------------------------------------####


# filter to only keep minima and maxima
sf_min_max <- sf_long %>% 
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
site_id <- paste0("s", c(1:length(sites)))
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


