#---- Goal ---------------------------------------------------------------------#

# Plot flows reach by reach in the mainstem of Alameda Creek




#---- Settings ---------------------------------------------------------------------#


# install packages
#install.packages(tidyverse)

# load packages
library("tidyverse")


# set working directory
setwd("C:/git_repos/alameda/pestPrep")




#---- Read in ---------------------------------------------------------------------#


# read in sfr streams
sfr_streams <- read.table(file="./gsflow/output/modflow/subbasin_runoff/SFR_streams.out", skip=8)




#---- Reformat ---------------------------------------------------------------------#

# add column names
names(sfr_streams) <- c("layer", "row", "col", "iseg", "ireach", "flow_into_reach", 
                        "flow_to_aquifer", "flow_out_of_reach", "overland_runoff", 
                        "direct_precip", "stream_et", "stream_head", "stream_depth", 
                        "stream_width", "streambed_k", "streambed_gradient")

# add column for stream gauges
sfr_streams$stream_gauges <- NA
idx_gag1 <- which(sfr_streams$iseg == 351 & sfr_streams$ireach == 6)  # Alameda Creek below Calaveras Creek
idx_gag2 <- which(sfr_streams$iseg == 282 & sfr_streams$ireach == 10)  # Alameda Creek below Welch Creek
idx_gag3 <- which(sfr_streams$iseg == 196 & sfr_streams$ireach == 11)  # Alameda Creek above San Antonio Creek
idx_gag4 <- which(sfr_streams$iseg == 149 & sfr_streams$ireach == 4)   # Alameda Creek above Arroyo de la Laguna
idx_gag5 <- which(sfr_streams$iseg == 144 & sfr_streams$ireach == 2)   # Alameda Creek at Niles
sfr_streams$stream_gauges[c(idx_gag1, idx_gag2, idx_gag3, idx_gag4, idx_gag5)] <- 1


#---- Extract ISEG ---------------------------------------------------------------------#

# iseg: calaveras creek to niles
cal_to_niles <- c(368, 351, 349, 340, 337, 336, 313, 308, 301, 299, 282, 271, 260, 255, 
                  247, 215, 196, 187, 175, 161, 152, 149, 143, 139, 124, 123, 117, 111,
                  110, 134, 109, 108, 112, 126, 129, 132, 144)

# iseg: calaveras creek to arroyo hondo
cal_to_arroyolaguna <- c(368, 351, 349, 340, 337, 336, 313, 308, 301, 299, 282, 271, 260, 255, 
                        247, 215, 196, 187, 175, 161, 152, 149)


# # iseg: alameda creek below acdd to alameda creek below calaveras creek
# alam_ck_below_acdd_to_below_cal_ck <- c(384, 376, 375, 377, 374, 372, 371, 360, 358, 357, 356, 359, 351)
# 
# # iseg: san antonio creek to confluence with alameda creek
# san_antonio_ck_to_confluence <- c(182, 179, 194, 187)
# 

# calaveras creek to niles: filter by iseg, order by iseg and ireach
cal_to_niles_df <- sfr_streams %>%
  filter(., iseg %in% cal_to_niles)
cal_to_niles <- as.integer(cal_to_niles)
ordered_iseg <- cal_to_niles_df$iseg[order(match(cal_to_niles_df$iseg, cal_to_niles))]
cal_to_niles_df <- cal_to_niles_df[order(match(cal_to_niles_df$iseg, ordered_iseg), cal_to_niles_df$ireach), ]

