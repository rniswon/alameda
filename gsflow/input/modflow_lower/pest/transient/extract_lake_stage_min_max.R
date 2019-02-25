#---- Goal -------------------------------------------------------------------####

# The purpose of this script is to extract the min and max values from the lake 
# stage data and the reformat them for the pest control file.





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


# read in lake stage data
lake_stage <- read.csv("./observational_data/lakeStageAllWideCut.csv", header=TRUE, na.strings = "-999")




#---- Reformat ------------------------------------------------------------------####


# create date column
lake_stage$date <- ymd(lake_stage$ymd)

# add column with number of days since the start of the modeling time period
model_start_date <- ymd("2008-10-01") # change this once done with calibration and running gsflow to 10/1/1995
model_end_date <- ymd("2014-09-30")

# cut down to start and end dates (but exclude the actual start date)
lake_stage <- lake_stage %>% 
  filter(., lake_stage$date > model_start_date & lake_stage$date <= model_end_date)

# create long version
lake_stage <- lake_stage %>% gather(., key="variable", value="value", -date, -ymd)


# create table of lake names and ids
lake_name <- c("acdd_reservoir", "no_name_pond", "pond_f6", "ready_mix_pond", "pond_f5", "pond_f4", "pond_f3w", 
               "pond_f3e", "pond_f2", "pond_smp32", "san_antonio_reservoir", "calaveras_reservoir")
lake_id <- c("lk_01", "lk_02", "lk_03", "lk_04", "lk_05", "lk_06", "lk_07", "lk_08", "lk_09", "lk_10", "lk_11", "lk_12")


# add lake id column
lake_stage$lake_id <- "NA"
for (i in 1:length(lake_name)){
  
  idx <- which(lake_stage$variable %in% lake_name[i])
  lake_stage$lake_id[idx] <- lake_id[i]
  
}







#---- Plot ----------------------------------------------------------------------------------####


# plot each time series
ggplot(lake_stage, aes(date, value)) + 
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
bottoms <- sapply(n_min, function(x) inflect(lake_stage$value, threshold = x)$minima)
tops <- sapply(n_max, function(x) inflect(lake_stage$value, threshold = x)$maxima)

# create separate data frame for bottoms and tops
bottoms_df <- lake_stage[bottoms, ]
tops_df <- lake_stage[tops, ]

# call the minima and maxima as such
bottoms_df <- rename(bottoms_df, minima = value)
tops_df <- rename(tops_df, maxima = value)

# join with sf_long by site and date
lake_stage <- full_join(lake_stage, bottoms_df, by=c("variable", "date", "ymd", "lake_id"))
lake_stage <- full_join(lake_stage, tops_df, by=c("variable", "date", "ymd", "lake_id"))

# extract sites
sites <- unique(lake_stage$variable)






#---- Plot with minima and maxima ----------------------------------------------------------####


# plot each time series
ggplot(lake_stage, aes(date)) + 
  geom_point(aes(y=value), colour="black") + 
  geom_line(aes(y=value), colour="black") + 
  geom_point(aes(y=minima), colour="red") + 
  geom_point(aes(y=maxima), colour="red") + 
  facet_wrap(~variable, scales="free_y")





#---- Create data frame of just minima and maxima ----------------------------------------------------------####


# filter to only keep minima and maxima
lake_stage <- lake_stage %>% 
  dplyr::filter(., !is.na(minima) | !(is.na(maxima)))

# remove minima and maxima columns
lake_stage <- lake_stage %>% 
  dplyr::select(-minima, -maxima)






#---- Prep for pest control file export ----------------------------------------------------------####

# create obsnme, weight, and obsgnme columns
# select columns for export
lake_stage <- lake_stage %>%
  dplyr::mutate(., obsnme = paste0(lake_id, "_", ymd),
                weight = 0,
                obsgnme = "Lake_Obs") %>%
  select(., obsnme, value, weight, obsgnme)




#---- Export for pest control file ----------------------------------------------------------####


write.table(lake_stage, file = "./modflow_files/pst_control_file_obs/lake_stage_obs_for_pst.txt", 
            row.names = FALSE, col.names=FALSE, quote=FALSE)


