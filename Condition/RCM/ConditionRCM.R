
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
# 4. Japan (LL) 1976 - 2018
# 5. -
# 6. -
# 7. -
# 8. Uruguay (LL)


readxl::excel_sheets('Data/SALB_2018.xlsx')

RCMData <- new('RCMdata') 

# ----- Catch Data -----
CatchData <- readxl::read_excel('Data/SALB_2018.xlsx', "Catch")

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
CPUEData <- readxl::read_excel('Data/SALB_2018.xlsx', "CPUE")

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

MinIndCV <- 0.2

RCMData@I_sd <- pmax(RCMData@I_sd, MinIndCV) 

# Remove fleets that do not have CPUE
no_CPUE <- setdiff(1:nFleet, CPUEData$Fleet)
RCMData@Index <- RCMData@Index[, -no_CPUE]
RCMData@I_sd <- RCMData@I_sd[, -no_CPUE]


# ----- CAL Data ----
CALData <- readxl::read_excel('Data/SALB_2018.xlsx', "CAL")

# Filtering data up to 2018 for demo - this can be removed later
CALData <- CALData |> dplyr::filter(Year<=2018)

CALFleets <- CALData$Fleet |> unique()


length_bin <- as.numeric(colnames(CALData))
length_bin <- length_bin[!is.na(length_bin)]
nBin <- length(length_bin)

RCMData@CAL <- array(NA, c(nYears, nBin, nFleet), dimnames = list(Year=Years,
                                                                  Class=length_bin,
                                                                  Fleet=Fleets))
CAL_ESS <- 100 
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


CAL <- array2DF(RCMData@CAL)
CAL$Year <- as.numeric(CAL$Year)
CAL$Class <- as.numeric(CAL$Class)
CAL$Fleet <- as.numeric(CAL$Fleet)

CALsum <- CAL |> dplyr::group_by(Class) |>
  dplyr::summarise(n=sum(Value, na.rm=TRUE))

ggplot(CALsum, aes(x=Class, y=n)) +
  geom_bar(stat='identity') +
  theme_bw()

CAL$Fleet |> unique()

ggplot(CAL |> dplyr::filter(Fleet==1), aes(x=Class, y=Value)) +
  facet_wrap(~Year, scales='free_y') +
  geom_line() +
  theme_bw()




# ---- Base Case OM Parameters -----

OM_Base <- new("OM")
OM_Base@nyears <- nYears
OM_Base@nsim <- 10
OM_Base@Species <- "Thunnus alalunga"
OM_Base@maxage <- 20
OM_Base@CurrentYr <- 2018

# Natural Mortality, Linf, K, t0, 
OM_Base@Linf <- rep(130, 2) # c(124.74, 147.5) # range from ICCAT Manual 2.1.4 ALB
OM_Base@K <- rep(0.15,2) # c(0.126, 0.23)
OM_Base@t0 <- rep(-0.5,2) # c(-1.89, -0.989) # range from ICCAT Manual 2.1.4 ALB

OM_Base@M <- rep(0.3, 2) # c(0.25, 0.35) # assumed uniform distribution around 0.3 assumption in SCRS/2024/156

OM_Base@L50 <- c(90, 90) # SCRS/2024/156
OM_Base@L50_95 <- c(4,4) # ratio reported in SCRS/2024/156

# Length-Weight relationship
OM_Base@a <- 1.3718E-5
OM_Base@b <- 3.09773 # Penney (1994) from ICCAT Manual 2.1.4 ALB

# Steepness
OM_Base@h <- rep(0.9,2)#  c(0.75, 0.9) # uniform distribution borrowed from North Atlantic Albacore MSE https://www.iccat.int/Documents/CVSP/CV076_2019/n_8/CV07608051.pdf

# Stock-Recruit Relationship
OM_Base@SRrel <- 1 # Beverton Holt SRR

# Process Error
OM_Base@Perr <- rep(0.5, 2) # c(0.3, 0.6) # uniform distribution - assumed based on nothing in particular

# Selectivity Starting Values 
CALsum$Class[which.max(CALsum$n)]


OM_Base@R0 <- 1e5 # initial value, need high R0

# ---- Condition Base Case OM ----


start

RCM_Base_logisitic <- RCM(OM_Base, RCMData, 
                          condition = "catch2",       # Model runs faster if F are not parameters
                          selectivity = 'logistic_length',
                          s_selectivity = c(1, 4, 8), # Assign index selectivity to corresponding fleet
                          mean_fit = TRUE,
                          start=start)

sum(!RCM_Base_logisitic@conv)/OM_Base@nsim

plot(RCM_Base_logisitic, s_name = c("Chinese Taipei LL", "Japan LL", "Uruguay LL"))

# Assuming:
# Long Line LL - logistic
# Purse Seine - dome 
# Bait Boat - dome 

selectivity <- c("logistic_length", # LL
                 "logistic_length", # LL
                 "logistic_length", # LL 
                 "logistic_length", # LL
                 "logistic_length", # LL
                 "dome_length", # PS & BB
                 "dome_length", # PS & BB
                 "logistic_length")  # LL

RCM_Base_dome <- RCM(OM_Base, RCMData, 
                          condition = "catch2",       # Model runs faster if F are not parameters
                          selectivity = selectivity,
                          s_selectivity = c(1, 4, 8), # Assign index selectivity to corresponding fleet
                          mean_fit = TRUE)

sum(!RCM_Base_dome@conv)/OM_Base@nsim

plot(RCM_Base_dome, s_name = c("Chinese Taipei LL", "Japan LL", "Uruguay LL"))





# Alternative Assumptions:
# - Age-dependent M
# - different selectivity patterns