# 
# # alameda creek below acdd to alameda creek below calaveras creek: filter by iseg, order by iseg and ireach
# alam_ck_below_acdd_to_below_cal_ck_df <- alam_df %>%
#   filter(., iseg %in% alam_ck_below_acdd_to_below_cal_ck)
# alam_ck_below_acdd_to_below_cal_ck <- as.integer(alam_ck_below_acdd_to_below_cal_ck)
# ordered_iseg <- alam_ck_below_acdd_to_below_cal_ck_df$iseg[order(match(alam_ck_below_acdd_to_below_cal_ck_df$iseg, alam_ck_below_acdd_to_below_cal_ck))]
# alam_ck_below_acdd_to_below_cal_ck_df <- alam_ck_below_acdd_to_below_cal_ck_df[order(match(alam_ck_below_acdd_to_below_cal_ck_df$iseg, ordered_iseg), alam_ck_below_acdd_to_below_cal_ck_df$ireach), ]
# 
# 
# # san antonio creek to confluence with alameda creek: filter by iseg, order by iseg and ireach
# san_antonio_ck_to_confluence_df <- alam_df %>%
#   filter(., iseg %in% san_antonio_ck_to_confluence)
# san_antonio_ck_to_confluence <- as.integer(san_antonio_ck_to_confluence)
# ordered_iseg <- san_antonio_ck_to_confluence_df$iseg[order(match(san_antonio_ck_to_confluence_df$iseg, san_antonio_ck_to_confluence))]
# san_antonio_ck_to_confluence_df <- san_antonio_ck_to_confluence_df[order(match(san_antonio_ck_to_confluence_df$iseg, ordered_iseg), san_antonio_ck_to_confluence_df$ireach), ]


# calaveras creek to arroyo de la laguna: filter by iseg, order by iseg and ireach
cal_to_arroyolaguna_df <- sfr_streams %>%
  filter(., iseg %in% cal_to_arroyolaguna)
cal_to_arroyolaguna <- as.integer(cal_to_arroyolaguna)
ordered_iseg <- cal_to_arroyolaguna_df$iseg[order(match(cal_to_arroyolaguna_df$iseg, cal_to_arroyolaguna))]
cal_to_arroyolaguna_df <- cal_to_arroyolaguna_df[order(match(cal_to_arroyolaguna_df$iseg, ordered_iseg), cal_to_arroyolaguna_df$ireach), ]





#---- Plot: Calaveras Creek to Niles ---------------------------------------------------------------------#


# prep for plotting stream gauges
idx_gauges <- which(cal_to_niles_df$stream_gauges == 1)
stream_gauges_df <- filter(cal_to_niles_df, stream_gauges == 1)


