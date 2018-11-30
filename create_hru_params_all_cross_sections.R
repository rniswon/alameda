####--------------------------- goal -------------------------####

# To create a data frame that contains all modflow input data sorted by hru ID.
# The data can then be easily used for plotting - either in R or in ArcGIS.

####--------------------------- notes -------------------------####

# Need to remove all comments from datasets 2, 4b, and 4c in sfr 
# file in order for this code to work properly


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
library(tidyverse)
library(plyr)
library(dplyr)
library(ggplot2)
library(reshape2)
library(stringr)
library(plotly)
library(shiny)
library(rgdal)
library(sp)


# set working directory 
setwd("C:/workspace/troubleshooting_pest/check_008/experiment")





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
dis <- readLines("./gsflow/input/modflow_lower/alameda.dis")


# read in .hed file
hed <- read.table("./gsflow/output/modflow/alameda.hed")


# read in sfr file
sfr <- readLines("./gsflow/input/modflow_lower/alameda.sfr")


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
irunbnd <- read.table("./gsflow/input/modflow_lower/uzf_support/irunbnd.txt")
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
hob <- read.table("./gsflow/input/modflow_lower/alameda.hob", skip=2, sep=" ")


# read in subbasin and hru_id values
subbasin <- read.table("./GIS/subbasins/hru_params_subbasin.txt", sep=",", header=TRUE)
subbasin <- subbasin[,c(2:3)]


# read in long profile hru ids
long_prof_hru <- read.csv("../stream_long_profile_hru.csv", header=TRUE)


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


hob_names <- c("gw_well", "hobs_layer", "hobs_row", "hobs_column", "irefsp","toffset", "roff", "coff", "hobs")
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


# merge with .hob 
df_w_hob <- full_join(df_w_gag, hob, by = c("hru_row" = "hobs_row", "hru_col" = "hobs_column"))


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

# export as shapefile
writeOGR(obj=alam_df_sp, dsn="./GIS", layer="alam_df_sp", driver="ESRI Shapefile")





####--------------------------- analyze grid cells near lakes -------------------------####


lw_lakes <- c(2:10)
num_bdry_cell <- 1
bdry_lake_lyr_01 <- list()
bdry_lake_lyr_02 <- list()
for (i in 1:length(lw_lakes)){
  
  # identify lake grid cells in each upper layer
  idx_lk_lyr_01 <- which(alam_df$lak_lyr_01 == lw_lakes[i])
  idx_lk_lyr_02 <- which(alam_df$lak_lyr_02 == lw_lakes[i])
  
  # get the hru_row and hru_col for the lake grid cells in each upper layer
  row_lyr_01 <- alam_df$hru_row[idx_lk_lyr_01]
  col_lyr_01 <- alam_df$hru_col[idx_lk_lyr_01]
  row_lyr_02 <- alam_df$hru_row[idx_lk_lyr_02]
  col_lyr_02 <- alam_df$hru_col[idx_lk_lyr_02]
  
  # look in all directions
  row_lyr_01_plus <- row_lyr_01 + num_bdry_cell
  row_lyr_01_minus <- row_lyr_01 - num_bdry_cell
  col_lyr_01_plus <- col_lyr_01 + num_bdry_cell
  col_lyr_01_minus <- col_lyr_01 - num_bdry_cell
  
  row_lyr_02_plus <- row_lyr_02 + num_bdry_cell
  row_lyr_02_minus <- row_lyr_02 - num_bdry_cell
  col_lyr_02_plus <- col_lyr_02 + num_bdry_cell
  col_lyr_02_minus <- col_lyr_02 - num_bdry_cell
  
  
  # get all possible boundary cells for layers 1 and 2
  idx_bdry_lyr_01_all <- c()
  idx_bdry_lyr_02_all <- c()
  for (j in 1:length(row_lyr_01)){
    
    
    #### layer 1 ####
    
    # row plus
    idx_possible_bdry_row_plus <- which(alam_df$hru_row == row_lyr_01_plus[j] & alam_df$hru_col == col_lyr_01[j])
    
    # row minus
    idx_possible_bdry_row_minus <- which(alam_df$hru_row == row_lyr_01_minus[j] & alam_df$hru_col == col_lyr_01[j])
    
    # col plus
    idx_possible_bdry_col_plus <- which(alam_df$hru_row == row_lyr_01[j] & alam_df$hru_col == col_lyr_01_plus[j])
    
    # col minus
    idx_possible_bdry_col_minus <- which(alam_df$hru_row == row_lyr_01[j] & alam_df$hru_col == col_lyr_01_minus[j])
    
    # store together
    idx_possible_bdry_lyr_01 <- c(idx_possible_bdry_row_plus, idx_possible_bdry_row_minus, 
                                  idx_possible_bdry_col_plus, idx_possible_bdry_col_minus)
    
    # identify non-lake grid cells
    idx_non_lake_lyr_01 <- which(alam_df$lak_lyr_01 == 0)
    
    # find the possible boundary grid cells that are also non-lake cells - so find the actual boundary cells
    idx_bdry_lyr_01 <- intersect(idx_possible_bdry_lyr_01, idx_non_lake_lyr_01)
    
    # store 
    idx_bdry_lyr_01_all <- c(idx_bdry_lyr_01_all, idx_bdry_lyr_01)
    
    
    
    
    
    #### layer 2 ####
    
    # row plus
    idx_possible_bdry_row_plus <- which(alam_df$hru_row == row_lyr_02_plus[j] & alam_df$hru_col == col_lyr_02[j])
    
    # row minus
    idx_possible_bdry_row_minus <- which(alam_df$hru_row == row_lyr_02_minus[j] & alam_df$hru_col == col_lyr_02[j])
    
    # col plus
    idx_possible_bdry_col_plus <- which(alam_df$hru_row == row_lyr_02[j] & alam_df$hru_col == col_lyr_02_plus[j])
    
    # col minus
    idx_possible_bdry_col_minus <- which(alam_df$hru_row == row_lyr_02[j] & alam_df$hru_col == col_lyr_02_minus[j])
    
    # store together
    idx_possible_bdry_lyr_02 <- c(idx_possible_bdry_row_plus, idx_possible_bdry_row_minus, 
                                  idx_possible_bdry_col_plus, idx_possible_bdry_col_minus)
    
    
    # identify non-lake grid cells
    idx_non_lake_lyr_02 <- which(alam_df$lak_lyr_02 == 0)
    
    # find the possible boundary grid cells that are also non-lake cells - so find the actual boundary cells
    idx_bdry_lyr_02 <- intersect(idx_possible_bdry_lyr_02, idx_non_lake_lyr_02)
    
    # store 
    idx_bdry_lyr_02_all <- c(idx_bdry_lyr_02_all, idx_bdry_lyr_02)
    
    
  }
  
  bdry_lake_lyr_01[[i]] <- idx_bdry_lyr_01_all
  bdry_lake_lyr_02[[i]] <- idx_bdry_lyr_02_all
  
  
}
bdry_lake <- list(bdry_lake_lyr_01, bdry_lake_lyr_02)



# check the layer 1 and 2 thicknesses of the lake boundary grid cells
bdry_thick_lyr_01 <- rep(list(list()), length(lw_lakes))
bdry_thick_lyr_02 <- rep(list(list()), length(lw_lakes))
bdry_thick <- list(bdry_thick_lyr_01, bdry_thick_lyr_02)
for (i in 1:length(bdry_lake)){
  
  for (j in 1:length(bdry_lake[[i]])){
    
    if (i==1){
      
      bdry_thick[[i]][[j]] <- alam_df$thick_lay_01[ bdry_lake[[i]][[j]] ]
      
    }else if(i==2){
      
      bdry_thick[[i]][[j]] <- alam_df$thick_lay_02[ bdry_lake[[i]][[j]] ]
      
    }
    
  }
}



# place in data frames to facilitate plotting
bdry_thick_lyr_01 <- rep(list(list()), length(lw_lakes))
bdry_thick_lyr_02 <- rep(list(list()), length(lw_lakes))
bdry_thick_df <- list(bdry_thick_lyr_01, bdry_thick_lyr_02)
lake_names <- c("lake_02", "lake_03", "lake_04", "lake_05", "lake_06", "lake_07", "lake_08",
                "lake_09", "lake_10")
for (i in 1:length(bdry_thick)){
  
  for (j in 1:length(bdry_thick[[i]])){
    
    lake <- rep(lake_names[j], length(bdry_thick[[i]][[j]]))
    thickness <- bdry_thick[[i]][[j]]
    df <- data.frame(lake = lake, thickness = thickness)
    bdry_thick_df[[i]][[j]] <- df
    
  }
}

# combine into one data frame for each layer
bdry_thick_lyr_01 <- rbindlist(bdry_thick_df[[1]])
bdry_thick_lyr_02 <- rbindlist(bdry_thick_df[[2]])

