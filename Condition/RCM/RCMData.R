library(openMSE)
library(readxl)
library(dplyr)
library(ggplot2)


# Demo: following the 2020 assessment (ASPIC SCRS/2020/095 & JABBA SCRS/2020/104) using data up to 2018 


# Data 

# Fleets:
# Catch: 
# 1. Chinese Taipei & Korea (LL)
# 2. China, E.C Spain, E.C Portugal, Japan, Philippines, St Vincent & Grenadier, USA, Vanuatu, Honduras, Nei, Cote D'Ivoire, E.U UK, Seychelles, U.K Sta Helena, Angola, Senegal, Trinidad & Tobago (1956 - 1969)
# 3. As 2 (1970 - 1975)
# 4. As 2 (1976 - 2018)
# 5. Brazil, Panama, South Africa, Argentina, Belize, Cambodia, Cuba, Namibia
# 6. 1956 - 1998 Brazil etc
# 7. 1999 - 2018 Brazil etc
# 8. Uruguay
#
# CPUE: (1956 - 2018) 
# Three CPUE series used in 2020 assessment
# 1. Chinese Taipei (LL)
# 2. -
# 3. -
# 4. Japan (LL) 1976 - 2011 # only use up to 2011
# 5. -
# 6. -
# 7. -
# 8. Uruguay (LL)

# readxl::excel_sheets('Data/SALB_2018.xlsx')

RCMData <- new('RCMdata') 

# ----- Catch Data -----
CatchData <- readxl::read_excel('Condition/Data/SALB_2018.xlsx', "Catch")

# Filtering data up to 2018 for demo - this can be removed later
CatchData <- CatchData |> dplyr::filter(Year<=2018)  

CatchTotal <- CatchData |> dplyr::group_by(Year) |> dplyr::summarise(n=sum(Catch))

Year1 <- CatchTotal |> dplyr::filter(n>0) |> dplyr::summarise(Year1=min(Year))

CatchData <- CatchData |> dplyr::filter(Year>=Year1$Year1)

Fleets <- CatchData$Fleet |> unique()
Years <- CatchData$Year |> unique() |> sort()
nFleet <- length(Fleets)
nYears <- length(Years)

RCMData@Chist <- array(1E-8, c(nYears, nFleet), dimnames = list(Year=Years, Fleet=Fleets))

for (fl in Fleets) {
  catchdata <- CatchData |> dplyr::filter(Fleet==fl) 
  abind::afill(RCMData@Chist) <- array(catchdata$Catch, dim=c(length(catchdata$Catch), 1), 
                                       dimnames = list(Year=catchdata$Year, Fleet=unique(catchdata$Fleet))
  )
}

# ---- CPUE Data ----
CPUEData <- readxl::read_excel('Condition/Data/SALB_2018.xlsx', "CPUE")

# Filtering data up to 2018 for demo - this can be removed later
CPUEData <- CPUEData |> dplyr::filter(Year<=2018)

CPUEFleets <- CPUEData$Fleet |> unique()

RCMData@Index <- array(NA, c(nYears, nFleet), dimnames = list(Year=Years, Fleet=Fleets))
RCMData@I_sd <- RCMData@Index
for (fl in CPUEFleets) {
  cpuedata <- CPUEData |> dplyr::filter(Fleet==fl) 
  cpuedata$CPUE <- cpuedata$CPUE/mean(cpuedata$CPUE, na.rm=TRUE)
  abind::afill(RCMData@Index) <- array(cpuedata$CPUE, dim=c(length(cpuedata$CPUE), 1), 
                                       dimnames = list(Year=cpuedata$Year, Fleet=unique(cpuedata$Fleet))
  )
  abind::afill(RCMData@I_sd) <- array(cpuedata$CV, dim=c(length(cpuedata$CPUE), 1), 
                                      dimnames = list(Year=cpuedata$Year, Fleet=unique(cpuedata$Fleet))
  )
}

# remove 2012 - 2018 for JPN LL Index
JPNLLYears <- !Years %in% 1976:2011
RCMData@Index[JPNLLYears,4] <- NA
RCMData@I_sd[JPNLLYears,4] <- NA

MinIndCV <- 0.2

RCMData@I_sd <- pmax(RCMData@I_sd, MinIndCV) 

# Remove fleets that do not have CPUE
no_CPUE <- setdiff(1:nFleet, CPUEData$Fleet)
RCMData@Index <- RCMData@Index[, -no_CPUE]
RCMData@I_sd <- RCMData@I_sd[, -no_CPUE]


# ----- CAL Data ----
CALData <- readxl::read_excel('Condition/Data/SALB_2018.xlsx', "CAL")

# Filtering data up to 2018 for demo - this can be removed later
CALData <- CALData |> dplyr::filter(Year<=2018)

CALFleets <- CALData$Fleet |> unique()


length_bin <- as.numeric(colnames(CALData))
length_bin <- length_bin[!is.na(length_bin)]
nBin <- length(length_bin)

RCMData@CAL <- array(NA, c(nYears, nBin, nFleet), dimnames = list(Year=Years,
                                                                  Class=length_bin,
                                                                  Fleet=Fleets))
CAL_ESS <- 50 
for (fl in CALFleets) {
  caldataFleet <- CALData |> dplyr::filter(Fleet==fl) 
  caldata <- caldataFleet[,3:ncol(caldataFleet)] |> as.matrix()
  abind::afill(RCMData@CAL) <- array(caldata, dim=c(nrow(caldata), ncol(caldata), 1), 
                                     dimnames = list(Year=caldataFleet$Year, 
                                                     Class=length_bin,
                                                     Fleet=unique(caldataFleet$Fleet)))
  
}

RCMData@CAL_ESS <- pmin(apply(RCMData@CAL, c(1, 3), sum, na.rm = TRUE), CAL_ESS)
RCMData@CAL_ESS[RCMData@CAL_ESS==0] <- NA
RCMData@length_bin <- length_bin

saveRDS(RCMData, 'Condition/SALB.rcmdata')


