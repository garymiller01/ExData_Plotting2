
# Assignment 2 - Plot 3 - Total Annual Emissions by Year and Source Type, Baltimore City

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

# Set Type to Factor variable - specify order for plots

Summary$type <- factor(Summary$type,levels=c("POINT","NONPOINT","ON-ROAD","NON-ROAD"))

# Extract Baltimore data

BaltSummary <- Summary[Summary$fips=="24510",]

# Sum emissions by year and type with melt, dcast

library(reshape2)

AnnualPM25BaltTypeMelt <- melt(BaltSummary,id=c("year","type"),measure.vars="Emissions")
AnnualPM25BaltTypeDF <- dcast(AnnualPM25BaltTypeMelt,year + type ~ variable,sum)

# Create and write plot using ggplot

library(ggplot2)

png(filename="Plot3.png",width=520,height=480)

g <- ggplot(AnnualPM25BaltTypeDF,
            aes(year,Emissions))

p <- g + geom_line(aes(color=type),size=1.5) +
  geom_point(aes(color=type),size=4) +
  facet_grid(type ~ .) + 
  labs(x="Year",y="Total Emissions (tons)") + 
  labs(title=expression("Annual PM"[2.5]*" Emissions, Baltimore City"))

print(p)

dev.off()
