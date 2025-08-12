# ----- Stochastic OM ------
library(MSEtool)
library(Slick)

MSE <- readRDS('MSE/Stochastic.mse')

Slick <- MSE2Slick(MSE)

Title(Slick)
Subtitle(Slick) <- "Demonstration MSE"
Introduction(Slick)

saveRDS(Slick, 'Slick/Stochastic.slick')


# plotTimeseries(Slick)
# plotTimeseries(Slick,2)
# plotTimeseries(Slick,3)
# plotTimeseries(Slick,4,
#                byMP = TRUE,
#                includeQuants = TRUE,
#                includeHist = TRUE)
# 
# 
# plotTimeseries(Slick,5, includeQuants = FALSE)
# 
# plotKobe(Slick)
# plotKobe(Slick, Time=TRUE)


# ----- Uncertainty Grid ------

MSEFiles <- list.files('MSE', full.names = TRUE)
GridMSEFiles <- MSEFiles[-c(grep("Stochastic.mse", MSEFiles),grep("Base.mse", MSEFiles))]

MSEList <- purrr::map(GridMSEFiles, readRDS)
SlickGrid <- MSE2Slick(MSEList)

saveRDS(SlickGrid, 'Slick/Grid.slick')





  