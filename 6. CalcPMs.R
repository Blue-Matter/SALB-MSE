library(MSEtool)
library(Slick)

source('PMFunctions.R')

# ---- Stochastic ----


MSE <- readRDS('MSE/Stochastic.mse')

# OPERATIONAL MANAGEMENT OBJECTIVES FOR SOUTHERN ATLANTIC ALBACORE
# https://www.iccat.int/Documents/Recs/compendiopdf-e/2024-09-e.pdf

## Status ----

# The stock should have a 60% or greater probability of occurring in the green quadrant of
# the Kobe matrix over a 30-year projection period;
StatusPI <- Status(MSE)

## Safety ----
# There should be no greater than 15% probability of the stock falling below BLIM at any
# point during the 30-year projection period;
# The SCRS should use 40% of the spawning stock biomass at Maximum Sustainable Yield (MSY) 
# as the interim BLIM for southern Atlantic albacore tuna, or advise on a different value, if appropriate.
SafetyPI <- Safety(MSE)
  

## Yield ----
# Maximize overall catch levels; 
YieldPI <- MeanLandings(MSE)

## Stability ----
# Any changes in total allowable catch (TAC) between management periods should be 20% or less
StabilityPI <- Stability(MSE)


Slick <- readRDS('Slick/Stochastic.slick')
Quilt <- Quilt()
Code(Quilt) <- c('Status', 'Safety', 'Yield', 'Stability')
Label(Quilt) <- c('Status', 'Safety', 'Yield', 'Stability')
Description(Quilt) <- c('Probability Green Kobe', 
                        'Probability SB>0.4SBMSY', 
                        'Mean Yield', 
                        'Probability Avg Variability in TAC < 20%')

nMP <- length(MSE@MPs)
nOM <- 1
nPI <- 4

Value <- array(NA, dim=c(nOM, nMP, nPI))
Value[1,,1] <- StatusPI$Value
Value[1,,2] <- SafetyPI$Value
Value[1,,3] <- YieldPI$Value
Value[1,,4] <- StabilityPI$Value
Value(Quilt) <- Value
Quilt(Slick) <- Quilt
saveRDS(Slick, 'Slick/Stochastic.slick')



# ---- Grid ----
MSEFiles <- list.files('MSE', full.names = TRUE)
GridMSEFiles <- MSEFiles[-c(grep("Stochastic.mse", MSEFiles),grep("Base.mse", MSEFiles))]
MSEList <- purrr::map(GridMSEFiles, readRDS)

SlickGrid <- readRDS('Slick/Grid.slick')

Quilt <- Quilt()
Code(Quilt) <- c('Status', 'Safety', 'Yield', 'Stability')
Label(Quilt) <- c('Status', 'Safety', 'Yield', 'Stability')
Description(Quilt) <- c('Probability Green Kobe', 
                        'Probability SB>0.4SBMSY', 
                        'Mean Yield', 
                        'Probability Avg Variability in TAC < 20%')

nMP <- length(MSE@MPs)
nOM <- length(MSEList)
nPI <- 4
Value <- array(NA, dim=c(nOM, nMP, nPI))

for (i in seq_along(MSEList)) {
  Value[i,,1] <- Status(MSEList[[i]]) |> dplyr::pull(Value)
  Value[i,,2] <- Safety(MSEList[[i]]) |> dplyr::pull(Value)
  Value[i,,3] <- MeanLandings(MSEList[[i]]) |> dplyr::pull(Value)
  Value[i,,4] <- Stability(MSEList[[i]]) |> dplyr::pull(Value)
}
Value(Quilt) <- Value
Quilt(SlickGrid) <- Quilt
saveRDS(SlickGrid, 'Slick/Grid.slick')