# make the lake column a factor
bdry_thick_lyr_01$lake <- as.factor(bdry_thick_lyr_01$lake)
bdry_thick_lyr_02$lake <- as.factor(bdry_thick_lyr_02$lake)

# plot layer 1
jpeg(filename="../lake_boundary_investigation/lake_boundary_thickness_lyr_01.jpg", width=12, height=8, units="in", quality=75, res=300)
print(
  ggplot(bdry_thick_lyr_01, aes(y=thickness, x=lake)) + 
    geom_point(position = position_jitter(width=0.1, height=0)) + 
    labs(title="Lake boundary cell thicknesses: layer 1", x="Lake", y="Thickness (ft.)")
)
dev.off()

# plot layer 2
jpeg(filename="../lake_boundary_investigation/lake_boundary_thickness_lyr_02.jpg", width=12, height=8, units="in", quality=75, res=300)
print(
  ggplot(bdry_thick_lyr_02, aes(y=thickness, x=lake)) + 
    geom_point(position = position_jitter(width=0.1, height=0)) + 
    labs(title="Lake boundary cell thicknesses: layer 2", x= "Lake", y="Thickness (ft.)")
)
dev.off()




# calculate the number of lake grid cells with 0 and non-zero boundary cell thicknesses 
thick_df_list <- list(list(), list())
for (i in 1:length(bdry_thick_df)){
  
  thick_df <- data.frame(lake = lake_names, num_boundary = NA, zero_thickness = NA, non_zero_thickness = NA, 
                         percent_zero_thickness=NA)
  
  for (j in 1:length(bdry_thick_df[[i]])){
    
    thick_df$num_boundary[j] <- nrow(bdry_thick_df[[i]][[j]])
    thick_df$zero_thickness[j] <- sum(bdry_thick_df[[i]][[j]]$thickness == 0)
    thick_df$non_zero_thickness[j] <- sum(bdry_thick_df[[i]][[j]]$thickness != 0)
    thick_df$percent_zero_thickness[j] <- (thick_df$zero_thickness[j] / thick_df$num_boundary[j]) * 100
    
  }
  
  thick_df_list[[i]] <- thick_df
}

# export tables
write.csv(thick_df_list[[1]], file="../lake_boundary_investigation/lake_bdry_thickness_layer_01.csv", 
          row.names=FALSE)
write.csv(thick_df_list[[2]], file="../lake_boundary_investigation/lake_bdry_thickness_layer_02.csv", 
          row.names=FALSE)










####--------------------------- plot subsurface layer elevations -------------------------####


# identify indices for all subbasins except 11 and 12 (want sunol valley) - want to keep 11 and 12
idx <- which(alam_df$subbasin %in% c(1:10))

# create list of layers to plot
dis_lyr <- list(alam_df$dis_top_lyr_01, alam_df$dis_bttm_lyr_01, alam_df$dis_bttm_lyr_02, 
                alam_df$dis_bttm_lyr_03, alam_df$dis_bttm_lyr_04)

# convert everything in idx to NA and then change to matrix
for (i in 1:length(dis_lyr)){
  
  dis_lyr[[i]][idx] <- NA
  
  dis_lyr[[i]] <- matrix(dis_lyr[[i]], nrow=771, ncol=702, byrow=TRUE)
  
}


# plot
plot_ly() %>%
  add_surface(z = ~dis_lyr[[1]]) %>%
  add_surface(z = ~dis_lyr[[2]]) %>%
  add_surface(z = ~dis_lyr[[3]]) %>%
  add_surface(z = ~dis_lyr[[4]]) %>%
  add_surface(z = ~dis_lyr[[5]])





####--------------------------- plot cross sections for groundwater wells -------------------------####


# create empty lists to store rows and columns for each groundwater well
row_xs <- list()
col_xs <- list()

# hru_row and hru_col for the groundwater well hrus
gw_wells <- c("mw01", "mw02", "mw03", "mw04", "mw05", "mw06", "mw07", "mw08", "mw09", "mw10", 
              "vcb3","vcb4", "vcb6")
gw_row <- c(213, 210, 203, 194, 186, 179, 170, 168, 167, 163, 240, 232, 227)
gw_col <- c(169, 166, 161, 159, 159, 152, 141, 141, 139, 133, 175, 173, 170)

# number of hrus on each half of cross-section
num_xs <- 30

