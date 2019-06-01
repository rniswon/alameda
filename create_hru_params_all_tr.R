####--------------------------- goal -------------------------####

# To create a data frame that contains all modflow input data sorted by hru ID.
# The data can then be easily used for plotting - either in R or in ArcGIS.

####--------------------------- notes -------------------------####

# Need to remove all comments from datasets 2, 4b, and 4c in sfr 
# file in order for this code to work properly - alternatively could 
# use regular expressions to extract all comments following !

# should set stringsAsFactors=FALSE when reading in all data


####--------------------------- set up -------------------------####


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





####--------------------------- read in -------------------------####


# read in bas file
bas <- list()
bas[[1]] <- read.table("./gsflow/input/modflow_lower/bas_support/ibnd_1.txt", sep=" ")
bas[[2]] <- read.table("./gsflow/input/modflow_lower/bas_support/ibnd_2.txt", sep=" ")
bas[[3]] <- read.table("./gsflow/input/modflow_lower/bas_support/ibnd_3.txt", sep=" ")
bas[[4]] <- read.table("./gsflow/input/modflow_lower/bas_support/ibnd_4.txt", sep=" ")


# read in starting heads
strt_hd <- list()
strt_hd[[1]] <- read.table("./gsflow/input/modflow_lower/bas_support/strt_hd_1.txt", sep=" ", fill=TRUE)
strt_hd[[2]] <- read.table("./gsflow/input/modflow_lower/bas_support/strt_hd_2.txt", sep=" ", fill=TRUE)
strt_hd[[3]] <- read.table("./gsflow/input/modflow_lower/bas_support/strt_hd_3.txt", sep=" ", fill=TRUE)
strt_hd[[4]] <- read.table("./gsflow/input/modflow_lower/bas_support/strt_hd_4.txt", sep=" ", fill=TRUE)
strt_hd <- lapply(strt_hd, function(x) x[-772, -703])  # remove extra row and column 


# read in dis file
dis <- readLines("./gsflow/input/modflow_lower/alameda_tr.dis")


# read in .hed file
hed <- read.table("./gsflow/output/modflow/alameda.hed")


# read in sfr file
sfr <- readLines("./gsflow/input/modflow_lower/alameda_tr.sfr")


# read in lake position arrays 
lak_pos <- list()
lak_pos[[1]] <- read.table("./gsflow/input/modflow_lower/lak_support/LAKARR_1.txt")
lak_pos[[2]] <- read.table("./gsflow/input/modflow_lower/lak_support/LAKARR_2.txt")
lak_pos[[3]] <- read.table("./gsflow/input/modflow_lower/lak_support/LAKARR_3.txt")
lak_pos[[4]] <- read.table("./gsflow/input/modflow_lower/lak_support/LAKARR_4.txt")


# read in lakebed leakance arrays 
lkbd_lknc <- list()
lkbd_lknc[[1]] <- read.table("./gsflow/input/modflow_lower/lak_support/lkbdlknc_lay_1.txt")
lkbd_lknc[[2]] <- read.table("./gsflow/input/modflow_lower/lak_support/lkbdlknc_lay_2.txt")
lkbd_lknc[[3]] <- read.table("./gsflow/input/modflow_lower/lak_support/lkbdlknc_lay_3.txt")
lkbd_lknc[[4]] <- read.table("./gsflow/input/modflow_lower/lak_support/lkbdlknc_lay_4.txt")


# read in uzf file parameters
uzfbnd <- read.table("./gsflow/input/modflow_lower/uzf_support/iuzfbnd.txt")
irunbnd <- read.table("./gsflow/input/modflow_lower/uzf_support/irunbnd_lower.txt")
vks <- read.table("./gsflow/input/modflow_lower/uzf_support/vks.txt")
surfk <- read.table("./gsflow/input/modflow_lower/uzf_support/surfk.txt")
adjusted_finf <- read.table("./gsflow/input/modflow_lower/uzf_support/adjusted_finf.txt")
adjusted_pet <- read.table("./gsflow/input/modflow_lower/uzf_support/adjusted_pET.txt")
extdp <- read.table("./gsflow/input/modflow_lower/uzf_support/extdp.txt")
uzf <- list(uzfbnd, irunbnd, vks, surfk, adjusted_finf, adjusted_pet, extdp)


