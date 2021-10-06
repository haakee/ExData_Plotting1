library(dplyr)
library(httr)

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

global_active_power <- as.numeric(df$Global_active_power)
global_active_power <- na.omit(global_active_power)

output_file = "plot1.png"
png(file=output_file)

# Create the histogram
resize_factor <- 0.75
hist(global_active_power,
     cex.axis=resize_factor,
     cex.lab=resize_factor,
     cex.main=resize_factor,
     col="red",
     main="Global Active Power",
     xlab="Global Active Power (kilowatts)",
     ylim=c(0,1200))

# Create the .png file
dev.off()