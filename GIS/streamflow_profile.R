#---- Goal ---------------------------------------------------------------------#

# Create stream profile in the lower watershed




#---- Settings ---------------------------------------------------------------------#


# install packages
install.packages(tidyverse)

# load packages
library("tidyverse")


# set working directory
setwd("C:/git_repos/alameda/pestPrep/GIS")




#---- Read in ---------------------------------------------------------------------#

# read in alameda data frame
alam_df <- read.csv(file="./alam_df.csv")





#---- Extract ISEG ---------------------------------------------------------------------#

# iseg: calaveras creek to niles
cal_to_niles <- c(368, 351, 349, 340, 337, 336, 313, 308, 301, 299, 282, 271, 260, 255, 
                  247, 215, 196, 187, 175, 161, 152, 149, 143, 139, 124, 123, 117, 111,
                  110, 134, 109, 108, 112, 126, 129, 132, 144)

# iseg: alameda creek below acdd to alameda creek below calaveras creek
alam_ck_below_acdd_to_below_cal_ck <- c(384, 376, 375, 377, 374, 372, 371, 360, 358, 357, 356, 359, 351)

# iseg: san antonio creek to confluence with alameda creek
san_antonio_ck_to_confluence <- c(182, 179, 194, 187)


# calaveras creek to niles: filter by iseg, order by iseg and ireach
cal_to_niles_df <- alam_df %>%
  filter(., iseg %in% cal_to_niles)
cal_to_niles <- as.integer(cal_to_niles)
ordered_iseg <- cal_to_niles_df$iseg[order(match(cal_to_niles_df$iseg, cal_to_niles))]
cal_to_niles_df <- cal_to_niles_df[order(match(cal_to_niles_df$iseg, ordered_iseg), cal_to_niles_df$ireach), ]


# alameda creek below acdd to alameda creek below calaveras creek: filter by iseg, order by iseg and ireach
alam_ck_below_acdd_to_below_cal_ck_df <- alam_df %>%
  filter(., iseg %in% alam_ck_below_acdd_to_below_cal_ck)
alam_ck_below_acdd_to_below_cal_ck <- as.integer(alam_ck_below_acdd_to_below_cal_ck)
ordered_iseg <- alam_ck_below_acdd_to_below_cal_ck_df$iseg[order(match(alam_ck_below_acdd_to_below_cal_ck_df$iseg, alam_ck_below_acdd_to_below_cal_ck))]
alam_ck_below_acdd_to_below_cal_ck_df <- alam_ck_below_acdd_to_below_cal_ck_df[order(match(alam_ck_below_acdd_to_below_cal_ck_df$iseg, ordered_iseg), alam_ck_below_acdd_to_below_cal_ck_df$ireach), ]


# san antonio creek to confluence with alameda creek: filter by iseg, order by iseg and ireach
san_antonio_ck_to_confluence_df <- alam_df %>%
  filter(., iseg %in% san_antonio_ck_to_confluence)
san_antonio_ck_to_confluence <- as.integer(san_antonio_ck_to_confluence)
ordered_iseg <- san_antonio_ck_to_confluence_df$iseg[order(match(san_antonio_ck_to_confluence_df$iseg, san_antonio_ck_to_confluence))]
san_antonio_ck_to_confluence_df <- san_antonio_ck_to_confluence_df[order(match(san_antonio_ck_to_confluence_df$iseg, ordered_iseg), san_antonio_ck_to_confluence_df$ireach), ]







#---- Plot ---------------------------------------------------------------------#



