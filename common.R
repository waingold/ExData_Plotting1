# Download the compressed dataset to a temporary location.
zipFile <- "household_power_consumption.zip"
if (!file.exists(zipFile)) {
    download.file(paste0("https://d396qusza40orc.cloudfront.net/exdata/data/", zipFile), destfile = zipFile)
}

# Decompress the dataset to another temporary location.
expansionDir <- gsub(".zip$", "", basename(zipFile))
dataFile <- paste(expansionDir, "household_power_consumption.txt", sep = "/")
if (!file.exists(dataFile)) {
    unzip(zipFile, exdir = expansionDir)
}

# Read, filter, & clean the data frame.
dataFrame <- read.table(dataFile, header = T, sep = ";", as.is = T, na.strings = "?")
dataFrame <- subset(dataFrame, grepl("^(1|2)/2/2007$", Date))
dataFrame <- transform(dataFrame, DateTime = strptime(paste(Date, Time, " "), "%d/%m/%Y %H:%M:%S"))

# Initialize some shared variables.
gapLabel <- "Global Active Power"
gapLabelKW <- paste(gapLabel, " (kilowatts)")

# Define functions for producing the plots on the current graphics device.

plot1 <- function() {
    with(dataFrame, hist(Global_active_power, main = gapLabel, xlab = gapLabelKW, col = "red"))
}

plot2 <- function(ylab = gapLabelKW) {
    with(dataFrame, plot(DateTime, Global_active_power, type="l", xlab = NA, ylab = ylab))
}

plot3 <- function(legendBty = "o") {
    with(dataFrame, { 
        plot(DateTime, Sub_metering_1, type = "n", xlab = NA, ylab = "Energy sub metering")
        colors <- c("black", "red", "blue")
        series <- grep("^Sub_metering_\\d+$", names(dataFrame), value = T)
        for (i in seq_along(series)) {
            lines(DateTime, dataFrame[,series[i]], type = "l", col = colors[i])
        }
        legend("topright", legend = series, col = colors, lty = "solid", bty = legendBty)
    })
}

plot4.topright <- function() {
    with(dataFrame, plot(DateTime, Voltage, type="l", xlab = "datetime"))
}

plot4.bottomright <- function() {
    with(dataFrame, plot(DateTime, Global_reactive_power, type="l", xlab = "datetime"))    
}
