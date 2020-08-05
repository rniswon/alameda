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




#---- set constants -------------------------------------------####

# general
num_row <- 771
num_col <- 702


#---- read in --------------------------------------------------####

# read in HRU params dataset with updated bottom of layer 2
alam_df <- read.csv("./data_prep/create_bottom_of_layer2/alam_df_sp_updated_lyr2_elev.txt", sep=",")



#---- reformat -------------------------------------------------####

# remove all iseg > 955 because those are HRU repeats 
# sort by HRU_ID
# set any 0 values to -9999
alam_df <- alam_df %>%
  dplyr::filter(., iseg <=955) %>%
  dplyr::arrange(., HRU_ID) %>%
  mutate(., dsbl02_new = case_when(dsbl02_new == 0 ~ -9999,
                                   dsbl02_new > 0 ~ dsbl02_new))

# extract updated bottom of layer 2
elev_lyr2 <- round(alam_df$dsbl02_new, digits=2)
elev_lyr2 <- matrix(elev_lyr2, nrow = num_row, ncol = num_col, byrow=TRUE)




#---- export -------------------------------------------------####

write.table(elev_lyr2, "./data_prep/create_bottom_of_layer2/bottom_lyr_02_elev_updated.txt", 
            row.names=FALSE, col.names=FALSE)