# read in upw file parameters
kh <- list()
kh[[1]] <- read.table("./gsflow/input/modflow_lower/upw_support/Kh_lay_1.txt")
kh[[2]] <- read.table("./gsflow/input/modflow_lower/upw_support/Kh_lay_2.txt")
kh[[3]] <- read.table("./gsflow/input/modflow_lower/upw_support/Kh_lay_3.txt")
kh[[4]] <- read.table("./gsflow/input/modflow_lower/upw_support/Kh_lay_4.txt")

sy <- list()
sy[[1]] <- read.table("./gsflow/input/modflow_lower/upw_support/SY_lay_1.txt")
sy[[2]] <- read.table("./gsflow/input/modflow_lower/upw_support/SY_lay_2.txt")
sy[[3]] <- read.table("./gsflow/input/modflow_lower/upw_support/SY_lay_3.txt")
sy[[4]] <- read.table("./gsflow/input/modflow_lower/upw_support/SY_lay_4.txt")


# read in .gag file parameters - streamflow gauges
gag <- readLines("./gsflow/input/modflow_lower/alameda.gag")
gag <- gag[2:14]


# read in .hob file - groundwater wells
hob <- read.table("./gsflow/input/modflow_lower/alameda_tr.hob", skip=2, sep=" ")
hob <- separate(hob, col=1, into=c("col1", "col2"))


# read in subbasin and hru_id values
subbasin <- read.table("./GIS/subbasins/hru_params_subbasin.txt", sep=",", header=TRUE)
subbasin <- subbasin[,c(2:3)]


# read in hru_params_all shapefile
hru_params_all_hru_id <- readOGR(dsn = "./GIS", layer = "hru_params_all_HRU_ID")




####--------------------------- set constants -------------------------####

# general
num_hru <- 541242
num_row <- 771
num_col <- 702

# for sfr file
start_dataset_02 <- 6
end_dataset_02 <- 10563
start_dataset_04bc <- 10565
end_dataset_04bc <- 13429





####--------------------------- create hru_id, hru_row, and hru_col -------------------------####

# create hru_id
hru_id <- c(1:num_hru)

# create hru_row
hru_row <- rep(1:num_row, each=num_col)

# create hru_col
hru_col <- rep(1:num_col, num_row)

# place in a data frame
id_df <- data.frame(hru_id = hru_id,
                 hru_row = hru_row,
                 hru_col = hru_col)




####--------------------------- reformat bas -------------------------####

bas <- lapply(bas, function(x) as.vector(t(x)))

bas <- data.frame(bas_lyr_01 = bas[[1]], 
                  bas_lyr_02 = bas[[2]],
                  bas_lyr_03 = bas[[3]],
                  bas_lyr_04 = bas[[4]])

#bas <- cbind(id_df, bas)




####--------------------------- reformat strt_hd -------------------------####


strt_hd <- lapply(strt_hd, function(x) as.vector(t(x)))

strt_hd <- data.frame(strt_hd_lyr_01 = strt_hd[[1]], 
                      strt_hd_lyr_02 = strt_hd[[2]],
                      strt_hd_lyr_03 = strt_hd[[3]],
                      strt_hd_lyr_04 = strt_hd[[4]])

#strt_hd <- cbind(id_df, strt_hd)




####--------------------------- reformat dis -------------------------####

# find indices of first row of each array
idx_top_lyr_01 <- grep("TOP ELEVATION OF LAYER 1", dis) + 1
idx_bttm_lyr_01 <- grep("BOTTOM ELEVATION OF LAYER 1", dis) + 1
idx_bttm_lyr_02 <- grep("BOTTOM ELEVATION OF LAYER 2", dis) + 1
idx_bttm_lyr_03 <- grep("BOTTOM ELEVATION OF LAYER 3", dis) + 1
idx_bttm_lyr_04 <- grep("BOTTOM ELEVATION OF LAYER 4", dis) + 1

# extract each array from dis
dis_list <- list()
dis_list[[1]] <- dis[idx_top_lyr_01: (idx_top_lyr_01 + num_row - 1)]
dis_list[[2]] <- dis[idx_bttm_lyr_01: (idx_bttm_lyr_01 + num_row - 1)]
dis_list[[3]] <- dis[idx_bttm_lyr_02: (idx_bttm_lyr_02 + num_row - 1)]
dis_list[[4]] <- dis[idx_bttm_lyr_03: (idx_bttm_lyr_03 + num_row - 1)]
dis_list[[5]] <- dis[idx_bttm_lyr_04: (idx_bttm_lyr_04 + num_row - 1)]

# convert char vectors into numeric arrays
dis_list_arr <- lapply(dis_list, function(x) read.table(text=x, sep=" "))


