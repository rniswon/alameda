#---- Goal --------------------------------------------------------------------------------#

# The goal of this script is to prep F2 and F4 discharges for input into gsflow as tabfiles





#---- Settings --------------------------------------------------------------------------------#

# clear all
rm(list=ls())

# set working directory
setwd("C:/git_repos/alameda/pestPrep/data_prep/pond_discharges/prep_for_gsflow")


# read in libraries
library(tidyverse)




#---- Read in --------------------------------------------------------------------------------#

f2 <- read.csv("./f2_discharge.csv")
f4 <- read.csv("./f4_discharge.csv")




#---- Reformat f4 --------------------------------------------------------------------------------#


# extract dates
Q_dates <- select(f2, -Pond, -Q_cfs)

# reformat
f4 <- left_join(Q_dates, f4, by=c("HY", "Month"))

# remove data > 2014
f4 <- filter(f4, HY <= 2014)

# only have columns for id and Q
f4$id <- 0:2190
f4 <- select(f4, id, Q_cfs)

# convert cfs to cfd
f4$Q_cfs <- f4$Q_cfs * 86400

# set 0 to 1e-5
idx <- which(f4$Q_cfs == 0)
f4$Q_cfs[idx] <- 1e-5




#---- Reformat f2 --------------------------------------------------------------------------------#

# remove data > 2014
f2 <- filter(f2, HY <= 2014)

# only have columns for id and Q
f2$id <- 0:2190
f2 <- select(f2, id, Q_cfs)

# convert cfs to cfd
f2$Q_cfs <- f2$Q_cfs * 86400

# set 0 to 1e-5
idx <- which(f2$Q_cfs == 0)
f2$Q_cfs[idx] <- 1e-5



#---- Create tabfiles for other ponds with drainage segments ---------------------------------------#

discharge_smp32 <- data.frame(id=0:2190, Q_cfs = rep(0, 2191))
discharge_f6 <- discharge_smp32
#discharge_f4 <- discharge_smp32
discharge_f3w <- discharge_smp32
discharge_f3e <- discharge_smp32



#---- Export --------------------------------------------------------------------------------------#

write.table(f2, "../tabfiles_for_gsflow/discharge_f2.txt", col.names=FALSE, row.names=FALSE)

write.table(f4, "../tabfiles_for_gsflow/discharge_f4.txt", col.names=FALSE, row.names=FALSE)

write.table(discharge_smp32, "../tabfiles_for_gsflow/discharge_smp32.txt", col.names=FALSE, row.names=FALSE)

write.table(discharge_f6, "../tabfiles_for_gsflow/discharge_f6.txt", col.names=FALSE, row.names=FALSE)

#write.table(discharge_f4, "../tabfiles_for_gsflow/discharge_f4.txt", col.names=FALSE, row.names=FALSE)

write.table(discharge_f3w, "../tabfiles_for_gsflow/discharge_f3w.txt", col.names=FALSE, row.names=FALSE)

write.table(discharge_f3e, "../tabfiles_for_gsflow/discharge_f3e.txt", col.names=FALSE, row.names=FALSE)








