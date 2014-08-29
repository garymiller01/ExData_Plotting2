
# Assignment 2 - Plot 4 - Total Annual Coal Emissions by Year, US

# Set working directory

setwd("F:/Coursera/ExploratoryData")

# download Data Files

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

# Identify coal-related EI Sectors

CoalEISectors <- unique(grep("Coal",SourceCodes$EI.Sector,value=TRUE))

# Subset SourceCode file by Coal EI Sector 

CoalCodesData <- SourceCodes[SourceCodes$EI.Sector %in% CoalEISectors,]

# Generate Vector of coal-related SCCs

CoalCodes <- unique(CoalCodesData$SCC)

# Subset NEI data by coal-related SCC

CoalSummary <- Summary[Summary$SCC %in% CoalCodes,]

# Sum emissions by year with melt, dcast

library(reshape2)

AnnualPM25USCoalMelt <- melt(CoalSummary,id=c("year"),measure.vars="Emissions")
AnnualPM25USCoalDF <- dcast(AnnualPM25USCoalMelt,year ~ variable,sum)

# Create and write plot using ggplot

library(ggplot2)

g <- ggplot(AnnualPM25USCoalDF,aes(year,Emissions))

p <- g + geom_line(color="blue",size=0.5) + 
            geom_point(color="black",size=3) + 
            labs(x="Year",y="Total Emissions (tons)") +
            labs(title=expression("Annual Coal Sector PM"[2.5]*" Emissions, US"))  

png(filename="Plot4.png",width=520,height=480)

print(p)

dev.off()