# convert arrays into vectors
dis <- lapply(dis_list_arr, function(x) as.vector(t(x)))

# place in data frame
dis <- data.frame(dis_top_lyr_01 = dis[[1]],
                  dis_bttm_lyr_01 = dis[[2]],
                  dis_bttm_lyr_02 = dis[[3]],
                  dis_bttm_lyr_03 = dis[[4]],
                  dis_bttm_lyr_04 = dis[[5]])

# bind with id data
#dis <- cbind(id_df, dis)



####--------------------------- reformat hed -------------------------####

# extract hed arrays
hed_list <- list()
hed_list[[1]] <- hed[1:num_row, ]
hed_list[[2]] <- hed[(num_row + 1) : (num_row * 2), ]
hed_list[[3]] <- hed[((num_row*2) + 1) : (num_row * 3), ]
hed_list[[4]] <- hed[((num_row*3) + 1) : (num_row * 4), ]


# convert arrays into vectors
hed <- lapply(hed_list, function(x) as.vector(t(x)))

# place in data frame
hed <- data.frame(hed_lyr_01 = hed[[1]],
                  hed_lyr_02 = hed[[2]],
                  hed_lyr_03 = hed[[3]],
                  hed_lyr_04 = hed[[4]])

# bind with id data
#hed <- cbind(id_df, hed)



####--------------------------- reformat sfr -------------------------####

# extract dataset 2 and datasets 4b and 4c
ds02 <- sfr[start_dataset_02 : end_dataset_02]
ds04bc <- sfr[start_dataset_04bc : end_dataset_04bc]

# identify and replace rows with values with ! 
idx <- grep(pattern = "!", x=ds02)
ds02[idx] <- gsub("!.*","",ds02[idx])
idx <- grep(pattern = "!", x=ds04bc)
ds04bc[idx] <- gsub("!.*","",ds04bc[idx])

# identify and replace rows with values with #
idx <- grep(pattern = "#", x=ds02)
ds02[idx] <- gsub("#.*","",ds02[idx])
idx <- grep(pattern = "#", x=ds04bc)
ds04bc[idx] <- gsub("#.*","",ds04bc[idx])

# convert dataset 2 to table 
ds02 <- as.data.frame(str_split_fixed(ds02, " ", 14), stringsAsFactors = FALSE)
ds02 <- as.data.frame(sapply(ds02, as.numeric), stringsAsFactors = FALSE)
names(ds02) <- c("krch", "irch", "jrch", "iseg", "ireach", "rchlen", "strtop", "slope", "strthick", 
                 "strhc1", "thts", "thti", "eps", "uhc")


# convert dataset 4b to table
ds04b <- ds04bc[seq(1, length(ds04bc), 3)]
ds04b <- as.data.frame(str_split_fixed(ds04b, " ", 9), stringsAsFactors = FALSE)
ds04b <- as.data.frame(sapply(ds04b, as.numeric), stringsAsFactors = FALSE)
names(ds04b) <- c("nseg", "icalc", "outseg", "iupseg", "flow", "runoff", "etsw", "pptsw", "roughch")


# convert dataset 4c (width1) to table
width1 <- as.numeric(ds04bc[seq(2, length(ds04bc), 3)])


# convert dataset 4c (width2) to table
width2 <- as.numeric(ds04bc[seq(3, length(ds04bc), 3)]) 


# combine all data dimensioned by nseg
nseg_data <- cbind(ds04b, width1, width2)

# create nreach_data - get all sfr data into data frame dimensioned by nreach
nreach_data <- full_join(ds02, nseg_data, by=c("iseg" = "nseg"))

# get all sfr data in data frame dimensioned by nhru
sfr_nhru <- full_join(id_df, nreach_data, by=c("hru_row" = "irch", "hru_col" = "jrch"))





####--------------------------- reformat lake position arrays -------------------------####


# convert arrays into vectors
lak_pos <- lapply(lak_pos, function(x) as.vector(t(x)))

# place in data frame
lak_pos <- data.frame(lak_lyr_01 = lak_pos[[1]],
                      lak_lyr_02 = lak_pos[[2]],
                      lak_lyr_03 = lak_pos[[3]],
                      lak_lyr_04 = lak_pos[[4]])



####--------------------------- reformat lakebed leakance arrays -------------------------####


# convert arrays into vectors
lkbd_lknc <- lapply(lkbd_lknc, function(x) as.vector(t(x)))

