#---- Goal -------------------------------------------------------------------####

# The purpose of this script is to read in datasets of streamflow, groundwater heads, and 
# lake stages that have the pest id values and create .ins files





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
sf <- read.table("./modflow_files/pst_control_file_obs/streamflow_obs_for_pst.txt", 
                      header=FALSE, na.strings = "-999")


# read in groundwater data
gw <- read.table("./modflow_files/pst_control_file_obs/groundwater_obs_for_pst.txt", 
                      header=FALSE, na.strings = "-999")

# read in lake stage data
lake <- read.table("./modflow_files/pst_control_file_obs/lake_stage_obs_for_pst.txt", 
               header=FALSE, na.strings = "-999")





#---- Write function to do the reformatting ------------------------------------------------------------------####


create_pest_ins_file <- function(df, line_loc, second_row, idx=NULL){
  
  # extract observation ids
  if (!is.null(idx)){
    obs_id <- df$V1[idx]
  }else{
    obs_id <- df$V1
  }
  
  # add additional values to site ids
  obs_id <- paste0("l1     [", obs_id, "]", line_loc)
  
  # add first two rows
  obs_id <- c("pif @", second_row, obs_id)
  
  # return
  return(obs_id)
  
}




#---- Apply function and export ------------------------------------------------------------------####


# apply to groundwater
gw_ins <- create_pest_ins_file(gw, "1:21", "@NAME@")
write.table(gw_ins, file="./modflow_files/ins_files/gw_transient.txt", row.names = FALSE, col.names=FALSE, quote=FALSE)




# loop through streamflow 
sf_id <- paste0("s", 1:12)
sf_names <- paste0("streamflow_", c("IndianCreek", "SanAntonioCreekAtIndianCreekRd", "ArroyoHondo", 
                                    "SanAntonioCreek", "CalaverasCreek", "AlamedaCreekAboveACDD", 
                                    "AlamedaCreekBelowACDD", "AlamedaCreekBelowCalaverasCreek",
                                    "AlamedaCreekBelowWelchCreek", "AlamedaCreekNearNiles", 
                                    "AlamedaCreekAboveSanAntonioCreek", "AlamedaCreekAboveArroyoDeLaLaguna"), 
                   ".out.ins")
sf_second_row <- "@Midpt_Flow@"
sf_line_loc <- "69:84"
sf_list <- list()
for (i in 1:length(sf_id)){
  
  # grab indices for this streamflow gauge
  sf_idx <- grep(pattern = paste0(sf_id[i], "_"), x = sf$V1, value=FALSE)
  
  # create pest ins file
  sf_list[[i]] <- create_pest_ins_file(sf, sf_line_loc, sf_second_row, sf_idx)
  
  # export files
  write.table(sf_list[[i]], file=paste0("./modflow_files/ins_files/streamflow_transient/", sf_names[i]), 
              row.names = FALSE, col.names=FALSE, quote=FALSE)
  
  
}




# loop through lakes
lake_id <- c("lk_01", "lk_02", "lk_03", "lk_04", "lk_05", "lk_06", "lk_07", "lk_08", "lk_09", "lk_10", "lk_11", "lk_12")
lake_names <- paste0(c("ACDD_Reservoir", "No_Name_Pond", "Pond_F6", "Ready_Mix_Pond",
                       "Pond_F5", "Pond_F4", "Pond_F3W", "Pond_F3E", "Pond_F2", "Pond_SMP_32", 
                       "San_Antonio_Reservoir", "Calaveras_Reservoir"), ".out.ins")
lake_second_row <- "@Stage(H)@"
lake_line_loc <- "22:35"
lake_list <- list()
for (i in 1:length(lake_id)){
 
 # grab indices for this lake 
 lake_idx <- grep(pattern = paste0(lake_id[i], "_"), x = lake$V1, value=FALSE)
  
 # create pest ins file
 lake_list[[i]] <- create_pest_ins_file(lake, lake_line_loc, lake_second_row, lake_idx)
 
 # export files
 write.table(lake_list[[i]], file=paste0("./modflow_files/ins_files/lake_transient/", lake_names[i]), 
             row.names = FALSE, col.names=FALSE, quote=FALSE)
  
}






