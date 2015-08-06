#
# 0.0 read the data
#
dat=read.table(gzfile("/home/psenin/git/data/TAIS_MT080_type_1.csv.gz"),
                sep=";",header=F,skip=1,as.is=T)
#
# 0.1 fix the names
#
names(dat) <- c("MMSI","SOURCE","TIMESTAMP","DELIVERY_TIME","TIMELINESS",
                 "LATITUDE","LONGITUDE","SOG","COG","TRUE_HEADING","REPEAT_INDICATOR",
                 "MANEUVER_INDICATOR","NAV_STATUS","ROT","POS_ACCURACY")
#
# check the data structure
#
str(dat)
#
# loading data manipulation and map plotting packages
#
# http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf
require(dplyr)
require(data.table)
require(ggmap)
#
# 1.0 arrange the table by the frequency of sampled points
#
vesselFreq=arrange(data.frame(table(dat$MMSI)), desc(Freq))
vesselFreq$Var1=as.integer(as.character(vesselFreq$Var1))
setnames(vesselFreq, c("MMSI","Points"))
str(vesselFreq)
#
# 2.0 subset 10 vessels with the most points
#
vesselData = dat[dat$MMSI %in% vesselFreq$MMSI[1:10],]
vesselData$MMSI = factor(vesselData$MMSI)
#
# 3.0 testthat map can be downloaded
#
sea <- get_map(location = "Alboran Sea", maptype = "hybrid", zoom=8)
ggmap(sea)
#
# plot subset trajectories
#
trajectoryMap <- ggmap(sea, base_layer = ggplot(
                    aes(y = LATITUDE, x = LONGITUDE, color=MMSI), data = vesselData), 
                    extent = "panel", legend="right")

trajectoryMap + geom_point(size=1) + guides(colour = guide_legend(override.aes = list(size=5)))
