# script to create plot1 graphic

# clear the memory first
rm(list=ls())

# Read in the first 70,000 lines of the file
fileName  <-  "household_power_consumption.txt"
n  <- 70000
f = readLines(fileName , n )

# Save headers
column.names <- f[1]

# Select the lines for the two days
set1.2.2007 <- grep("^1/2/2007",f, value=T)
set2.2.2007 <- grep("^2/2/2007",f, value=T)
rm("f")

# Merge column names and two days into single file
projectds <- c(column.names)
projectds  <- append(projectds, set1.2.2007)
projectds  <- append(projectds, set2.2.2007)

rm("set1.2.2007")
rm("set2.2.2007")

# Write the merged file to disk and load it back as a data frame
write(projectds, file="projectds.txt")
df <- read.csv("projectds.txt", sep =";",header = T)

rm("projectds")

# Define a helper function to convert dates
convert.date <- function(ds) {
    
    for (i in 1:nrow(ds)) {
        dte <- strptime((ds[i,]$DateTime), 
                        format="%d/%m/%Y %H:%M:%S")
        ds[i,]$RDate <- dte
    }
    ds  # return tthe data set
}

# Process file to convert date time columns
library(dplyr)
df <- tbl_df(df)
df <- mutate(df, DateTime = paste(Date, Time))
df <- transform(df, RDate = rep(as.POSIXlt ("1/1/2000 00:01:00", format="%d/%m/%Y %H:%M:%S"), nrow(df)))

df2 <- convert.date(df)

rm("df")

# Generate plot1 png file
png(filename= "plot1.png", width = 480, height = 480)
hist(df2$Global_active_power,
     main="Global Active Power",
     xlab="Global Active Power (kilowatts)", col="red")
dev.off()