# loop through groundwater wells
for (i in 1:length(gw_row)){
  
  
  #### row: all layers ####
  
  # extract row cross-section hrus
  row_xs[[i]] <- c( (gw_col[[i]] - num_xs) : (gw_col[[i]] + num_xs) )
    
  # subset by row cross-section hrus
  row_df <- subset(alam_df, subset = alam_df$hru_row == gw_row[i] & alam_df$hru_col %in% row_xs[[i]])
  
  # find groundwater well
  idx_well <- which(!(is.na(row_df$gw_well)))
  
  # find stream
  idx_stream <- which(!(is.na(row_df$iseg)))
  
  # find lake
  idx_lake <- which(row_df$lak_lyr_01 != 0)
  
  # find min and max elevations for row cross-section plot
  min_elev <- min(rbind(row_df$dis_top_lyr_01, row_df$dis_bttm_lyr_01, row_df$dis_bttm_lyr_02, 
                        row_df$dis_bttm_lyr_03, row_df$dis_bttm_lyr_04), na.rm=TRUE)
  max_elev <- max(rbind(row_df$dis_top_lyr_01 + 50, row_df$dis_bttm_lyr_01, row_df$dis_bttm_lyr_02, 
                        row_df$dis_bttm_lyr_03, row_df$dis_bttm_lyr_04), na.rm=TRUE)
  
  # plot row cross-section
  jpeg(filename=paste0("../xs_plots/row_xs_all_" , gw_wells[i], ".jpg"), width=12, height=8, units="in", quality=75, res=300)
  par(xpd = TRUE, mar = par()$mar + c(0,0,0,7))
  plot(row_df$hru_col, row_df$dis_bttm_lyr_04, type="l", col = "purple", lty=2, lwd=2, ylim=c(min_elev, max_elev), 
       main = paste0("Cross-section across row ", gw_row[i], ": ", gw_wells[i]), 
       ylab="Elevation (ft)", 
       xlab = "HRU column")
  lines(row_df$hru_col, row_df$dis_bttm_lyr_03, type="l", col="green", lty=2, lwd=2)
  lines(row_df$hru_col, row_df$dis_bttm_lyr_02, type="l", col= "blue", lty=2, lwd=2)
  lines(row_df$hru_col, row_df$dis_bttm_lyr_01, type="l", col="red", lty=2, lwd=2)
  lines(row_df$hru_col, row_df$dis_top_lyr_01, type="l", col= "black", lwd=4, lty=2)
  points(row_df$hru_col[idx_well], row_df$dis_top_lyr_01[idx_well] + 50, type="p", col = "burlywood4", pch = 1, 
         cex = 2)
  points(row_df$hru_col[idx_stream], row_df$dis_top_lyr_01[idx_stream] + 50, type="p", col = "dodgerblue4", pch = 0, 
         cex = 2)
  points(row_df$hru_col[idx_lake], row_df$dis_top_lyr_01[idx_lake] + 50, type="p", col = "lightseagreen", pch = 3, 
         cex = 2)
  legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
                                                  "gw well", "stream", "lake"),
         lty=c(2,2,2,2,2,NA,NA,NA), lwd=c(2,1,1,1,1,NA,NA,NA), pch=c(NA,NA,NA,NA,NA,1,0,3), pt.cex=2,
         col=c("black", "red", "blue", "green", "purple", "burlywood4", "dodgerblue4", "lightseagreen"), bty="n")
  par(xpd=FALSE)
  grid()
  par(mar=c(5, 4, 4, 2) + 0.1)
  dev.off()
  
  
  
  
  
  #### row: layers 1 and 2 ####
  
  # extract row cross-section hrus
  row_xs[[i]] <- c( (gw_col[[i]] - num_xs) : (gw_col[[i]] + num_xs) )
  
  # subset by row cross-section hrus
  row_df <- subset(alam_df, subset = alam_df$hru_row == gw_row[i] & alam_df$hru_col %in% row_xs[[i]])
  
  # find groundwater well
  idx_well <- which(!(is.na(row_df$gw_well)))
  
  # find stream
  idx_stream <- which(!(is.na(row_df$iseg)))
  
  # find lake
  idx_lake <- which(row_df$lak_lyr_01 != 0)
  
  # find min and max elevations for row cross-section plot
  min_elev <- min(rbind(row_df$dis_top_lyr_01, row_df$dis_bttm_lyr_01, row_df$dis_bttm_lyr_02), na.rm=TRUE)
  max_elev <- max(rbind(row_df$dis_top_lyr_01+50, row_df$dis_bttm_lyr_01, row_df$dis_bttm_lyr_02), na.rm=TRUE)
  
  # plot row cross-section
  jpeg(filename=paste0("../xs_plots/row_xs_upper_" , gw_wells[i], ".jpg"), width=12, height=8, units="in", quality=75, res=300)
  par(mar = par()$mar + c(0,0,0,7))
  plot(row_df$hru_col, row_df$dis_bttm_lyr_04, type="l", col = "purple", lty=2, lwd=2, ylim=c(min_elev, max_elev), 
       main = paste0("Cross-section across row ", gw_row[i], ": ", gw_wells[i]), 
       ylab="Elevation (ft)", 
       xlab = "HRU column")
  lines(row_df$hru_col, row_df$dis_bttm_lyr_03, type="l", col="green", lty=2, lwd=2)
  lines(row_df$hru_col, row_df$dis_bttm_lyr_02, type="l", col= "blue", lty=2, lwd=2)
  lines(row_df$hru_col, row_df$dis_bttm_lyr_01, type="l", col="red", lty=2, lwd=2)
  lines(row_df$hru_col, row_df$dis_top_lyr_01, type="l", col= "black", lwd=4, lty=2)
  lines(row_df$hru_col, row_df$hed_lyr_01, type="l", col="darkgoldenrod4", lwd=2, lty=2)
  lines(row_df$hru_col, row_df$hed_lyr_02, type="l", col="darkgoldenrod3", lwd=2, lty=2)
  lines(row_df$hru_col, row_df$hed_lyr_03, type="l", col="darkgoldenrod2", lwd=2, lty=2)
  lines(row_df$hru_col, row_df$hed_lyr_04, type="l", col="darkgoldenrod1", lwd=2, lty=2)
  points(row_df$hru_col[idx_well], row_df$dis_top_lyr_01[idx_well] + 50, type="p", col = "burlywood4", pch = 1, 
         cex = 2)
  points(row_df$hru_col[idx_stream], row_df$dis_top_lyr_01[idx_stream] + 50, type="p", col = "dodgerblue4", pch = 0, 
         cex = 2)
  points(row_df$hru_col[idx_lake], row_df$dis_top_lyr_01[idx_lake] + 50, type="p", col = "lightseagreen", pch = 3, 
         cex = 2)
  par(xpd=TRUE)
  legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
                                                  "gw head: layer 1", "gw head: layer 2", "gw head: layer 3", "gw head: layer 4", "gw well", "stream", "lake"),
         lty=c(2,2,2,2,2,2,2,2,2,NA,NA,NA), lwd=c(2,1,1,1,1,1,1,1,1,NA,NA,NA), pch=c(NA,NA,NA,NA,NA,NA,NA,NA,NA,1,0,3), pt.cex=2,
         col=c("black", "red", "blue", "green", "purple", "darkgoldenrod4","darkgoldenrod3", "darkgoldenrod2", "darkgoldenrod1",
               "burlywood4", "dodgerblue4", "lightseagreen"), bty="n")
  par(xpd=FALSE)
  grid()
  par(mar=c(5, 4, 4, 2) + 0.1)
  dev.off()
  
  
  
  
  
  #### column: all layers ####
  
  
  # extract column cross-section hrus
  col_xs[[i]] <- c( (gw_row[[i]] - num_xs) : (gw_row[[i]] + num_xs) )
  
  # subset by column cross-section hrus
  col_df <- subset(alam_df, subset = alam_df$hru_col == gw_col[i] & alam_df$hru_row %in% col_xs[[i]])
  
  # find groundwater well
  idx_well <- which(!(is.na(col_df$gw_well)))
  
  # find stream
  idx_stream <- which(!(is.na(col_df$iseg)))
  
  # find lake
  idx_lake <- which(col_df$lak_lyr_01 != 0)
  
  # find min and max elevations for column cross-section plot
  min_elev <- min(rbind(col_df$dis_top_lyr_01, col_df$dis_bttm_lyr_01, col_df$dis_bttm_lyr_02,
                        col_df$dis_bttm_lyr_03, col_df$dis_bttm_lyr_04), na.rm=TRUE)
  max_elev <- max(rbind(col_df$dis_top_lyr_01+50, col_df$dis_bttm_lyr_01, col_df$dis_bttm_lyr_02,
                        col_df$dis_bttm_lyr_03, col_df$dis_bttm_lyr_04), na.rm=TRUE)
  
  
  # plot column cross-sections
  jpeg(filename=paste0("../xs_plots/column_xs_all_" , gw_wells[i], ".jpg"), width=12, height=8, units="in", quality=75, res=300)
  par(mar = par()$mar + c(0,0,0,7))
  plot(col_df$hru_row, col_df$dis_bttm_lyr_04, type="l", col = "purple", lty=2, lwd=2, ylim=c(min_elev, max_elev), 
       main = paste0("Cross-section across column ", gw_col[i], ": ", gw_wells[i]), 
       ylab="Elevation (ft)", 
       xlab = "HRU row")
  lines(col_df$hru_row, col_df$dis_bttm_lyr_03, type="l", col="green", lty=2, lwd=2)
  lines(col_df$hru_row, col_df$dis_bttm_lyr_02, type="l", col= "blue", lty=2, lwd=2)
  lines(col_df$hru_row, col_df$dis_bttm_lyr_01, type="l", col="red", lty=2, lwd=2)
  lines(col_df$hru_row, col_df$dis_top_lyr_01, type="l", col= "black", lwd=4, lty=2)
  points(col_df$hru_row[idx_well], col_df$dis_top_lyr_01[idx_well] + 50, type="p", col = "burlywood4", pch = 1, 
         cex = 2)
  points(col_df$hru_row[idx_stream], col_df$dis_top_lyr_01[idx_stream] + 50, type="p", col = "dodgerblue4", pch = 0, 
         cex = 2)
  points(col_df$hru_row[idx_lake], col_df$dis_top_lyr_01[idx_lake] + 50, type="p", col = "lightseagreen", pch = 3, 
         cex = 2)
  par(xpd=TRUE)
  legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
                                                  "gw well", "stream", "lake"),
         lty=c(2,2,2,2,2,NA,NA,NA), lwd=c(2,1,1,1,1,NA,NA,NA), pch=c(NA,NA,NA,NA,NA,1,0,3), pt.cex=2,
         col=c("black", "red", "blue", "green", "purple", "burlywood4", "dodgerblue4", "lightseagreen"), bty="n")
  par(xpd=FALSE)
  grid()
  par(mar=c(5, 4, 4, 2) + 0.1)
  dev.off()
  
  
  
  
  
  
  #### column: layers and 1 and 2 ####

  # extract column cross-section hrus
  col_xs[[i]] <- c( (gw_row[[i]] - num_xs) : (gw_row[[i]] + num_xs) )

  # subset by column cross-section hrus
  col_df <- subset(alam_df, subset = alam_df$hru_col == gw_col[i] & alam_df$hru_row %in% col_xs[[i]])

  # find min and max elevations for column cross-section plot
  min_elev <- min(rbind(col_df$dis_top_lyr_01, col_df$dis_bttm_lyr_01, col_df$dis_bttm_lyr_02), na.rm=TRUE)
  max_elev <- max(rbind(col_df$dis_top_lyr_01+50, col_df$dis_bttm_lyr_01, col_df$dis_bttm_lyr_02), na.rm=TRUE)

  # plot column cross-sections
  jpeg(filename=paste0("../xs_plots/column_xs_upper_" , gw_wells[i], ".jpg"), width=12, height=8, units="in", quality=75, res=300)
  par(mar = par()$mar + c(0,0,0,7))
  plot(col_df$hru_row, col_df$dis_bttm_lyr_04, type="l", col = "purple", lty=2, lwd=2, ylim=c(min_elev, max_elev), 
       main = paste0("Cross-section across column ", gw_col[i], ": ", gw_wells[i]), 
       ylab="Elevation (ft)", 
       xlab = "HRU row")
  lines(col_df$hru_row, col_df$dis_bttm_lyr_03, type="l", col="green", lty=2, lwd=2)
  lines(col_df$hru_row, col_df$dis_bttm_lyr_02, type="l", col= "blue", lty=2, lwd=2)
  lines(col_df$hru_row, col_df$dis_bttm_lyr_01, type="l", col="red", lty=2, lwd=2)
  lines(col_df$hru_row, col_df$dis_top_lyr_01, type="l", col= "black", lwd=4, lty=2)
  lines(col_df$hru_row, col_df$hed_lyr_01, type="l", col="darkgoldenrod4", lwd=2, lty=2)
  lines(col_df$hru_row, col_df$hed_lyr_02, type="l", col="darkgoldenrod3", lwd=2, lty=2)
  lines(col_df$hru_row, col_df$hed_lyr_03, type="l", col="darkgoldenrod2", lwd=2, lty=2)
  lines(col_df$hru_row, col_df$hed_lyr_04, type="l", col="darkgoldenrod1", lwd=2, lty=2)
  points(col_df$hru_row[idx_well], col_df$dis_top_lyr_01[idx_well] + 50, type="p", col = "burlywood4", pch = 1, 
         cex = 2)
  points(col_df$hru_row[idx_stream], col_df$dis_top_lyr_01[idx_stream] + 50, type="p", col = "dodgerblue4", pch = 0, 
         cex = 2)
  points(col_df$hru_row[idx_lake], col_df$dis_top_lyr_01[idx_lake] + 50, type="p", col = "lightseagreen", pch = 3, 
         cex = 2)
  par(xpd=TRUE)
  legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
                                                  "gw head: layer 1", "gw head: layer 2", "gw head: layer 3", "gw head: layer 4", "gw well", "stream", "lake"),
         lty=c(2,2,2,2,2,2,2,2,2,NA,NA,NA), lwd=c(2,1,1,1,1,1,1,1,1,NA,NA,NA), pch=c(NA,NA,NA,NA,NA,NA,NA,NA,NA,1,0,3), pt.cex=2,
         col=c("black", "red", "blue", "green", "purple", "darkgoldenrod4","darkgoldenrod3", "darkgoldenrod2", "darkgoldenrod1",
               "burlywood4", "dodgerblue4", "lightseagreen"), bty="n")
  par(xpd=FALSE)
  grid()
  par(mar=c(5, 4, 4, 2) + 0.1)
  dev.off()

  
    
}