# plot overland runoff for calaveras creek to niles
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_niles_overland_runoff.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_niles_df$layer)
plot(idx_stream, cal_to_niles_df$overland_runoff, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Flow (cfs)", main="Overland runoff: Calaveras Creek to Niles")
points(idx_stream[idx_gauges], stream_gauges_df$overland_runoff, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot flow to aquifer for calaveras creek to niles
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_niles_flow_to_aquifer.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_niles_df$layer)
plot(idx_stream, cal_to_niles_df$flow_to_aquifer, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Flow (cfs)", main="Flow to aquifer: Calaveras Creek to Niles")
points(idx_stream[idx_gauges], stream_gauges_df$flow_to_aquifer, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot flow out of reach for calaveras creek to niles
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_niles_flow_out_of_reach.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_niles_df$layer)
plot(idx_stream, cal_to_niles_df$flow_out_of_reach, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Flow (cfs)", main="Flow out of reach: Calaveras Creek to Niles")
points(idx_stream[idx_gauges], stream_gauges_df$flow_out_of_reach, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot flow into reach for calaveras creek to niles
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_niles_flow_into_reach.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_niles_df$layer)
plot(idx_stream, cal_to_niles_df$flow_into_reach, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Flow (cfs)", main="Flow into reach: Calaveras Creek to Niles")
points(idx_stream[idx_gauges], stream_gauges_df$flow_into_reach, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot stream heads for calaveras creek to niles
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_niles_stream_head.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_niles_df$layer)
plot(idx_stream, cal_to_niles_df$stream_head, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Elevation (ft)", main="Stream head: Calaveras Creek to Niles")
points(idx_stream[idx_gauges], stream_gauges_df$stream_head, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot stream depth for calaveras creek to niles
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_niles_stream_depth.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_niles_df$layer)
plot(idx_stream, cal_to_niles_df$stream_depth, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Depth (ft)", main="Stream depth: Calaveras Creek to Niles")
points(idx_stream[idx_gauges], stream_gauges_df$stream_depth, col="red", pch=1, lwd=4)
grid()
dev.off()



# plot streambed K for calaveras creek to niles
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_niles_streambed_k.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_niles_df$layer)
plot(idx_stream, cal_to_niles_df$streambed_k, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Depth (ft)", main="Streambed K: Calaveras Creek to Niles")
points(idx_stream[idx_gauges], stream_gauges_df$streambed_k, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot streambed gradient for calaveras creek to niles
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_niles_streambed_gradient.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_niles_df$layer)
plot(idx_stream, cal_to_niles_df$streambed_gradient, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Streambed gradient", main="Streambed gradient: Calaveras Creek to Niles")
points(idx_stream[idx_gauges], stream_gauges_df$streambed_gradient, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot stream width for calaveras creek to niles
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_niles_stream_width.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_niles_df$layer)
plot(idx_stream, cal_to_niles_df$stream_width, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Stream width (ft)", main="Stream width: Calaveras Creek to Niles")
points(idx_stream[idx_gauges], stream_gauges_df$stream_width, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot stream et for calaveras creek to niles
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_niles_stream_et.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_niles_df$layer)
plot(idx_stream, cal_to_niles_df$stream_et, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Stream ET (ft)", main="Stream ET: Calaveras Creek to Niles")
points(idx_stream[idx_gauges], stream_gauges_df$stream_et, col="red", pch=1, lwd=4)
grid()
dev.off()



# plot direct precip for calaveras creek to niles
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_niles_direct_precip.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_niles_df$layer)
plot(idx_stream, cal_to_niles_df$direct_precip, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Direct precip. (ft)", main="Direct precip: Calaveras Creek to Niles")
points(idx_stream[idx_gauges], stream_gauges_df$direct_precip, col="red", pch=1, lwd=4)
grid()
dev.off()










#---- Plot: Calaveras Creek to Arroyo de la Laguna ---------------------------------------------------------------------#


# prep for plotting stream gauges
idx_gauges <- which(cal_to_arroyolaguna_df$stream_gauges == 1)
stream_gauges_df <- filter(cal_to_arroyolaguna_df, stream_gauges == 1)


# plot reach flows for calaveras creek to arroyo de la laguna
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_arroyolaguna_overland_runoff.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_arroyolaguna_df$layer)
plot(idx_stream, cal_to_arroyolaguna_df$overland_runoff, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Flow (cfs)", main="Overland runoff: Calaveras Creek to Arroyo Hondo")
points(idx_stream[idx_gauges], stream_gauges_df$overland_runoff, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot flow to aquifer for calaveras creek to arroyo de la laguna
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_arroyolaguna_flow_to_aquifer.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_arroyolaguna_df$layer)
plot(idx_stream, cal_to_arroyolaguna_df$flow_to_aquifer, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Flow (cfs)", main="Flow to aquifer: Calaveras Creek to Arroyo de la Laguna")
points(idx_stream[idx_gauges], stream_gauges_df$flow_to_aquifer, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot flow out of reach for calaveras creek to arroyo de la laguna
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_arroyolaguna_flow_out_of_reach.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_arroyolaguna_df$layer)
plot(idx_stream, cal_to_arroyolaguna_df$flow_out_of_reach, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Flow (cfs)", main="Flow out of reach: Calaveras Creek to Arroyo de la Laguna")
points(idx_stream[idx_gauges], stream_gauges_df$flow_out_of_reach, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot flow into reach for calaveras creek to arroyo de la laguna
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_arroyolaguna_flow_into_reach.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_arroyolaguna_df$layer)
plot(idx_stream, cal_to_arroyolaguna_df$flow_into_reach, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Flow (cfs)", main="Flow into reach: Calaveras Creek to Arroyo de la Laguna")
points(idx_stream[idx_gauges], stream_gauges_df$flow_into_reach, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot stream heads for calaveras creek to arroyo de la laguna
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_arroyolaguna_stream_head.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_arroyolaguna_df$layer)
plot(idx_stream, cal_to_arroyolaguna_df$stream_head, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Elevation (ft)", main="Stream head: Calaveras Creek to Arroyo de la Laguna")
points(idx_stream[idx_gauges], stream_gauges_df$stream_head, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot stream depth for calaveras creek to arroyo de la laguna
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_arroyolaguna_stream_depth.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_arroyolaguna_df$layer)
plot(idx_stream, cal_to_arroyolaguna_df$stream_depth, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Depth (ft)", main="Stream depth: Calaveras Creek to Arroyo de la Laguna")
points(idx_stream[idx_gauges], stream_gauges_df$stream_depth, col="red", pch=1, lwd=4)
grid()
dev.off()



# plot streambed K for calaveras creek to arroyo de la laguna
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_arroyolaguna_streambed_k.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_arroyolaguna_df$layer)
plot(idx_stream, cal_to_arroyolaguna_df$streambed_k, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Depth (ft)", main="Streambed K: Calaveras Creek to Arroyo de la Laguna")
points(idx_stream[idx_gauges], stream_gauges_df$streambed_k, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot streambed gradient for calaveras creek to arroyo de la laguna
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_arroyolaguna_streambed_gradient.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_arroyolaguna_df$layer)
plot(idx_stream, cal_to_arroyolaguna_df$streambed_gradient, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Streambed gradient", main="Streambed gradient: Calaveras Creek to Arroyo de la Laguna")
points(idx_stream[idx_gauges], stream_gauges_df$streambed_gradient, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot stream width for calaveras creek to arroyo de la laguna
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_arroyolaguna_stream_width.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_arroyolaguna_df$layer)
plot(idx_stream, cal_to_arroyolaguna_df$stream_width, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Stream width (ft)", main="Stream width: Calaveras Creek to Arroyo de la Laguna")
points(idx_stream[idx_gauges], stream_gauges_df$stream_width, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot stream et for calaveras creek to arroyo de la laguna
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_arroyolaguna_stream_et.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_arroyolaguna_df$layer)
plot(idx_stream, cal_to_arroyolaguna_df$stream_et, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Stream ET (ft)", main="Stream ET: Calaveras Creek to Arroyo de la Laguna")
points(idx_stream[idx_gauges], stream_gauges_df$stream_et, col="red", pch=1, lwd=4)
grid()
dev.off()


# plot direct precip for calaveras creek to arroyo de la laguna
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/calav_ck_to_arroyolaguna_direct_precip.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(cal_to_arroyolaguna_df$layer)
plot(idx_stream, cal_to_arroyolaguna_df$direct_precip, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Direct precip. (ft)", main="Direct precip: Calaveras Creek to Arroyo de la Laguna")
points(idx_stream[idx_gauges], stream_gauges_df$direct_precip, col="red", pch=1, lwd=4)
grid()
dev.off()








#---- Plot: segment 247 ---------------------------------------------------------------------#



# iseg: 247
iseg_247 <- 247

# add column for stream index
idx_stream <- 1:length(cal_to_arroyolaguna_df$layer)
cal_to_arroyolaguna_df$idx_stream <- idx_stream

# iseg 247: filter by iseg, order by iseg and ireach
iseg_247_df <- cal_to_arroyolaguna_df %>%
  filter(., iseg %in% iseg_247)
iseg_247 <- as.integer(iseg_247)
ordered_iseg <- iseg_247_df$iseg[order(match(iseg_247_df$iseg, iseg_247))]
iseg_247_df <- iseg_247_df[order(match(iseg_247_df$iseg, ordered_iseg), iseg_247_df$ireach), ]



# # prep for plotting stream gauges
# idx_gauges <- which(iseg_247_df$stream_gauges == 1)
# stream_gauges_df <- filter(iseg_247_df, stream_gauges == 1)


# plot flow into reach for iseg 247
filename <- "./gsflow/output/modflow/subbasin_runoff/sfr_streams_plots/iseg_247_flow_into_reach.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(iseg_247_df$layer)
plot(iseg_247_df$idx_stream, iseg_247_df$flow_into_reach, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Flow (cfd)", main="Flow into reach: ISEG 247")
#points(idx_stream[idx_gauges], iseg_247_df$flow_into_reach, col="red", pch=1, lwd=4)
grid()
dev.off()