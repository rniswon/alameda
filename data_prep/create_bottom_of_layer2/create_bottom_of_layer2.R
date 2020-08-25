#---- goal -----------------------------------------------####

# To create a dis file for the bottom of layer 2 from 
# the text file exported from ArcGIS with updated 
# bottom of layer 2 values




#---- set up ----------------------------------------------####

# clear workspace
rm(list=ls())

# install packages
# install.packages("tidyverse")
# install.packages("plyr")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("reshape2")
# install.packages("stringr")
# install.packages("plotly")
# install.packages("shiny", type="binary")
# install.packages("rgdal")
# install.packages("sp")


# load libraries
library(plyr)
library(tidyverse)
#library(dplyr)
#library(ggplot2)
library(reshape2)
library(stringr)
#library(plotly)
#library(shiny)
library(rgdal)
library(sp)


# set working directory 
#setwd("C:/workspace/troubleshooting_pest/check_009/experiment")
setwd("C:/git_repos/alameda/pestPrep")




#---- set constants -----------------------------------------------------------####

# general
num_row <- 771
num_col <- 702


#---- read in ----------------------------------------------------------------####

# read in HRU params dataset with updated bottom of layer 2
alam_df <- read.csv("./GIS/updating_lyr2/alam_df_sp_updated_lyr2_elev1.txt", sep=",")


# read in assigned interpolation point values
interp_df <- read.csv("./GIS/updating_lyr2/points_interpolate_from_nof5_addpts.txt", sep=",")




#---- reformat -----------------------------------------------------------------####

# remove all iseg > 955 because those are HRU repeats 
# sort by HRU_ID
# set any 0 values to -9999
alam_df <- alam_df %>%
  dplyr::filter(., iseg <=955) %>%
  dplyr::arrange(., HRU_ID) %>%
  mutate(., dsbl02_lk = case_when(dsbl02_lk == 0 ~ -9999,
                                   dsbl02_lk > 0 ~ dsbl02_lk))

# extract updated bottom of layer 2
elev_lyr2 <- round(alam_df$dsbl02_lk, digits=2)
elev_lyr2 <- matrix(elev_lyr2, nrow = num_row, ncol = num_col, byrow=TRUE)




#---- export -------------------------------------------------------------------####

write.table(elev_lyr2, "./GIS/updating_lyr2/bottom_lyr_02_elev_updated1.txt", 
            row.names=FALSE, col.names=FALSE)




#---- extract lake and groundwater well grid cells -----------------------------####

# filter and select
alam_df_subset <- alam_df %>%
  dplyr::filter(., lk_l_02 %in% c(2:10) | gw_well > 0) %>%
  dplyr::select(., HRU_ID, lk_l_02, gw_well, ds___02, dsbl02_lk)

# join with interpolation points
alam_df_subset <- left_join(alam_df_subset, interp_df, by="HRU_ID")

# select
alam_df_subset <- alam_df_subset %>%
  dplyr::select(., -FID_, -ORIG_FID) %>%
  dplyr::rename(., layer_02_elev_assigned = lyr2_elev)

# set names
names(alam_df_subset) <- c("hru_id", "layer_02_lake_id", "groundwater_well", "layer_02_elev_original", 
                           "layer_02_elev_interpolated", "id", "layer_02_elev_assigned")

# order
alam_df_subset <- alam_df_subset %>%
  dplyr::arrange(., layer_02_lake_id)

# export
write.csv(alam_df_subset, "./GIS/updating_lyr2/bottom_lyr_02_elev_updated1_subset.csv", 
            row.names=FALSE)



# #---- set lakes to interpolated values -----------------------------####
# 
# 
# alam_df_subset <- alam_df %>%
#   dplyr::filter(., lk_l_02 %in% c(2:9) | gw_well > 0) %>%
#   mutate(., dsbl02_lk = case_when(lk_l_01!= 0 ~ GRID_CODE,
#                                    lk_l_01 == 0 ~ dsbl02_lk)) %>%
#   dplyr::select(., HRU_ID, lk_l_02, gw_well, ds___02, dsbl02_lk)
# 
# names(alam_df_subset) <- c("hru_id", "layer_02_lake_id", "groundwater_well", "layer_02_elev_original", 
#                            "layer_02_elev_interpolated")
# 
# alam_df_subset <- alam_df_subset %>%
#   dplyr::arrange(., layer_02_lake_id)
# 
# write.csv(alam_df_subset, "./GIS/updating_lyr2/bottom_lyr_02_elev_updated1_subset.csv", 
#           row.names=FALSE)



