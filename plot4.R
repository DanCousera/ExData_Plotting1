library(tidyverse)
library(lubridate)



fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileName <- "exdata_data_household_power_consumption.zip"
datasetFileName <- "household_power_consumption.txt"

#download file and unzip if it does not exist
if(!file.exists(fileName)){
        download.file(fileUrl,fileName, mode = "wb", method="curl")
        
        unzip(fileName)
}

#read data into table
dataset <- read.table(datasetFileName, sep = ";", header = TRUE, stringsAsFactors= F)

#set column data types
dataset$Date <-  dmy(dataset$Date)
#dataset$Time <- as.POSIXct(paste(dataset$Date,dataset$Time), format="%Y-%m-%d %H:%M:%S")
dataset$Time<-ymd_hms(paste(dataset$Date,dataset$Time))


dataset$Global_active_power <- as.numeric(dataset$Global_active_power)
dataset$Voltage<- as.numeric(dataset$Voltage)
dataset$Sub_metering_1<- as.numeric(dataset$Sub_metering_1)
dataset$Sub_metering_2<- as.numeric(dataset$Sub_metering_2)
dataset$Sub_metering_3<- as.numeric(dataset$Sub_metering_3)

#drop NAs
dataset <- drop_na(dataset)

#create start and end date for filtering
startDate <- ymd("2007-02-01")
endDate <- ymd("2007-02-02")

#filter data set by start and enddate
dataset <- filter(dataset,Date >=startDate & Date <=endDate)

#create png with resolution of 480 by 480 pixels
png(file = "plot4.png", width = 480, height = 480, units = "px",bg = "white",  res = NA)
par(mfrow=c(2,2))
with(dataset, {
        plot(x=Time, y=Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
        plot(x=Time, y=Voltage, type="l", xlab="datetime", ylab="Voltage")
        with(dataset, plot(x=Time, y=Sub_metering_1, type="l", ylab="Energy sub metering",xlab=""))
        with(dataset, lines(x=Time, y=Sub_metering_2, type="l", col="Red"))
        with(dataset, lines(x=Time, y=Sub_metering_3, type="l", col="Blue"))
        legend("topright", lty=1, col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n")
        plot(x=Time, y=Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")
})
dev.off()
