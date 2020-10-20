#---- Goal ------------------------------------------------------------------####

# 1) Extract cell by cell budget from modflow binary file
# 2) Identify cells that contribute water to ponds
# 3) Visualize (map?) cells that contribute water to ponds




#---- Set up -----------------------------------------------------------------####


# install packages
#install.packages("tidyverse")
#install.packages("inlmisc")


# load packages
library(tidyverse)
library(lubridate)
library(inlmisc)
library(rgdal)


# set working directory
setwd("C:/git_repos/alameda/pestPrep")



#---- Read in -------------------------------------------------------------------####

# read in dataset relating row/column ids with hru ids
alam_df <- read.csv(file="./GIS/alam_df.csv")
alam_df <- alam_df %>%
  dplyr::select(., hru_id, hru_row, hru_col)

# read in hru_params_all shapefile
hru_params_all_hru_id <- readOGR(dsn = "./GIS", layer = "hru_params_all_HRU_ID")




#---- Extract binary files -----------------------------------------------------------------####

# extract upw cell by cell budget files
upw_cbc_budget <- ReadModflowBinary(
  path = "./gsflow/output/modflow/upw_cbc_budget.unf",
  data.type = "flow",
  endian = "little",
  rm.totim.0 = FALSE
)


# extract lake cell by cell budget files
lake_cbc_budget <- ReadModflowBinary(
  path = "./gsflow/output/modflow/lake_cbc_budget.unf",
  data.type = "flow",
  endian = "little",
  rm.totim.0 = FALSE
)


#---- Reformat and export -----------------------------------------------------------------####

# create variable names from variable descriptions
var_names <- sapply(upw_cbc_budget, "[[", "desc")
var_names <- str_replace_all(var_names, " ", "_")
layers <- sapply(upw_cbc_budget, "[[", "layer")
var_names <- paste0(var_names, "_lyr", layers)

# add row and column numbers
budget_list <- vector(mode="list", length=length(upw_cbc_budget))
for (i in 1:length(upw_cbc_budget)){
  
  # create data frame
  df <- data.frame(upw_cbc_budget[[i]]$d)
  
  # add row numbers
  hru_row <- 1:nrow(df)
  df <- cbind(hru_row, df)
  
  # reshape to get column of column numbers
  df <- pivot_longer(df, cols= c(-hru_row), names_to = "hru_col", values_to = var_names[i])
  
  # remove X from column
  df$hru_col <- str_replace(df$hru_col, "X", "")
  df$hru_col <- as.numeric(df$hru_col)
  
  # store in list
  budget_list[[i]] <- df
  
}
  
# join list of data frames by row and column
budget_df <- budget_list %>% 
  reduce(left_join, by=c("hru_row", "hru_col"))


# join budget_df with alam_df 
budget_df <- left_join(alam_df, budget_df, by = c("hru_row", "hru_col"))

# join budget_df with hru_params_all_HRU_ID
budget_df <- merge(hru_params_all_hru_id, budget_df, by.x='HRU_ID', by.y='hru_id')


# export csv and shapefile
write.csv(budget_df@data, file= "./GIS/cell_by_cell_budget/cell_by_cell_budget.csv", row.names=FALSE)
writeOGR(obj=budget_df, dsn="./GIS", layer="cell_by_cell_budget", driver="ESRI Shapefile", overwrite_layer = TRUE)