# plot streamflow profile for calaveras creek to niles
filename <- "./streams/stream_profile_calav_ck_to_niles.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
stream_gauge_idx <- which(!is.na(cal_to_niles_df$stream_gauge))
idx_stream <- 1:length(cal_to_niles_df$hru_id)
plot(idx_stream, cal_to_niles_df$strtop, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Stream top elevation (ft.)", main="Streamflow profile: Calaveras Creek to Niles")
lines(idx_stream, cal_to_niles_df$dis_top_lyr_01, type="l", col="red", lwd=2, lty=2)
lines(idx_stream, cal_to_niles_df$dis_bttm_lyr_01, type="l", col="blue", lwd=2, lty=2)
lines(idx_stream, cal_to_niles_df$dis_bttm_lyr_02, type="l", col="green", lwd=2, lty=2)
lines(idx_stream, cal_to_niles_df$dis_bttm_lyr_03, type="l", col="purple", lwd=2, lty=2)
lines(idx_stream, cal_to_niles_df$dis_bttm_lyr_04, type="l", col="orange", lwd=2, lty=2)
points(idx_stream[stream_gauge_idx], cal_to_niles_df$strtop[stream_gauge_idx], pch=1, col="pink", cex=2, lwd=4)
legend(x="topright", legend = c("Stream gauge", "Stream top", "Top of layer 1", "Bottom of layer 1", 
                                "Top of layer 2", "Top of layer 3", "Top of layer 4"),
       col=c("pink", "black", "red", "blue", "green", "purple", "orange"), lwd=c(4,4,2,2,2,2,2), lty=c(NA,1,2,2,2,2,2), 
       bty="n", pch=c(1,NA,NA,NA,NA,NA,NA), pt.cex=c(2,NA,NA,NA,NA,NA,NA))
grid()
dev.off()


# plot streamflow profile for alameda creek below acdd to alameda creek below calaveras creek
filename <- "./streams/stream_profile_alam_ck_below_acdd_to_below_cal_ck.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
stream_gauge_idx <- which(!is.na(alam_ck_below_acdd_to_below_cal_ck_df$stream_gauge))
idx_stream <- 1:length(alam_ck_below_acdd_to_below_cal_ck_df$hru_id)
plot(idx_stream, alam_ck_below_acdd_to_below_cal_ck_df$strtop, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Stream top elevation (ft.)", main="Streamflow profile: Alameda Creek below ACDD to Alameda Creek below Calaveras Creek")
lines(idx_stream, alam_ck_below_acdd_to_below_cal_ck_df$dis_top_lyr_01, type="l", col="red", lwd=2, lty=2)
lines(idx_stream, alam_ck_below_acdd_to_below_cal_ck_df$dis_bttm_lyr_01, type="l", col="blue", lwd=2, lty=2)
lines(idx_stream, alam_ck_below_acdd_to_below_cal_ck_df$dis_bttm_lyr_02, type="l", col="green", lwd=2, lty=2)
lines(idx_stream, alam_ck_below_acdd_to_below_cal_ck_df$dis_bttm_lyr_03, type="l", col="purple", lwd=2, lty=2)
lines(idx_stream, alam_ck_below_acdd_to_below_cal_ck_df$dis_bttm_lyr_04, type="l", col="orange", lwd=2, lty=2)
points(idx_stream[stream_gauge_idx], alam_ck_below_acdd_to_below_cal_ck_df$strtop[stream_gauge_idx], pch=1, col="pink", cex=2, lwd=4)
legend(x="topright", legend = c("Stream gauge", "Stream top", "Top of layer 1", "Bottom of layer 1", 
                                "Top of layer 2", "Top of layer 3", "Top of layer 4"),
       col=c("pink", "black", "red", "blue", "green", "purple", "orange"), lwd=c(4,4,2,2,2,2,2), lty=c(NA,1,2,2,2,2,2), 
       bty="n", pch=c(1,NA,NA,NA,NA,NA,NA), pt.cex=c(2,NA,NA,NA,NA,NA,NA))
grid()
dev.off()





# plot streamflow profile for san antonio creek to confluence with alameda creek
filename <- "./streams/stream_profile_san_antonio_ck_to_confluence.jpg"
jpeg(filename=filename, width = 12, height = 8, units = "in", quality = 75, res = 300)
idx_stream <- 1:length(san_antonio_ck_to_confluence_df$hru_id)
plot(idx_stream, san_antonio_ck_to_confluence_df$strtop, type="l", col="black", lwd=4, xlab="Streamflow index (from upstream to downstream)",
     ylab="Stream top elevation (ft.)", main = "Streamflow profile: San Antonio Creek to confluence with Alameda Creek")
lines(idx_stream, san_antonio_ck_to_confluence_df$dis_top_lyr_01, type="l", col="red", lwd=2, lty=2)
lines(idx_stream, san_antonio_ck_to_confluence_df$dis_bttm_lyr_01, type="l", col="blue", lwd=2, lty=2)
lines(idx_stream, san_antonio_ck_to_confluence_df$dis_bttm_lyr_02, type="l", col="green", lwd=2, lty=2)
lines(idx_stream, san_antonio_ck_to_confluence_df$dis_bttm_lyr_03, type="l", col="purple", lwd=2, lty=2)
lines(idx_stream, san_antonio_ck_to_confluence_df$dis_bttm_lyr_04, type="l", col="orange", lwd=2, lty=2)
points(idx_stream[stream_gauge_idx], san_antonio_ck_to_confluence_df$strtop[stream_gauge_idx], pch=1, col="pink", cex=2, lwd=4)
legend(x="topright", legend = c("Stream gauge", "Stream top", "Top of layer 1", "Bottom of layer 1", 
                                "Top of layer 2", "Top of layer 3", "Top of layer 4"),
       col=c("pink", "black", "red", "blue", "green", "purple", "orange"), lwd=c(4,4,2,2,2,2,2), lty=c(NA,1,2,2,2,2,2), 
       bty="n", pch=c(1,NA,NA,NA,NA,NA,NA), pt.cex=c(2,NA,NA,NA,NA,NA,NA))
grid()
dev.off()





#---- Extract table of all pond spillways ---------------------------------------------------------------------#

# filter to get spillway segments
pond_spillways <- alam_df %>% 
  filter(., iupseg < 0)

# order by iseg and then ireach
pond_spillways <- pond_spillways[order(pond_spillways$iseg, pond_spillways$ireach), ]

# export table
write.csv(pond_spillways, "./streams/pond_spillways.csv", row.names=FALSE)




