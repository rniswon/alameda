####----------------------------------- SET UP -----------------------------------####

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
setwd("C:/gsflow_lowerGSFLOWupperPRMS/")





####----------------------------------- CREATE VECTORS -----------------------------------####

# number of HRUs
nhru <- 541242

# create vectors of values
Kh_lay1 <- rep(32.8, nhru)
Kh_lay2 <- rep(24.8, nhru)
Kh_lay3 <- rep(0.4, nhru)
Kh_lay4 <- rep(0.001, nhru)
SY_lay1 <- rep(0.18, nhru)
SY_lay2 <- rep(0.1, nhru)
SY_lay3 <- rep(0.005, nhru)
SY_lay4 <- rep(0.005, nhru)
thti <- rep(0.07, nhru)
pET <- rep(0.006, nhru)

# create list
paramList <- list(Kh_lay1, Kh_lay2, Kh_lay3, Kh_lay4, SY_lay1, SY_lay2, SY_lay3, SY_lay4, thti, pET)

# param names
paramNames <- c("Kh_lay_1.txt", "Kh_lay_2.txt", "Kh_lay_3.txt", "Kh_lay_4.txt", 
                "SY_lay_1.txt", "SY_lay_2.txt", "SY_lay_3.txt", "SY_lay_4.txt",
                "thti.txt", "pET.txt")




####----------------------------------- EXPORT UPDATED MODFLOW INPUT FILES -----------------------------------####


# reformat dis files and export
numRow <- 771
paramMat <- list()
for (i in 1:length(paramList)){
  
  # convert to matrix
  paramMat[[i]] <- matrix(paramList[[i]], nrow=numRow, byrow=TRUE)
  
  # export
  write.table(paramMat[[i]], file = paste0("./create_parameter_arrays/", paramNames[[i]]), sep= " ", 
              row.names=FALSE, col.names = FALSE)
  
}


