library(openMSE)

# RCM Conditioning ----

source('Condition/Specifications.R')

source('Condition/RCM/RCMData.R')

RCMData <- readRDS('Condition/RCM/SALB.rcmdata')

## Base Case OM (no stochastic parameter) ----

OM_Base <- tinyErr(new('OM'))
OM_Base@Name <- "Base Case - Non Stochastic"
OM_Base@nyears <- nrow(RCMData@Chist)
OM_Base@nsim <- nsim
OM_Base@Species <- "Thunnus alalunga"
OM_Base@proyears <- proyears
OM_Base@maxage <- 20
OM_Base@CurrentYr <- 2018

### ---- Natural Mortality ----

OM_Base@M <- mean(M_range) |> rep(2)

#### ---- Length-at-Age ----

OM_Base@Linf <- rep(Linf_mu, 2)
OM_Base@K <- rep(K_mu, 2)
OM_Base@t0 <- rep(t0_mu, 2)

### ---- Length-Weight ----

OM_Base@a <- rep(Wa_mu,2)
OM_Base@b <- rep(Wb_mu,2)

### ---- Maturity ----

OM_Base@L50 <- rep(L50_mu,2)
OM_Base@L50_95 <- L95_mu - OM_Base@L50

### ---- Stock Recruit ----

OM_Base@h <- rep(h_mu,2)
OM_Base@Perr <- rep(PE_mu, 2)

OM_Base@R0 <- 1e5 # initial value, need high R0


## Base Case OM (Stochastic Parameters) ----

OM_Base_Stochastic <- OM_Base
OM_Base_Stochastic@Name <- "Base Case - Stochastic"

StochasticValues <- read.csv('Condition/LHSamples.csv')

### ---- Natural Mortality ----

OM_Base_Stochastic@M <- range(StochasticValues$M)
OM_Base_Stochastic@cpars$M <- StochasticValues$M

### ---- Stock Recruit ----

OM_Base_Stochastic@h <- range(StochasticValues$h)

OM_Base_Stochastic@cpars$hs <- StochasticValues$h

# ---- Condition Base Case OM - Non Stochastic ----

# initial starting values - estimated by fleet in RCM
OM_Base@L5 <- rep(70,2)
OM_Base@LFS <- rep(90,2)
OM_Base@isRel <- FALSE
OM_Base@Vmaxlen <- c(1,1)

OM_Base_Stochastic@L5 <- OM_Base@L5
OM_Base_Stochastic@LFS <- OM_Base@LFS
OM_Base_Stochastic@isRel <- OM_Base@isRel
OM_Base_Stochastic@Vmaxlen <- OM_Base@Vmaxlen

# Assuming:
# Long Line LL - logistic
# Purse Seine - dome 
# Bait Boat - dome 

# selectivity <- c("logistic_length", # LL
#                  "logistic_length", # LL
#                  "logistic_length", # LL 
#                  "logistic_length", # LL
#                  "logistic_length", # LL
#                  "dome_length", # PS & BB
#                  "dome_length", # PS & BB
#                  "logistic_length")  # LL

# Assuming all dome-shaped:
selectivity <- c("dome_length", # LL
                 "dome_length", # LL
                 "dome_length", # LL 
                 "dome_length", # LL
                 "dome_length", # LL
                 "dome_length", # PS & BB
                 "dome_length", # PS & BB
                 "dome_length")  # LL

Base_Mean <- RCM(OM_Base, RCMData, 
                   condition = "catch2",      
                   selectivity = selectivity,
                   s_selectivity = c(1, 4, 8),
                   max_F=10,
                   mean_fit = TRUE)

saveRDS(Base_Mean, 'Condition/RCM/Base_Mean.rcm')


plot(Base_Mean, filename='Base_Mean', dir='Condition/RCM')


# ---- Condition Base Case OM - Stochastic ----

Base_Stochastic <- RCM(OM_Base_Stochastic, RCMData, 
                   condition = "catch2",  
                   cores=24,
                   selectivity = selectivity,
                   s_selectivity = c(1, 4, 8), 
                   max_F=10,
                   mean_fit = TRUE)

saveRDS(Base_Stochastic, 'Condition/RCM/Base_Stochastic.rcm')

plot(Base_Stochastic, filename='Base_Stochastic', dir='Condition/RCM')


# ---- Save OMs ----
saveRDS(Base_Mean@OM, 'OM/RCM_Mean.om')
saveRDS(Base_Stochastic@OM, 'OM/RCM_Stochastic.om')



# # ---- Simulate Hist ----
# 
# Base_Mean <- Simulate(Base_Mean@OM)
# saveRDS(Base_Mean, 'Condition/Base_NS.hist')
# 
# Base_SC <- Simulate(RCM_Base_SC@OM)
# saveRDS(Base_SC, 'Condition/Base_SC.hist')
# 
# 
# 
# SBMSY <- Base_SC@Ref$ReferencePoints$SSBMSY
# SSB0 <- Base_SC@Ref$ReferencePoints$SSB0
# (SBMSY/SSB0) |> unique()
# 
# SB <- apply(Base_SC@TSdata$SBiomass, 1:2, sum)
# SB_SBMSY <- SB/SBMSY[1]
# matplot(t(SB_SBMSY), type='l', ylim=c(0,6))
# abline(h=1, lty=3)