# place in data frame
lkbd_lknc <- data.frame(lkbd_lknc_01 = lkbd_lknc[[1]],
                        lkbd_lknc_02 = lkbd_lknc[[2]],
                        lkbd_lknc_03 = lkbd_lknc[[3]],
                        lkbd_lknc_04 = lkbd_lknc[[4]])




####--------------------------- reformat uzf arrays -------------------------####


# convert arrays into vectors
uzf <- lapply(uzf, function(x) as.vector(t(x)))

# place in data frame
uzf <- data.frame(uzfbnd = uzf[[1]],
                  irunbnd = uzf[[2]],
                  vks = uzf[[3]],
                  surfk = uzf[[4]],
                  adjusted_finf = uzf[[5]],
                  adjusted_pet = uzf[[6]],
                  extdp = uzf[[7]])




####--------------------------- reformat upw arrays -------------------------####


# convert arrays into vectors
kh <- lapply(kh, function(x) as.vector(t(x)))
sy <- lapply(sy, function(x) as.vector(t(x)))

# place in data frame
kh <- data.frame(kh_lay_01 = kh[[1]],
                 kh_lay_02 = kh[[2]],
                 kh_lay_03 = kh[[3]],
                 kh_lay_04 = kh[[4]])

sy <- data.frame(sy_lay_01 = sy[[1]],
                 sy_lay_02 = sy[[2]],
                 sy_lay_03 = sy[[3]],
                 sy_lay_04 = sy[[4]])









####--------------------------- reformat gag arrays -------------------------####


tmp <- as.data.frame(str_split_fixed(gag, " ", 5), stringsAsFactors = FALSE)
tmp2 <- as.data.frame(str_split_fixed(tmp$V4, "\t", 2), stringsAsFactors=FALSE)
gag <- cbind(tmp[,c(1:3)], tmp2[,1])
names(gag) <- c("gageseg", "gagerch", "unit", "outtype")
gag <- as.data.frame(sapply(gag, as.numeric))
gag <- data.frame(gag[,c(1:2)], stream_gauge = c(1:13))





####--------------------------- reformat hob arrays -------------------------####


hob_names <- c("gw_well", "date", "hobs_layer", "hobs_row", "hobs_column", "irefsp","toffset", "roff", "coff", "hobs")
names(hob) <- hob_names






####--------------------------- reformat subbasin arrays -------------------------####


# sort by hru_id
subbasin <- subbasin[order(subbasin$HRU_ID), ]







####--------------------------- place all data in one data frame -------------------------####


# need to include sfr data 
df <- cbind(id_df, subbasin, bas, dis, strt_hd, hed, lak_pos, lkbd_lknc, uzf, kh, sy)

# join with sfr data
df_w_sfr <- full_join(df, sfr_nhru, by=c("hru_id", "hru_row", "hru_col"))

# merge with .gag 
df_w_gag <- full_join(df_w_sfr, gag, by = c("iseg" = "gageseg", "ireach" = "gagerch"))


# # merge with .hob 
# df_w_hob <- full_join(df_w_gag, hob, by = c("hru_row" = "hobs_row", "hru_col" = "hobs_column"))
df_w_hob <- df_w_gag

# convert all -9999 or -999 to NA
set_na <- function(x, na_val){
  #idx_na <- x[x == na_val]
  idx_na <- which(x == na_val)
  x[idx_na] <- NA
  return(x)
}

alam_df <- as.data.frame(sapply(df_w_hob, set_na, -9999))
alam_df <- as.data.frame(sapply(alam_df, set_na, -999))


# add layer thickness columns
alam_df$thick_lay_01 <- alam_df$dis_top_lyr_01 - alam_df$dis_bttm_lyr_01
alam_df$thick_lay_02 <- alam_df$dis_bttm_lyr_01 - alam_df$dis_bttm_lyr_02
alam_df$thick_lay_03 <- alam_df$dis_bttm_lyr_02 - alam_df$dis_bttm_lyr_03
alam_df$thick_lay_04 <- alam_df$dis_bttm_lyr_03 - alam_df$dis_bttm_lyr_04






####--------------------------- join alam_df with spatial data -------------------------####

# merge
alam_df_sp <- merge(hru_params_all_hru_id, alam_df, by='HRU_ID')






####--------------------------- export alam_df_sp -------------------------####

# export alam_df as csv
write.csv(alam_df, file="./GIS/alam_df.csv", row.names=FALSE)

# export as shapefile
writeOGR(obj=alam_df_sp, dsn="./GIS", layer="alam_df_sp", driver="ESRI Shapefile", overwrite_layer = TRUE)








