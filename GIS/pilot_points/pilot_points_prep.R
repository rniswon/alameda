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
setwd("C:/pestPrep/GIS/pilot_points/")






####----------------------------------- READ IN -----------------------------------####


# read in pilot points data
pp <- read.csv(file = "pilot_points_join.csv")


# read in surfK data
surfK <- read.csv(file = "surfK_zones.csv", na.strings = -999, header=FALSE)



####----------------------------------- REFORMAT -----------------------------------####

# convert surfK to column
surfK_col <- as.vector(t(surfK))

# convert to df
surfK_df <- data.frame(hru_id = c(1:541242), surfK = surfK_col)

# join by hru_id
ppAll <- merge(pp, surfK_df, by.x = "HRU_ID", by.y = "hru_id")

# subset
ppAll_subset <- subset(ppAll, subset = site != " ")

# sort by pilot point number
ppFinal <- ppAll_subset[order(ppAll_subset$Id),]




####----------------------------------- EXPORT -----------------------------------####

write.csv(ppFinal, "pilot_point_zones.csv", row.names = FALSE)