####--------------------------- plot cross sections for groundwater wells: zoomed in -------------------------####


# create empty lists to store rows and columns for each groundwater well
row_xs <- list()
col_xs <- list()

# hru_row and hru_col for the groundwater well hrus
gw_wells <- c("mw01", "mw02", "mw03", "mw04", "mw05", "mw06", "mw07", "mw08", "mw09", "mw10", 
              "vcb3","vcb4", "vcb6")
gw_row <- c(213, 210, 203, 194, 186, 179, 170, 168, 167, 163, 240, 232, 227)
gw_col <- c(169, 166, 161, 159, 159, 152, 141, 141, 139, 133, 175, 173, 170)

# number of hrus on each half of cross-section
num_xs <- 30

# loop through groundwater wells
for (i in 1:length(gw_row)){
  
  
  #### row: layers 1 and 2 ####
  
  # extract row cross-section hrus
  row_xs[[i]] <- c( (gw_col[[i]] - num_xs) : (gw_col[[i]] + num_xs) )
  
  # subset by row cross-section hrus
  row_df <- subset(alam_df, subset = alam_df$hru_row == gw_row[i] & alam_df$hru_col %in% row_xs[[i]])
  
  # find groundwater well
  idx_well <- which(!(is.na(row_df$gw_well)))
  
  # find stream
  idx_stream <- which(!(is.na(row_df$iseg)))
  
  # find lake
  idx_lake <- which(row_df$lak_lyr_01 != 0)
  
  # find min and max elevations for row cross-section plot
  min_elev <- c(200, 175, 100, 150, 200, 0, 175, 200, 175, 150, 300, 300, 300)
  max_elev <- c(400, 400, 350, 350, 400, 325, 300, 400, 350, 350, 600, 500, 500)
  
  # plot row cross-section
  jpeg(filename=paste0("../xs_plots/row_xs_upper_zoom_" , gw_wells[i], ".jpg"), width=12, height=8, units="in", quality=75, res=300)
  par(mar = par()$mar + c(0,0,0,7))
  plot(row_df$hru_col, row_df$dis_bttm_lyr_04, type="l", col = "purple", lty=2, lwd=2, ylim=c(min_elev[i], max_elev[i]), 
       main = paste0("Cross-section across row ", gw_row[i], ": ", gw_wells[i]), 
       ylab="Elevation (ft)", 
       xlab = "HRU column")
  lines(row_df$hru_col, row_df$dis_bttm_lyr_03, type="l", col="green", lty=2, lwd=2)
  lines(row_df$hru_col, row_df$dis_bttm_lyr_02, type="l", col= "blue", lty=2, lwd=2)
  lines(row_df$hru_col, row_df$dis_bttm_lyr_01, type="l", col="red", lty=2, lwd=2)
  lines(row_df$hru_col, row_df$dis_top_lyr_01, type="l", col= "black", lwd=4, lty=2)
  lines(row_df$hru_col, row_df$hed_lyr_01, type="l", col="darkgoldenrod4", lwd=2, lty=2)
  lines(row_df$hru_col, row_df$hed_lyr_02, type="l", col="darkgoldenrod3", lwd=2, lty=2)
  lines(row_df$hru_col, row_df$hed_lyr_03, type="l", col="darkgoldenrod2", lwd=2, lty=2)
  lines(row_df$hru_col, row_df$hed_lyr_04, type="l", col="darkgoldenrod1", lwd=2, lty=2)
  points(row_df$hru_col[idx_well], row_df$dis_top_lyr_01[idx_well] + 50, type="p", col = "burlywood4", pch = 1, 
         cex = 2)
  points(row_df$hru_col[idx_stream], row_df$dis_top_lyr_01[idx_stream] + 50, type="p", col = "dodgerblue4", pch = 0, 
         cex = 2)
  points(row_df$hru_col[idx_lake], row_df$dis_top_lyr_01[idx_lake] + 50, type="p", col = "lightseagreen", pch = 3, 
         cex = 2)
  par(xpd=TRUE)
  legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
                                                  "gw head: layer 1", "gw head: layer 2", "gw head: layer 3", "gw head: layer 4", "gw well", "stream", "lake"),
         lty=c(2,2,2,2,2,2,2,2,2,NA,NA,NA), lwd=c(2,1,1,1,1,1,1,1,1,NA,NA,NA), pch=c(NA,NA,NA,NA,NA,NA,NA,NA,NA,1,0,3), pt.cex=2,
         col=c("black", "red", "blue", "green", "purple", "darkgoldenrod4","darkgoldenrod3", "darkgoldenrod2", "darkgoldenrod1",
               "burlywood4", "dodgerblue4", "lightseagreen"), bty="n")
  par(xpd=FALSE)
  grid()
  par(mar=c(5, 4, 4, 2) + 0.1)
  dev.off()
  
  
  
  
  #### column: layers and 1 and 2 ####
  
  # extract column cross-section hrus
  col_xs[[i]] <- c( (gw_row[[i]] - num_xs) : (gw_row[[i]] + num_xs) )
  
  # subset by column cross-section hrus
  col_df <- subset(alam_df, subset = alam_df$hru_col == gw_col[i] & alam_df$hru_row %in% col_xs[[i]])
  
  # find min and max elevations for column cross-section plot
  min_elev <- c(100, 100, 100, 0, 0, 150, 150, 175, 175, 200, 300, 250, 100)
  max_elev <- c(400, 400, 400, 400, 400, 300, 300, 300, 300, 300, 500, 400, 400)
  
  # plot column cross-sections
  jpeg(filename=paste0("../xs_plots/column_xs_upper_zoom_" , gw_wells[i], ".jpg"), width=12, height=8, units="in", quality=75, res=300)
  par(mar = par()$mar + c(0,0,0,7))
  plot(col_df$hru_row, col_df$dis_bttm_lyr_04, type="l", col = "purple", lty=2, lwd=2, ylim=c(min_elev[i], max_elev[i]), 
       main = paste0("Cross-section across column ", gw_col[i], ": ", gw_wells[i]), 
       ylab="Elevation (ft)", 
       xlab = "HRU row")
  lines(col_df$hru_row, col_df$dis_bttm_lyr_03, type="l", col="green", lty=2, lwd=2)
  lines(col_df$hru_row, col_df$dis_bttm_lyr_02, type="l", col= "blue", lty=2, lwd=2)
  lines(col_df$hru_row, col_df$dis_bttm_lyr_01, type="l", col="red", lty=2, lwd=2)
  lines(col_df$hru_row, col_df$dis_top_lyr_01, type="l", col= "black", lwd=4, lty=2)
  lines(col_df$hru_row, col_df$hed_lyr_01, type="l", col="darkgoldenrod4", lwd=2, lty=2)
  lines(col_df$hru_row, col_df$hed_lyr_02, type="l", col="darkgoldenrod3", lwd=2, lty=2)
  lines(col_df$hru_row, col_df$hed_lyr_03, type="l", col="darkgoldenrod2", lwd=2, lty=2)
  lines(col_df$hru_row, col_df$hed_lyr_04, type="l", col="darkgoldenrod1", lwd=2, lty=2)
  points(col_df$hru_row[idx_well], col_df$dis_top_lyr_01[idx_well] + 50, type="p", col = "burlywood4", pch = 1, 
         cex = 2)
  points(col_df$hru_row[idx_stream], col_df$dis_top_lyr_01[idx_stream] + 50, type="p", col = "dodgerblue4", pch = 0, 
         cex = 2)
  points(col_df$hru_row[idx_lake], col_df$dis_top_lyr_01[idx_lake] + 50, type="p", col = "lightseagreen", pch = 3, 
         cex = 2)
  par(xpd=TRUE)
  legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
                                                  "gw head: layer 1", "gw head: layer 2", "gw head: layer 3", "gw head: layer 4", "gw well", "stream", "lake"),
         lty=c(2,2,2,2,2,2,2,2,2,NA,NA,NA), lwd=c(2,1,1,1,1,1,1,1,1,NA,NA,NA), pch=c(NA,NA,NA,NA,NA,NA,NA,NA,NA,1,0,3), pt.cex=2,
         col=c("black", "red", "blue", "green", "purple", "darkgoldenrod4","darkgoldenrod3", "darkgoldenrod2", "darkgoldenrod1",
               "burlywood4", "dodgerblue4", "lightseagreen"), bty="n")
  par(xpd=FALSE)
  grid()
  par(mar=c(5, 4, 4, 2) + 0.1)
  dev.off()
  
  
  
}









