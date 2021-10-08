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

# Clean sub metering columns
df[,7:9] <- sapply(df[,7:9], as.numeric)

# Combine date/time
t <- paste(df$Date, df$Time, sep=" ")
t <- ymd_hms(t)

output_file = "plot3.png"
png(file=output_file)

# Create the plot
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

legend("topright", col=colors, legend=names(df[7:9]), lty=1)

# Create the .png file
dev.off()