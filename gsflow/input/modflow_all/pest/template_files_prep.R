####----------------------------------- SET UP -----------------------------------####

# clear workspace
rm(list=ls())

# install packages
# install.packages("plyr")
# install.packages("tidyr")
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
library(tidyr)
#library(dplyr)
library(ggplot2)
library(reshape2)
library(stringr)
#library(plotly)
#library(entropy)
#library(devtools)
#library(leaflet)
library(zoo)
#library(ggplus)
library(scales)
#library(rstudioapi)


# set working directory 
setwd("C:/Users/saalem.adera.GEOG-LARSEN-WIN/Google Drive/PEST_prep/gis/stream_network_and_zones/")






####----------------------------------- READ IN -----------------------------------####


# read in stream zones
zones <- read.csv(file="stream_zones.csv")

# read in sfr dataset 2
sfr <- read.csv(file="sfr_dataset2.csv")





####----------------------------------- CALCULATE -----------------------------------####


numZones <- 30
for (i in 1:numZones){
  
  # identify indices for each zone 
  idx <- which(zones$strmZone == i)
  
  # create STRHC1
  sfr$STRHC1[idx] <- paste0('@strmBdK_', i, '               @')
  
}





####----------------------------------- EXPORT -----------------------------------####

write.csv(sfr, file = "sfr_dataset2_pest.csv", row.names = FALSE)