####--------------------------- plot long profile -------------------------####


# merge long profile with other data
lp <- inner_join(long_prof_hru, alam_df, by="hru_id")



#### long profile: all

# find min and max elevations for row cross-section plot
min_elev <- min(rbind(lp$dis_top_lyr_01, lp$dis_bttm_lyr_01, lp$dis_bttm_lyr_02,
                      lp$dis_bttm_lyr_03, lp$dis_bttm_lyr_04, lp$strtop), na.rm=TRUE)
max_elev <- max(rbind(lp$dis_top_lyr_01, lp$dis_bttm_lyr_01, lp$dis_bttm_lyr_02,
                      lp$dis_bttm_lyr_03, lp$dis_bttm_lyr_04, lp$strtop), na.rm=TRUE)


# plot long profile: all
jpeg(filename="../long_profile_plots/long_profile_all.jpg", width=12, height=8, units="in", quality=75, res=300)
par(mar = par()$mar + c(0,0,0,7))
plot(lp$num, lp$dis_bttm_lyr_04, type="l", col = "purple", lty=2, lwd=2, ylim=c(min_elev, max_elev), 
     main = "Long profile: all layers", 
     ylab="Elevation (ft)", 
     xlab = "Stream grid cell")
lines(lp$num, lp$dis_bttm_lyr_03, type="l", col="green", lty=2, lwd=2)
lines(lp$num, lp$dis_bttm_lyr_02, type="l", col= "blue", lty=2, lwd=2)
lines(lp$num, lp$dis_bttm_lyr_01, type="l", col="red", lty=2, lwd=2)
lines(lp$num, lp$dis_top_lyr_01, type="l", col= "black", lwd=4, lty=2)
lines(lp$num, lp$strtop, type="l", col="darkblue", lwd=2, lty=2)
# points(lp$num[idx_well], lp$dis_top_lyr_01[idx_well] + 50, type="p", col = "burlywood4", pch = 1, 
#        cex = 2)
# points(lp$num[idx_stream], lp$dis_top_lyr_01[idx_stream] + 50, type="p", col = "dodgerblue4", pch = 0, 
#        cex = 2)
# points(lp$num[idx_lake], lp$dis_top_lyr_01[idx_lake] + 50, type="p", col = "lightseagreen", pch = 3, 
#        cex = 2)
par(xpd=TRUE)
# legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
#                                                 "strtop", "gw well", "stream", "lake"),
#        lty=c(2,2,2,2,2,2,NA,NA,NA), lwd=c(2,1,1,1,1,1,NA,NA,NA), pch=c(NA,NA,NA,NA,NA,NA,1,0,3), pt.cex=2,
#        col=c("black", "red", "blue", "green", "purple", "darkblue", "burlywood4", "dodgerblue4", "lightseagreen"), bty="n")
legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
                                                "strtop"),
       lty=c(2,2,2,2,2,2), lwd=c(2,1,1,1,1,1), 
       col=c("black", "red", "blue", "green", "purple", "darkblue"), bty="n")

par(xpd=FALSE)
grid()
par(mar=c(5, 4, 4, 2) + 0.1)
dev.off()





#### long profile: layers 1 and 2 and strtop

# find min and max elevations for row cross-section plot
min_elev <- min(rbind(lp$dis_top_lyr_01, lp$dis_bttm_lyr_01, lp$dis_bttm_lyr_02,
                      lp$strtop), na.rm=TRUE)
max_elev <- max(rbind(lp$dis_top_lyr_01, lp$dis_bttm_lyr_01, lp$dis_bttm_lyr_02,
                      lp$strtop), na.rm=TRUE)


# plot long profile: upper layers
jpeg(filename="../long_profile_plots/long_profile_upper.jpg", width=12, height=8, units="in", quality=75, res=300)
par(mar = par()$mar + c(0,0,0,7))
plot(lp$num, lp$dis_bttm_lyr_04, type="l", col = "purple", lty=2, lwd=2, ylim=c(min_elev, max_elev), 
     main = "Long profile: upper layers", 
     ylab="Elevation (ft)", 
     xlab = "Stream grid cell")
lines(lp$num, lp$dis_bttm_lyr_03, type="l", col="green", lty=2, lwd=2)
lines(lp$num, lp$dis_bttm_lyr_02, type="l", col= "blue", lty=2, lwd=2)
lines(lp$num, lp$dis_bttm_lyr_01, type="l", col="red", lty=2, lwd=2)
lines(lp$num, lp$dis_top_lyr_01, type="l", col= "black", lwd=4, lty=2)
lines(lp$num, lp$strtop, type="l", col="darkblue", lwd=2, lty=2)
# points(lp$num[idx_well], lp$dis_top_lyr_01[idx_well] + 50, type="p", col = "burlywood4", pch = 1, 
#        cex = 2)
# points(lp$num[idx_stream], lp$dis_top_lyr_01[idx_stream] + 50, type="p", col = "dodgerblue4", pch = 0, 
#        cex = 2)
# points(lp$num[idx_lake], lp$dis_top_lyr_01[idx_lake] + 50, type="p", col = "lightseagreen", pch = 3, 
#        cex = 2)
par(xpd=TRUE)
# legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
#                                                 "strtop", "gw well", "stream", "lake"),
#        lty=c(2,2,2,2,2,2,NA,NA,NA), lwd=c(2,1,1,1,1,1,NA,NA,NA), pch=c(NA,NA,NA,NA,NA,NA,1,0,3), pt.cex=2,
#        col=c("black", "red", "blue", "green", "purple", "darkblue", "burlywood4", "dodgerblue4", "lightseagreen"), bty="n")
legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
                                                "strtop"),
       lty=c(2,2,2,2,2,2), lwd=c(2,1,1,1,1,1), col=c("black", "red", "blue", "green", "purple", "darkblue"), bty="n")
par(xpd=FALSE)
grid()
par(mar=c(5, 4, 4, 2) + 0.1)
dev.off()



# plot long profile: upper layers with final groundwater heads
jpeg(filename="../long_profile_plots/long_profile_upper_gw_heads.jpg", width=12, height=8, units="in", quality=75, res=300)
par(mar = par()$mar + c(0,0,0,7))
plot(lp$num, lp$dis_bttm_lyr_04, type="l", col = "purple", lty=2, lwd=2, ylim=c(min_elev, max_elev), 
     main = "Long profile: upper layers with groundwater heads", 
     ylab="Elevation (ft)", 
     xlab = "Stream grid cell")
lines(lp$num, lp$dis_bttm_lyr_03, type="l", col="green", lty=2, lwd=2)
lines(lp$num, lp$dis_bttm_lyr_02, type="l", col= "blue", lty=2, lwd=2)
lines(lp$num, lp$dis_bttm_lyr_01, type="l", col="red", lty=2, lwd=2)
lines(lp$num, lp$dis_top_lyr_01, type="l", col= "black", lwd=4, lty=2)
lines(lp$num, lp$strtop, type="l", col="darkblue", lwd=2, lty=2)
lines(lp$num, lp$hed_lyr_01, type="l", col="darkgoldenrod4", lwd=2, lty=2)
lines(lp$num, lp$hed_lyr_02, type="l", col="darkgoldenrod3", lwd=2, lty=2)
lines(lp$num, lp$hed_lyr_03, type="l", col="darkgoldenrod2", lwd=2, lty=2)
lines(lp$num, lp$hed_lyr_04, type="l", col="darkgoldenrod1", lwd=2, lty=2)
# points(lp$num[idx_well], lp$dis_top_lyr_01[idx_well] + 50, type="p", col = "burlywood4", pch = 1, 
#        cex = 2)
# points(lp$num[idx_stream], lp$dis_top_lyr_01[idx_stream] + 50, type="p", col = "dodgerblue4", pch = 0, 
#        cex = 2)
# points(lp$num[idx_lake], lp$dis_top_lyr_01[idx_lake] + 50, type="p", col = "lightseagreen", pch = 3, 
#        cex = 2)
par(xpd=TRUE)
# legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
#                                                 "strtop", "gw well", "stream", "lake"),
#        lty=c(2,2,2,2,2,2,NA,NA,NA), lwd=c(2,1,1,1,1,1,NA,NA,NA), pch=c(NA,NA,NA,NA,NA,NA,1,0,3), pt.cex=2,
#        col=c("black", "red", "blue", "green", "purple", "darkblue", "burlywood4", "dodgerblue4", "lightseagreen"), bty="n")
legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
                                                "strtop", "gw head: layer 1", "gw head: layer 2", "gw head: layer 3", "gw head: layer 4"),
       lty=c(2,2,2,2,2,2,2,2,2), lwd=c(2,1,1,1,1,1,1,1,1,1), col=c("black", "red", "blue", "green", "purple", 
                                                                   "darkblue", "darkgoldenrod4", "darkgoldenrod3", "darkgoldenrod2", "darkgoldenrod1"), bty="n")
