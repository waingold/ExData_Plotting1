# This file should be sourced with chdir=TRUE so that commmon.R can be found.
source("common.R")
png("plot4.png")
par(mfcol = c(2, 2))
plot2(gapLabel)
plot3("n")
plot4.topright()
plot4.bottomright()
dev.off()
