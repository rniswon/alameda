#---- Goal --------------------------------------------------------------------------------#

# The goal of this script is to summarize the parameter values in the pest control file


#---- Settings --------------------------------------------------------------------------------#

# clear all
rm(list=ls())

# set working directory
setwd("C:/git_repos/alameda/pestPrep/data_prep")


# read in libraries
library(dplyr)
library(purrr)



#---- Read in --------------------------------------------------------------------------------#

param <- read.csv("./pest_control_file_20190613.csv")




#---- Summarize --------------------------------------------------------------------------------#


# summarize parameters
param_summary <- param %>% 
  group_by(., group) %>%
  summarize(., 
            initial=mean(initial),
            min = mean(min),
            max=mean(max))

# export summary
write.csv(param_summary, "./param_summary.csv")




#---- Plot hydraulic conductivites for aquifer -------------------------------------------------#

# filter to get just hydraulic conductivities
K_val <- param %>% 
  filter(., group %in% c("ppts_l1", "ppts_l2", "ppts_l3", "ppts_l4")) %>%
  gather(., key="variable", value="value", -id, -group)

# plot K values
jpeg(filename="./K_boxplot.jpg", width = 12, height = 8, units = "in", quality = 75, res = 300)  
K_plot <- ggplot(K_val, aes(x=variable, y=value)) + 
  geom_boxplot() + 
  scale_y_log10() + 
  facet_wrap(~group, scales="free_y") + 
  ggtitle("Parameter values: aquifer K by layer") + 
  xlab("Variable") + 
  ylab("Hydaulic conductivity (ft/day)")
print(K_plot)
dev.off()
  