par(xpd=FALSE)
grid()
par(mar=c(5, 4, 4, 2) + 0.1)
dev.off()









####--------------------------- try making layers 1 and 2 thicker -------------------------####

# create df to play around with
alam_thick <- alam_df

# set thickness increase
thick_inc <- 10

# make layer 1 thicker and adjust the layers underneath
idx <- which(alam_thick$bas_lyr_01 == 1)
alam_thick$dis_bttm_lyr_01[idx] <- alam_thick$dis_bttm_lyr_01[idx] - thick_inc
alam_thick$dis_bttm_lyr_02[idx] <- alam_thick$dis_bttm_lyr_02[idx] - thick_inc
alam_thick$dis_bttm_lyr_03[idx] <- alam_thick$dis_bttm_lyr_03[idx] - thick_inc
alam_thick$dis_bttm_lyr_04[idx] <- alam_thick$dis_bttm_lyr_04[idx] - thick_inc

# make layer 2 thicker and adjust the layers underneath
idx <- which(alam_thick$bas_lyr_02 == 1)
alam_thick$dis_bttm_lyr_02[idx] <- alam_thick$dis_bttm_lyr_02[idx] - thick_inc
alam_thick$dis_bttm_lyr_03[idx] <- alam_thick$dis_bttm_lyr_03[idx] - thick_inc
alam_thick$dis_bttm_lyr_04[idx] <- alam_thick$dis_bttm_lyr_04[idx] - thick_inc

# convert updated dis data into matrices
dis_bttm_lyr_01_thicker <- matrix(alam_thick$dis_bttm_lyr_01, nrow=771, ncol=702, byrow=TRUE)
dis_bttm_lyr_02_thicker <- matrix(alam_thick$dis_bttm_lyr_02, nrow=771, ncol=702, byrow=TRUE)
dis_bttm_lyr_03_thicker <- matrix(alam_thick$dis_bttm_lyr_03, nrow=771, ncol=702, byrow=TRUE)
dis_bttm_lyr_04_thicker <- matrix(alam_thick$dis_bttm_lyr_04, nrow=771, ncol=702, byrow=TRUE)

# export dis matrices
write.table(dis_bttm_lyr_01_thicker, "../dis_thicker/dis_bttm_lyr_01_thicker.txt", row.names=FALSE, col.names=FALSE,
            sep = " ", na="-9999", quote=FALSE)
write.table(dis_bttm_lyr_02_thicker, "../dis_thicker/dis_bttm_lyr_02_thicker.txt", row.names=FALSE, col.names=FALSE,
            sep = " ", na="-9999", quote=FALSE)
write.table(dis_bttm_lyr_03_thicker, "../dis_thicker/dis_bttm_lyr_03_thicker.txt", row.names=FALSE, col.names=FALSE,
            sep = " ", na="-9999", quote=FALSE)
write.table(dis_bttm_lyr_04_thicker, "../dis_thicker/dis_bttm_lyr_04_thicker.txt", row.names=FALSE, col.names=FALSE,
            sep = " ", na="-9999", quote=FALSE)




####--------------------------- plot cross sections across lakes -------------------------####

