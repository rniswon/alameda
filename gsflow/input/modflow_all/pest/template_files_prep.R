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
setwd("C:/pestPrep/gsflow/input/modflow_all/pest/")






####----------------------------------- READ IN -----------------------------------####


# read in layer K pilot point 
pp <- list()
pp[[1]] <- read.table("Lay_1_K_PP_List.txt", header = FALSE)
pp[[2]] <- read.table("Lay_2_K_PP_List.txt", header = FALSE)
pp[[3]] <- read.table("Lay_3_K_PP_List.txt", header = FALSE)
pp[[4]] <- read.table("Lay_4_K_PP_List.txt", header = FALSE)





####----------------------------------- CALCULATE -----------------------------------####


# create output file names
fileNames <- c("Lay_1_K_PP_List.txt.tpl",
               "Lay_2_K_PP_List.txt.tpl",
               "Lay_3_K_PP_List.txt.tpl",
               "Lay_4_K_PP_List.txt.tpl")


ppOut = list()
for (i in 1:length(pp)){
  
  # extract data frame
  df <- pp[[i]]
  
  # create @text        @ column
  df$elevInsert <- paste0('@', df[,1], '               @')
  
  # place in output list
  ppOut[[i]] <- df
  
  # export
  write.table(df, file = fileNames[i], row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE)
  
}





