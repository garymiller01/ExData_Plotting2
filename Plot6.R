
# Assignment 2 - Plot 6 - Baltimore vs. LA

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

# Extract City data

CitySummary <- Summary[Summary$fips %in% c("24510","06037"),]

# Add city name column

CitySummary$CityName <- ifelse(CitySummary$fips=="24510",
                               "Baltimore","Los Angeles")

# Set City Name to Factor variable - specify order for plots

CitySummary$CityName <- factor(CitySummary$CityName,levels=c("Los Angeles","Baltimore"))

# subset SourceCode File by my criteria for motor vehicle-related emission source

MVCodesData <- SourceCodes[(SourceCodes$Data.Category=="Onroad" |
                              (SourceCodes$Data.Category=="Nonroad" & 
                                 SourceCodes$SCC.Level.Three == "Recreational Equipment") |
                              (SourceCodes$Data.Category=="Nonroad" & 
                                 SourceCodes$SCC.Level.Two %in% c("Aircraft",
                                                                  "Marine Vessels, Commercial","Pleasure Craft",
                                                                  "Marine Vessels, Military"))),]

# Subset NEI data by motor vehicle-related SCCs

MVCitySummary <- CitySummary[CitySummary$SCC %in% MVCodesData$SCC,]

# Sum emissions by year and city with melt, dcast

library(reshape2)

AnnualPM25MVCityMelt <- melt(MVCitySummary,id=c("year","CityName"),measure.vars="Emissions")
AnnualPM25MVCityDF <- dcast(AnnualPM25MVCityMelt,year + CityName ~ variable,sum)

# Create and write plot

library(ggplot2)

png(filename="Plot6.png",height=480,width=520)

g6 <- ggplot(AnnualPM25MVCityDF,aes(year,Emissions))

p6 <- g6 + geom_line(aes(color=CityName),size=1.5) + 
  geom_point(aes(color=CityName),size=4) +
  geom_text(aes(label=round(Emissions,digits=0)),hjust=0.5,vjust=-1) +
  facet_grid(CityName ~ .) +
  labs(x="Year",y="Total Emissions (tons)") +
  labs(title=expression("Annual Motor Vehicle PM"[2.5]*" Emissions, Baltimore vs. Los Angeles")) +
  guides(color=FALSE)

print(p6)

dev.off()


