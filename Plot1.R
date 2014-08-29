
# Assignment 2 - Plot 1 - Total Annual Emissions by Year (US)

# Set working directory

setwd("F:/Coursera/ExploratoryData")

# Download Data Files

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL,destfile="./project2/Project2Data.zip")
unzip("./project2/Project2Data.zip",exdir="./project2")

# Record download date

dateDownloaded <- date()

# Read in data files

Summary <- readRDS("./project2/summarySCC_PM25.rds")
SourceCodes <- readRDS("./project2/Source_Classification_Code.rds")

# Subset to include only years 1999,2002,2005,2008

Summary <- Summary[Summary$year %in% c("1999","2002","2005","2008"),]

# Sum emissions by year with melt, dcast

library(reshape2)

AnnualPM25USMelt <- melt(Summary,id="year",measure.vars="Emissions")
AnnualPM25USDF <- dcast(AnnualPM25USMelt,year ~ variable,sum)

# Create and write plot to device 

png(filename="Plot1.png",width=480,height=480)

plot(AnnualPM25USDF$year,AnnualPM25USDF$Emissions,type="l",
     main=expression("Annual PM"[2.5]*" Emissions in the United States"),
     xlab="Year",ylab="Total Emissions (tons)",
     xaxt="n")
points(AnnualPM25USDF$year,AnnualPM25USDF$Emissions,pch=19,col="blue")
axis(1,at=AnnualPM25USDF$year,labels=AnnualPM25USDF$year)

dev.off()