

library(openMSE)
library(dplyr)
library(ggplot2)

# ---- Load RCM Data ----
source("Condition/RCM/RCMData.R")

RCMData <- readRDS("Condition/RCM/SALB.rcmdata")

# ---- Base Case OM Parameters -----

OM_Base <- new("OM")
OM_Base@nyears <- nrow(RCMData@Chist)
OM_Base@nsim <- 100
OM_Base@Species <- "Thunnus alalunga"
OM_Base@maxage <- 20
OM_Base@CurrentYr <- 2018

# Natural Mortality, Linf, K, t0, 
OM_Base@Linf <- c(124.74, 147.5) # range from ICCAT Manual 2.1.4 ALB
OM_Base@K <- c(0.126, 0.23)
OM_Base@t0 <- c(-1.89, -0.989) # range from ICCAT Manual 2.1.4 ALB

OM_Base@M <- c(0.25, 0.35) # assumed uniform distribution around 0.3 assumption in SCRS/2024/156

OM_Base@L50 <- c(90, 90) # SCRS/2024/156
OM_Base@L50_95 <- c(4,4) # SCRS/2024/156

# Length-Weight relationship
OM_Base@a <- 1.3718E-5
OM_Base@b <- 3.09773 # Penney (1994) from ICCAT Manual 2.1.4 ALB

# Steepness
OM_Base@h <- c(0.75, 0.9) # uniform distribution borrowed from North Atlantic Albacore MSE https://www.iccat.int/Documents/CVSP/CV076_2019/n_8/CV07608051.pdf

# Stock-Recruit Relationship
OM_Base@SRrel <- 1 # Beverton Holt SRR

# Process Error
OM_Base@Perr <- c(0.3, 0.6) # uniform distribution - assumed based on nothing in particular

# Selectivity Starting Values 
CALsum$Class[which.max(CALsum$n)]

plot(RCMData@length_bin, apply(RCMData@CAL,2, sum, na.rm=TRUE), type='b')

# initial starting values - estimated by fleet in RCM
OM_Base@L5 <- rep(70,2)
OM_Base@LFS <- rep(90,2)
OM_Base@isRel <- FALSE
OM_Base@Vmaxlen <- c(1,1)

OM_Base@R0 <- 1e5 # initial value, need high R0

# ---- Condition Base Case OM ----

# Assuming:
# logistic selectivity for all fleets

RCM_Base_logisitic <- RCM(OM_Base, RCMData, 
                          condition = "catch2",       # Model runs faster if F are not parameters
                          selectivity = 'logistic_length',
                          s_selectivity = c(1, 4, 8), # Assign index selectivity to corresponding fleet
                          mean_fit = TRUE)

sum(!RCM_Base_logisitic@conv)/OM_Base@nsim

plot(RCM_Base_logisitic, s_name = c("Chinese Taipei LL", "Japan LL", "Uruguay LL"))

OM_Base <- RCM_Base_logisitic@OM
OM_Base <- Replace(OM_Base, Generic_Obs)

saveRDS(OM_Base, "Condition/RCM/OM_Stochastic_Logistic.om")

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

RCM_Stochastic_dome <- RCM(OM_Base, RCMData, 
                     condition = "catch2",       # Model runs faster if F are not parameters
                     selectivity = selectivity,
                     s_selectivity = c(1, 4, 8), # Assign index selectivity to corresponding fleet
                     mean_fit = TRUE)

sum(!RCM_Stochastic_dome@conv)/OM_Base@nsim

plot(RCM_Stochastic_dome, s_name = c("Chinese Taipei LL", "Japan LL", "Uruguay LL"))

OM_Stochastic_dome <- RCM_Stochastic_dome@OM
OM_Stochastic_dome <- Replace(OM_Stochastic_dome, Generic_Obs)

saveRDS(OM_Stochastic_dome, "Condition/RCM/OM_Stochastic_Dome.om")




