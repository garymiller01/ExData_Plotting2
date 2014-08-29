

# Assignment 2 - Plot 5 - Motor Vehicle Emissions, Baltimore City

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

# Set Type to Factor variable - specify order for plots

Summary$type <- factor(Summary$type,levels=c("POINT","NONPOINT","ON-ROAD","NON-ROAD"))


# Extract Baltimore data

BaltSummary <- Summary[Summary$fips=="24510",]

# subset SourceCode File by my criteria for motor vehicle-related emission source

MVCodesData <- SourceCodes[(SourceCodes$Data.Category=="Onroad" |
                          (SourceCodes$Data.Category=="Nonroad" & 
                              SourceCodes$SCC.Level.Three == "Recreational Equipment") |
                          (SourceCodes$Data.Category=="Nonroad" & 
                              SourceCodes$SCC.Level.Two %in% c("Aircraft",
                                 "Marine Vessels, Commercial","Pleasure Craft",
                                 "Marine Vessels, Military"))),]

# Subset NEI data by motor vehicle-related SCCs

MVBaltSummary <- BaltSummary[BaltSummary$SCC %in% MVCodesData$SCC,]
  
# Sum emissions by year with melt, dcast

library(reshape2)

AnnualPM25MVBaltMelt <- melt(MVBaltSummary,id=c("year"),measure.vars="Emissions")
AnnualPM25MVBaltDF <- dcast(AnnualPM25MVBaltMelt,year ~ variable,sum)

# Create and write plot

library(ggplot2)

png(filename="Plot5.png",height=480,width=520)

g5 <- ggplot(AnnualPM25MVBaltDF,aes(year,Emissions))

p5 <- g5 + geom_line(color="black",size=0.5) + 
   geom_point(color="blue",size=3) + 
   labs(x="Year",y="Total Emissions (tons)") +
   labs(title=expression("Annual Motor Vehicle PM"[2.5]*" Emissions, Baltimore City"))  

print(p5)

dev.off()