# # create empty lists to store rows and columns for each groundwater well
# row_xs <- list()
# col_xs <- list()
# 
# # hru_row and hru_col for the groundwater well hrus
# gw_wells <- c("mw01", "mw02", "mw03", "mw04", "mw05", "mw06", "mw07", "mw08", "mw09", "mw10", 
#               "vcb3","vcb4", "vcb6")
# gw_row <- c(213, 210, 203, 194, 186, 179, 170, 168, 167, 163, 240, 232, 227)
# gw_col <- c(169, 166, 161, 159, 159, 152, 141, 141, 139, 133, 175, 173, 170)
# 
# # number of hrus on each half of cross-section
# num_xs <- 30
# 
# # loop through groundwater wells
# for (i in 1:length(gw_row)){
#   
#   
#   #### row: all layers ####
#   
#   # extract row cross-section hrus
#   row_xs[[i]] <- c( (gw_col[[i]] - num_xs) : (gw_col[[i]] + num_xs) )
#   
#   # subset by row cross-section hrus
#   row_df <- subset(alam_df, subset = alam_df$hru_row == gw_row[i] & alam_df$hru_col %in% row_xs[[i]])
#   
#   # find groundwater well
#   idx_well <- which(!(is.na(row_df$gw_well)))
#   
#   # find stream
#   idx_stream <- which(!(is.na(row_df$iseg)))
#   
#   # find lake
#   idx_lake <- which(row_df$lak_lyr_01 != 0)
#   
#   # find min and max elevations for row cross-section plot
#   min_elev <- min(rbind(row_df$dis_top_lyr_01, row_df$dis_bttm_lyr_01, row_df$dis_bttm_lyr_02, 
#                         row_df$dis_bttm_lyr_03, row_df$dis_bttm_lyr_04), na.rm=TRUE)
#   max_elev <- max(rbind(row_df$dis_top_lyr_01 + 50, row_df$dis_bttm_lyr_01, row_df$dis_bttm_lyr_02, 
#                         row_df$dis_bttm_lyr_03, row_df$dis_bttm_lyr_04), na.rm=TRUE)
#   
#   # plot row cross-section
#   jpeg(filename=paste0("../xs_plots/row_xs_all_" , gw_wells[i], ".jpg"), width=12, height=8, units="in", quality=75, res=300)
#   par(xpd = TRUE, mar = par()$mar + c(0,0,0,7))
#   plot(row_df$hru_col, row_df$dis_bttm_lyr_04, type="l", col = "purple", lty=2, lwd=2, ylim=c(min_elev, max_elev), 
#        main = paste0("Cross-section across row ", gw_row[i], ": ", gw_wells[i]), 
#        ylab="Elevation (ft)", 
#        xlab = "HRU column")
#   lines(row_df$hru_col, row_df$dis_bttm_lyr_03, type="l", col="green", lty=2, lwd=2)
#   lines(row_df$hru_col, row_df$dis_bttm_lyr_02, type="l", col= "blue", lty=2, lwd=2)
#   lines(row_df$hru_col, row_df$dis_bttm_lyr_01, type="l", col="red", lty=2, lwd=2)
#   lines(row_df$hru_col, row_df$dis_top_lyr_01, type="l", col= "black", lwd=4, lty=2)
#   points(row_df$hru_col[idx_well], row_df$dis_top_lyr_01[idx_well] + 50, type="p", col = "burlywood4", pch = 1, 
#          cex = 2)
#   points(row_df$hru_col[idx_stream], row_df$dis_top_lyr_01[idx_stream] + 50, type="p", col = "dodgerblue4", pch = 0, 
#          cex = 2)
#   points(row_df$hru_col[idx_lake], row_df$dis_top_lyr_01[idx_lake] + 50, type="p", col = "lightseagreen", pch = 3, 
#          cex = 2)
#   legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
#                                                   "gw well", "stream", "lake"),
#          lty=c(2,2,2,2,2,NA,NA,NA), lwd=c(2,1,1,1,1,NA,NA,NA), pch=c(NA,NA,NA,NA,NA,1,0,3), pt.cex=2,
#          col=c("black", "red", "blue", "green", "purple", "burlywood4", "dodgerblue4", "lightseagreen"), bty="n")
#   par(xpd=FALSE)
#   grid()
#   par(mar=c(5, 4, 4, 2) + 0.1)
#   dev.off()
#   
#   
#   
#   
#   
#   #### row: layers 1 and 2 ####
#   
#   # extract row cross-section hrus
#   row_xs[[i]] <- c( (gw_col[[i]] - num_xs) : (gw_col[[i]] + num_xs) )
#   
#   # subset by row cross-section hrus
#   row_df <- subset(alam_df, subset = alam_df$hru_row == gw_row[i] & alam_df$hru_col %in% row_xs[[i]])
#   
#   # find groundwater well
#   idx_well <- which(!(is.na(row_df$gw_well)))
#   
#   # find stream
#   idx_stream <- which(!(is.na(row_df$iseg)))
#   
#   # find lake
#   idx_lake <- which(row_df$lak_lyr_01 != 0)
#   
#   # find min and max elevations for row cross-section plot
#   min_elev <- min(rbind(row_df$dis_top_lyr_01, row_df$dis_bttm_lyr_01, row_df$dis_bttm_lyr_02), na.rm=TRUE)
#   max_elev <- max(rbind(row_df$dis_top_lyr_01+50, row_df$dis_bttm_lyr_01, row_df$dis_bttm_lyr_02), na.rm=TRUE)
#   
#   # plot row cross-section
#   jpeg(filename=paste0("../xs_plots/row_xs_upper_" , gw_wells[i], ".jpg"), width=12, height=8, units="in", quality=75, res=300)
#   par(mar = par()$mar + c(0,0,0,7))
#   plot(row_df$hru_col, row_df$dis_bttm_lyr_04, type="l", col = "purple", lty=2, lwd=2, ylim=c(min_elev, max_elev), 
#        main = paste0("Cross-section across row ", gw_row[i], ": ", gw_wells[i]), 
#        ylab="Elevation (ft)", 
#        xlab = "HRU column")
#   lines(row_df$hru_col, row_df$dis_bttm_lyr_03, type="l", col="green", lty=2, lwd=2)
#   lines(row_df$hru_col, row_df$dis_bttm_lyr_02, type="l", col= "blue", lty=2, lwd=2)
#   lines(row_df$hru_col, row_df$dis_bttm_lyr_01, type="l", col="red", lty=2, lwd=2)
#   lines(row_df$hru_col, row_df$dis_top_lyr_01, type="l", col= "black", lwd=4, lty=2)
#   lines(row_df$hru_col, row_df$hed_lyr_01, type="l", col="darkgoldenrod4", lwd=2, lty=2)
#   lines(row_df$hru_col, row_df$hed_lyr_02, type="l", col="darkgoldenrod3", lwd=2, lty=2)
#   lines(row_df$hru_col, row_df$hed_lyr_03, type="l", col="darkgoldenrod2", lwd=2, lty=2)
#   lines(row_df$hru_col, row_df$hed_lyr_04, type="l", col="darkgoldenrod1", lwd=2, lty=2)
#   points(row_df$hru_col[idx_well], row_df$dis_top_lyr_01[idx_well] + 50, type="p", col = "burlywood4", pch = 1, 
#          cex = 2)
#   points(row_df$hru_col[idx_stream], row_df$dis_top_lyr_01[idx_stream] + 50, type="p", col = "dodgerblue4", pch = 0, 
#          cex = 2)
#   points(row_df$hru_col[idx_lake], row_df$dis_top_lyr_01[idx_lake] + 50, type="p", col = "lightseagreen", pch = 3, 
#          cex = 2)
#   par(xpd=TRUE)
#   legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
#                                                   "gw head: layer 1", "gw head: layer 2", "gw head: layer 3", "gw head: layer 4", "gw well", "stream", "lake"),
#          lty=c(2,2,2,2,2,2,2,2,2,NA,NA,NA), lwd=c(2,1,1,1,1,1,1,1,1,NA,NA,NA), pch=c(NA,NA,NA,NA,NA,NA,NA,NA,NA,1,0,3), pt.cex=2,
#          col=c("black", "red", "blue", "green", "purple", "darkgoldenrod4","darkgoldenrod3", "darkgoldenrod2", "darkgoldenrod1",
#                "burlywood4", "dodgerblue4", "lightseagreen"), bty="n")
#   par(xpd=FALSE)
#   grid()
#   par(mar=c(5, 4, 4, 2) + 0.1)
#   dev.off()
#   
#   
#   
#   
#   
#   #### column: all layers ####
#   
#   
#   # extract column cross-section hrus
#   col_xs[[i]] <- c( (gw_row[[i]] - num_xs) : (gw_row[[i]] + num_xs) )
#   
#   # subset by column cross-section hrus
#   col_df <- subset(alam_df, subset = alam_df$hru_col == gw_col[i] & alam_df$hru_row %in% col_xs[[i]])
#   
#   # find groundwater well
#   idx_well <- which(!(is.na(col_df$gw_well)))
#   
#   # find stream
#   idx_stream <- which(!(is.na(col_df$iseg)))
#   
#   # find lake
#   idx_lake <- which(col_df$lak_lyr_01 != 0)
#   
#   # find min and max elevations for column cross-section plot
#   min_elev <- min(rbind(col_df$dis_top_lyr_01, col_df$dis_bttm_lyr_01, col_df$dis_bttm_lyr_02,
#                         col_df$dis_bttm_lyr_03, col_df$dis_bttm_lyr_04), na.rm=TRUE)
#   max_elev <- max(rbind(col_df$dis_top_lyr_01+50, col_df$dis_bttm_lyr_01, col_df$dis_bttm_lyr_02,
#                         col_df$dis_bttm_lyr_03, col_df$dis_bttm_lyr_04), na.rm=TRUE)
#   
#   
#   # plot column cross-sections
#   jpeg(filename=paste0("../xs_plots/column_xs_all_" , gw_wells[i], ".jpg"), width=12, height=8, units="in", quality=75, res=300)
#   par(mar = par()$mar + c(0,0,0,7))
#   plot(col_df$hru_row, col_df$dis_bttm_lyr_04, type="l", col = "purple", lty=2, lwd=2, ylim=c(min_elev, max_elev), 
#        main = paste0("Cross-section across column ", gw_col[i], ": ", gw_wells[i]), 
#        ylab="Elevation (ft)", 
#        xlab = "HRU row")
#   lines(col_df$hru_row, col_df$dis_bttm_lyr_03, type="l", col="green", lty=2, lwd=2)
#   lines(col_df$hru_row, col_df$dis_bttm_lyr_02, type="l", col= "blue", lty=2, lwd=2)
#   lines(col_df$hru_row, col_df$dis_bttm_lyr_01, type="l", col="red", lty=2, lwd=2)
#   lines(col_df$hru_row, col_df$dis_top_lyr_01, type="l", col= "black", lwd=4, lty=2)
#   points(col_df$hru_row[idx_well], col_df$dis_top_lyr_01[idx_well] + 50, type="p", col = "burlywood4", pch = 1, 
#          cex = 2)
#   points(col_df$hru_row[idx_stream], col_df$dis_top_lyr_01[idx_stream] + 50, type="p", col = "dodgerblue4", pch = 0, 
#          cex = 2)
#   points(col_df$hru_row[idx_lake], col_df$dis_top_lyr_01[idx_lake] + 50, type="p", col = "lightseagreen", pch = 3, 
#          cex = 2)
#   par(xpd=TRUE)
#   legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
#                                                   "gw well", "stream", "lake"),
#          lty=c(2,2,2,2,2,NA,NA,NA), lwd=c(2,1,1,1,1,NA,NA,NA), pch=c(NA,NA,NA,NA,NA,1,0,3), pt.cex=2,
#          col=c("black", "red", "blue", "green", "purple", "burlywood4", "dodgerblue4", "lightseagreen"), bty="n")
#   par(xpd=FALSE)
#   grid()
#   par(mar=c(5, 4, 4, 2) + 0.1)
#   dev.off()
#   
#   
#   
#   
#   
#   
#   #### column: layers and 1 and 2 ####
#   
#   # extract column cross-section hrus
#   col_xs[[i]] <- c( (gw_row[[i]] - num_xs) : (gw_row[[i]] + num_xs) )
#   
#   # subset by column cross-section hrus
#   col_df <- subset(alam_df, subset = alam_df$hru_col == gw_col[i] & alam_df$hru_row %in% col_xs[[i]])
#   
#   # find min and max elevations for column cross-section plot
#   min_elev <- min(rbind(col_df$dis_top_lyr_01, col_df$dis_bttm_lyr_01, col_df$dis_bttm_lyr_02), na.rm=TRUE)
#   max_elev <- max(rbind(col_df$dis_top_lyr_01+50, col_df$dis_bttm_lyr_01, col_df$dis_bttm_lyr_02), na.rm=TRUE)
#   
#   # plot column cross-sections
#   jpeg(filename=paste0("../xs_plots/column_xs_upper_" , gw_wells[i], ".jpg"), width=12, height=8, units="in", quality=75, res=300)
#   par(mar = par()$mar + c(0,0,0,7))
#   plot(col_df$hru_row, col_df$dis_bttm_lyr_04, type="l", col = "purple", lty=2, lwd=2, ylim=c(min_elev, max_elev), 
#        main = paste0("Cross-section across column ", gw_col[i], ": ", gw_wells[i]), 
#        ylab="Elevation (ft)", 
#        xlab = "HRU row")
#   lines(col_df$hru_row, col_df$dis_bttm_lyr_03, type="l", col="green", lty=2, lwd=2)
#   lines(col_df$hru_row, col_df$dis_bttm_lyr_02, type="l", col= "blue", lty=2, lwd=2)
#   lines(col_df$hru_row, col_df$dis_bttm_lyr_01, type="l", col="red", lty=2, lwd=2)
#   lines(col_df$hru_row, col_df$dis_top_lyr_01, type="l", col= "black", lwd=4, lty=2)
#   lines(col_df$hru_row, col_df$hed_lyr_01, type="l", col="darkgoldenrod4", lwd=2, lty=2)
#   lines(col_df$hru_row, col_df$hed_lyr_02, type="l", col="darkgoldenrod3", lwd=2, lty=2)
#   lines(col_df$hru_row, col_df$hed_lyr_03, type="l", col="darkgoldenrod2", lwd=2, lty=2)
#   lines(col_df$hru_row, col_df$hed_lyr_04, type="l", col="darkgoldenrod1", lwd=2, lty=2)
#   points(col_df$hru_row[idx_well], col_df$dis_top_lyr_01[idx_well] + 50, type="p", col = "burlywood4", pch = 1, 
#          cex = 2)
#   points(col_df$hru_row[idx_stream], col_df$dis_top_lyr_01[idx_stream] + 50, type="p", col = "dodgerblue4", pch = 0, 
#          cex = 2)
#   points(col_df$hru_row[idx_lake], col_df$dis_top_lyr_01[idx_lake] + 50, type="p", col = "lightseagreen", pch = 3, 
#          cex = 2)
#   par(xpd=TRUE)
#   legend("topright", inset = c(-0.2, 0), legend=c("layer 1: top", "layer 1: bottom", "layer 2: bottom", "layer 3: bottom", "layer 4: bottom", 
#                                                   "gw head: layer 1", "gw head: layer 2", "gw head: layer 3", "gw head: layer 4", "gw well", "stream", "lake"),
#          lty=c(2,2,2,2,2,2,2,2,2,NA,NA,NA), lwd=c(2,1,1,1,1,1,1,1,1,NA,NA,NA), pch=c(NA,NA,NA,NA,NA,NA,NA,NA,NA,1,0,3), pt.cex=2,
#          col=c("black", "red", "blue", "green", "purple", "darkgoldenrod4","darkgoldenrod3", "darkgoldenrod2", "darkgoldenrod1",
#                "burlywood4", "dodgerblue4", "lightseagreen"), bty="n")
#   par(xpd=FALSE)
#   grid()
#   par(mar=c(5, 4, 4, 2) + 0.1)
#   dev.off()
#   
#   
#   
# }









