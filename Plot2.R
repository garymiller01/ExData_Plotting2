
# Assignment 2 - Plot 2 - Total Annual Emissions by Year, Baltimore City

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

# Subset to include only data from 1999,2002,2005,2008

Summary <- Summary[Summary$year %in% c("1999","2002","2005","2008"),]

# Extract Baltimore data

BaltSummary <- Summary[Summary$fips=="24510",]

# Sum emissions by year with melt, dcast

library(reshape2)

AnnualPM25BaltMelt <- melt(BaltSummary,id="year",measure.vars="Emissions")
AnnualPM25BaltDF <- dcast(AnnualPM25BaltMelt,year ~ variable,sum)

# Create and write plot using Base

png(filename="Plot2.png",width=480,height=480)

plot(AnnualPM25BaltDF$year,AnnualPM25BaltDF$Emissions,type="l",
     main=expression("Annual PM"[2.5]*" Emissions in Baltimore City"),
     xlab="Year",ylab="Total Emissions (tons)",
     xaxt="n")
points(AnnualPM25BaltDF$year,AnnualPM25BaltDF$Emissions,pch=19,col="blue")
axis(1,at=AnnualPM25BaltDF$year,labels=AnnualPM25BaltDF$year)

dev.off()