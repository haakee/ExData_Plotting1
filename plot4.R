library(dplyr)
library(httr)
library(lubridate)

# Pull and extract the data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip_file <- "household_power_consumption.zip"
download.file(url, zip_file)
unzip(zip_file)

data_file <- "household_power_consumption.txt"
df <- read.table(data_file, header=TRUE, sep=";")
df$Date <- as.Date(df$Date, format="%d/%m/%Y")
# Subset the data using only data from Feb 1 and 2, 2007
df <- subset(df,
             df$Date == as.Date("2007-02-01") | df$Date == as.Date("2007-02-02"))

# Clean relevant columns
df[, c(3, 4, 7, 8, 9)] <- sapply(df[, c(3, 4, 7, 8, 9)], as.numeric)

# Combine date/time
t <- paste(df$Date, df$Time, sep=" ")
t <- ymd_hms(t)

output_file = "plot4.png"
png(file=output_file)

# Create the plots
par(mfrow=c(2, 2))

# Plot 1
plot(t,
     df$Global_active_power,
     type="l",
     xlab=NA,
     ylab="Global Active Power")

# Plot 2
plot(t, df$Voltage, type="l", xlab="datetime", ylab="Voltage")

# Plot 3
colors <- c("black", "red", "blue")
column <- 7
plot(t,
     df[,column],
     col=colors[column-6],
     type="l",
     xlab=NA,
     ylab="Energy sub metering")
for (column in 8:9) {
    lines(t, df[,column], col=colors[column-6], type="l")
}

legend("topright", bty="n", col=colors, legend=names(df[7:9]), lty=1)

# Plot 4
plot(t, df$Global_reactive_power,
     type="l",
     xlab="datetime",
     ylab="Global_reactive_power")

# Create the .png file
dev.off()