####--------------------------- are there inactive cells adjacent to the lakes? -------------------------####



# identify grid cells in layers 1 and 2 that are at the lake boundaries:

lw_lakes <- c(2:10)
num_bdry_cell <- 1
bdry_lake_lyr_01 <- list()
bdry_lake_lyr_02 <- list()
for (i in 1:length(lw_lakes)){
  
  # identify lake grid cells in each upper layer
  idx_lk_lyr_01 <- which(alam_df$lak_lyr_01 == lw_lakes[i])
  idx_lk_lyr_02 <- which(alam_df$lak_lyr_02 == lw_lakes[i])
  
  # get the hru_row and hru_col for the lake grid cells in each upper layer
  row_lyr_01 <- alam_df$hru_row[idx_lk_lyr_01]
  col_lyr_01 <- alam_df$hru_col[idx_lk_lyr_01]
  row_lyr_02 <- alam_df$hru_row[idx_lk_lyr_02]
  col_lyr_02 <- alam_df$hru_col[idx_lk_lyr_02]
  
  # look in all directions
  row_lyr_01_plus <- row_lyr_01 + num_bdry_cell
  row_lyr_01_minus <- row_lyr_01 - num_bdry_cell
  col_lyr_01_plus <- col_lyr_01 + num_bdry_cell
  col_lyr_01_minus <- col_lyr_01 - num_bdry_cell
  
  row_lyr_02_plus <- row_lyr_02 + num_bdry_cell
  row_lyr_02_minus <- row_lyr_02 - num_bdry_cell
  col_lyr_02_plus <- col_lyr_02 + num_bdry_cell
  col_lyr_02_minus <- col_lyr_02 - num_bdry_cell
  
  
  # get all possible boundary cells for layers 1 and 2
  idx_bdry_lyr_01_all <- c()
  idx_bdry_lyr_02_all <- c()
  for (j in 1:length(row_lyr_01)){
    
    
    #### layer 1 ####
    
    # row plus
    idx_possible_bdry_row_plus <- which(alam_df$hru_row == row_lyr_01_plus[j] & alam_df$hru_col == col_lyr_01[j])
    
    # row minus
    idx_possible_bdry_row_minus <- which(alam_df$hru_row == row_lyr_01_minus[j] & alam_df$hru_col == col_lyr_01[j])
    
    # col plus
    idx_possible_bdry_col_plus <- which(alam_df$hru_row == row_lyr_01[j] & alam_df$hru_col == col_lyr_01_plus[j])
    
    # col minus
    idx_possible_bdry_col_minus <- which(alam_df$hru_row == row_lyr_01[j] & alam_df$hru_col == col_lyr_01_minus[j])
    
    # store together
    idx_possible_bdry_lyr_01 <- c(idx_possible_bdry_row_plus, idx_possible_bdry_row_minus, 
                                  idx_possible_bdry_col_plus, idx_possible_bdry_col_minus)
    
    # identify non-lake grid cells
    idx_non_lake_lyr_01 <- which(alam_df$lak_lyr_01 == 0)
    
    # find the possible boundary grid cells that are also non-lake cells - so find the actual boundary cells
    idx_bdry_lyr_01 <- intersect(idx_possible_bdry_lyr_01, idx_non_lake_lyr_01)
    
    # store 
    idx_bdry_lyr_01_all <- c(idx_bdry_lyr_01_all, idx_bdry_lyr_01)
    
    
    
    
    
    #### layer 2 ####
    
    # row plus
    idx_possible_bdry_row_plus <- which(alam_df$hru_row == row_lyr_02_plus[j] & alam_df$hru_col == col_lyr_02[j])
    
    # row minus
    idx_possible_bdry_row_minus <- which(alam_df$hru_row == row_lyr_02_minus[j] & alam_df$hru_col == col_lyr_02[j])
    
    # col plus
    idx_possible_bdry_col_plus <- which(alam_df$hru_row == row_lyr_02[j] & alam_df$hru_col == col_lyr_02_plus[j])
    
    # col minus
    idx_possible_bdry_col_minus <- which(alam_df$hru_row == row_lyr_02[j] & alam_df$hru_col == col_lyr_02_minus[j])
    
    # store together
    idx_possible_bdry_lyr_02 <- c(idx_possible_bdry_row_plus, idx_possible_bdry_row_minus, 
                                  idx_possible_bdry_col_plus, idx_possible_bdry_col_minus)
    
    
    # identify non-lake grid cells
    idx_non_lake_lyr_02 <- which(alam_df$lak_lyr_02 == 0)
    
    # find the possible boundary grid cells that are also non-lake cells - so find the actual boundary cells
    idx_bdry_lyr_02 <- intersect(idx_possible_bdry_lyr_02, idx_non_lake_lyr_02)
    
    # store 
    idx_bdry_lyr_02_all <- c(idx_bdry_lyr_02_all, idx_bdry_lyr_02)
    
    
  }
  
  bdry_lake_lyr_01[[i]] <- idx_bdry_lyr_01_all
  bdry_lake_lyr_02[[i]] <- idx_bdry_lyr_02_all
  
  
}
bdry_lake <- list(bdry_lake_lyr_01, bdry_lake_lyr_02)




# add lake bound array + ibound array 
lak_plus_ibnd_lay_01 <- alam_df$bas_lyr_01 + alam_df$lak_lyr_01
lak_plus_ibnd_lay_02 <- alam_df$bas_lyr_02 + alam_df$lak_lyr_02
lak_plus_ibnd <- list(lak_plus_ibnd_lay_01, lak_plus_ibnd_lay_02)



# check for zero values in lake boundary grid cells in lak_plus_ibnd_lay_01 and lak_plus_ibnd_lay_02
inactive_list <- list()
for (i in 1:length(bdry_lake)){
  
  # create list to store inactive cells for each layer-lake combination
  inactive_lake_bdry <- list()
  
  # loop though lakes
  for (j in 1:length(bdry_lake[[i]])){
    
    inactive_lake_bdry[[j]] <- which(lak_plus_ibnd[[i]][ bdry_lake[[i]][[j]] ] == 0)
    
  }
  
  # store in list
  inactive_list[[i]] <- inactive_lake_bdry
  
  
}






