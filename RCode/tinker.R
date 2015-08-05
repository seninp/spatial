dat=read.table(gzfile("/home/psenin/git/data/TAIS_MT080_type_1.csv.gz"),
                sep=";",header=F,skip=1,as.is=T)
names(dat) <- c("MMSI","SOURCE","TIMESTAMP","DELIVERY_TIME","TIMELINESS",
                 "LATITUDE","LONGITUDE","SOG","COG","TRUE_HEADING","REPEAT_INDICATOR",
                 "MANEUVER_INDICATOR","NAV_STATUS","ROT","POS_ACCURACY")
str(dat)
# http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf
require(dplyr)
require(ggmap)

vesselFreq=arrange(data.frame(table(dat$MMSI)), desc(Freq))
vesselFreq$Var1=as.integer(as.character(vesselFreq$Var1))
str(vesselFreq)

vesselData = dat[dat$MMSI %in% (vesselFreq[1:8,]$Var1),]
vesselData$MMSI = factor(vesselData$MMSI)

sea <- get_map(location = "Alboran Sea", maptype = "hybrid", zoom=8)
ggmap(sea)


trajectoryMap <- ggmap(sea, 
                base_layer = ggplot(
                  aes(y = LATITUDE, x = LONGITUDE, color=MMSI),
                  data = vesselData), extent = "panel", legend="right")
trajectoryMap + geom_point(size=1)
