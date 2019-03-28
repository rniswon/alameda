#---- Goal -----------------------------------------------------------####

# Read in prms parameter files into a data frame



#---- Set up -----------------------------------------------------------####

# # install packages
# install.packages("devtools")
# devtools::install_github("cneyens/prms")
# 
# # load packages 
# 


# set working directory
setwd("C:/git_repos/alameda/pestPrep")






#---- Source functions -----------------------------------------------------------------------####

source(file = "./extract_prms_parameters_support_functions.R")




#---- Read in prms parameter files -----------------------------------------------------------####


# set up parameter files
param_path_calib <- paste0(getwd(), "/gsflow/input/prms_lower/alameda_calibration_parameters_gsflow.param")
param_path_gis_derived <- paste0(getwd(), "/gsflow/input/prms_lower/alameda_gis_derived_parameters.param")
param_path_default <- paste0(getwd(), "/gsflow/input/prms_lower/alameda_default_values.param")
param_path_cascade <- paste0(getwd(), "/gsflow/input/prms_lower/alameda_cascade.param")

# read in prms parameter files
params <- read_prms_parms(param_path_calib, param_path_gis_derived, param_path_default, param_path_cascade)




#---- Place subset of prms parameters into data frame -------------------------------------------------####


# identify parameters with dimension nhru
idx <- which(params$parameters$nr_dim == 1 & params$parameters$dim %in% "nhru")
param_names_nhru <- params$parameters$name[idx]
param_val_nhru <- params$parameters$values[idx]


# reformat parameters with dimension nhru
params_nhru <- data.frame(do.call(cbind, param_val_nhru))
names(params_nhru) <- param_names_nhru





#---- Explore data frame --------------------------------------------------####



# # filter by subbasin
# test <- params_nhru %>% 
#   filter(., params_nhru$`hru_subbasin 0` %in% c(1:7))
# 
# test$hru_type
  

# loop through subbasin_id values and make changes
hru_subbasin <- params_nhru$`hru_subbasin 0`
subbasin_id_old <- c(8:12)
subbasin_id_new <- c(1:5)
for (i in 1:length(subbasin_id_old)){
  
  # find and replace 8:12 by 1:5
  idx <- which(hru_subbasin == subbasin_id_old[i])
  hru_subbasin[idx] <- subbasin_id_new[i]
  
}


# export
write.table(hru_subbasin, file="./gsflow/input/prms_lower/hru_subbasin.txt", 
            row.names=FALSE, col.names=FALSE)











