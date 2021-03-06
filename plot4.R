#
#  plot4.R
#

# Data set : Individual household electric power consumption Data Set 
# https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption

# This archive contains 2075259 measurements gathered in a house located in Sceaux (7km of Paris, France)
# between December 2006 and November 2010 (47 months).  

# Timezone is set to "Europe/Paris"

# Notes: 
# 1.(global_active_power*1000/60 - sub_metering_1 - sub_metering_2 - sub_metering_3) represents the active energy consumed 
#   every minute (in watt hour) in the household by electrical equipment not measured in sub-meterings 1, 2 and 3. 
# 2.The dataset contains some missing values in the measurements (nearly 1,25% of the rows). 
#   All calendar timestamps are present in the dataset but for some timestamps, the measurement values are missing:
#   a missing value is represented by the absence of value between two consecutive semi-colon attribute separators. 


# Attribute Information:

# 1.date: Date in format dd/mm/yyyy 
# 2.time: time in format hh:mm:ss 
# 3.global_active_power: household global minute-averaged active power (in kilowatt) 
# 4.global_reactive_power: household global minute-averaged reactive power (in kilowatt) 
# 5.voltage: minute-averaged voltage (in volt) 
# 6.global_intensity: household global minute-averaged current intensity (in ampere) 
# 7.sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). 
#   It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave 
#   (hot plates are not electric but gas powered). 
# 8.sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy).
#   It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light. 
# 9.sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). 
#   It corresponds to an electric water-heater and an air-conditioner.

# Read file (household_power_consumnption.txt) and extract rows for February 1st/2nd, 2007

power_all <- as.data.frame(read.table("household_power_consumption.txt", sep=";", header=TRUE, stringsAsFactors=FALSE))
power <- subset(power_all, Date=="1/2/2007" | Date=="2/2/2007")

# Convert Date/Time to POSIX format in Paris time

power$Date <- paste(power$Date, power$Time, sep=" ")
power$Date <- as.data.frame(strptime(power$Date, "%d/%m/%Y %H:%M:%S", tz="Europe/Paris"))

# Create a new table with coverting all data frame, except Date, to "numeric"

power <- power[,c(1,3,4,5,6,7,8,9)]
colnames(power) <- c("date","active","reactive","voltage","intensity","sub_1","sub_2","sub_3")
power$active <- as.numeric(power$active)
power$reactive <- as.numeric(power$reactive)
power$voltage <- as.numeric(power$voltage)
power$intensity <- as.numeric(power$intensity)
power$sub_1 <- as.numeric(power$sub_1)
power$sub_2 <- as.numeric(power$sub_2)
power$sub_3 <- as.numeric(power$sub_3)


# plotting 4 charts into one page
png("plot4.png", width = 480, height = 480) 
par(mfrow = c(2, 2))

# chart 1 : Time series data (active power) - same as plot 2 with small modification in y-label
plot(power$date, power$active, xlab ="", ylab="Global Active Power", type="l")

# chart 2 : Time series data (voltage) 
plot(power$date, power$voltage, xlab ="datetime", ylab="Voltage", type="l")

# chart 3 : Time series data - Energy sub metering from three sub systems - similar to plot 3 with small modification for a legend box
# set same y-range for three plots
y_limit = max(max(power$sub_1),max(power$sub_2),max(power$sub_3))
# set line colors and texts 
cols <- c("black","red","blue")
labels <- c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
# 3 plots into one chart with par(new=T)
plot(power$date, power$sub_1, type="l", col=cols[1], ann=F, ylim=c(0, y_limit))
par(new=T)
plot(power$date, power$sub_2, type="l", col=cols[2], ann=F, ylim=c(0, y_limit))
par(new=T)
plot(power$date, power$sub_3, type="l", col=cols[3], ylim=c(0, y_limit), xlab="", ylab="Enegry sub metering")
legend("topright", legend=labels, col=cols, lty=1, box.lty=0)

# chart 4 : Time series data - Global reactive power
plot(power$date, power$reactive, xlab ="datetime", ylab="Global_reactive_power", type="l")

dev.off()
