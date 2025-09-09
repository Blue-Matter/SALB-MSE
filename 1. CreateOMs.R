library(MSEtool)

if (!packageVersion('MSEtool') >= '4.0.0') {
  cli::cli_alert_warning('This analysis requires latest development version of `MSEtool`. Installing now ...')
  pak::pkg_install('blue-matter/MSEtool@dev')
}


# OM Specifications 
nsim <- 200
proyears <- 30

Interval <- 3 
Name <- 'Southern Atlantic Albacore'
StockName <- "Albacore"
Species <- "Thunnus alalunga"
Region <- 'South Atlantic'
Agency <- 'ICCAT'
DataLag <- 1 # lagged by 1 year?

source('Condition/LifeHistoryParameters.R')


# # Mean SS ----
# replist <- ImportSSReport(file.path(SSDir, 'Base'))
# # fl <- tempfile()
# # fl 
# # saveRDS(replist, fl)
# 
# SS_Mean <- ImportSS(file.path(SSDir, 'Base'), 
#                     nSim=nsim, 
#                     pYear = proyears,
#                     Name=Name,
#                     Agency=Agency,
#                     Region=Region,
#                     StockName=StockName,
#                     Species=Species,
#                     Interval=Interval,
#                     DataLag=DataLag)
# 
# saveRDS(SS_Mean, 'OM/Base.om')


# Grid ----

GridDir <- 'G:/Shared drives/BM shared/1. Projects/TOF-MSE-SALB/ALB-S_Unc-Grid/ALB-S_Unc-Grid'
GridDirs <- list.dirs(file.path(GridDir), full.names = FALSE, recursive = FALSE)

for (i in seq_along(GridDirs)) {
  run <- GridDirs[i]
  om <- ImportSS(file.path(GridDir, GridDirs[i]), 
                 nSim=nsim, 
                 pYear = proyears,
                 Name=Name,
                 Agency=Agency,
                 Region=Region,
                 StockName=StockName,
                 Species=Species,
                 Interval=Interval,
                 DataLag=DataLag)
  
  nm <- gsub('ALB-S_', '', run)
  nm <- paste0('Grid_', nm, '.om')
  saveRDS(om, file.path('OM', nm))
}


# Stochastic ---- 
SSDir <- "G:/Shared drives/BM shared/1. Projects/TOF-MSE-SALB/ALB-S_Stochastic/ALB-S_Stochastic/Condition/SS3"
StochasticDirs <- list.dirs(file.path(SSDir), full.names = FALSE, recursive = FALSE)
StochasticDirs <- StochasticDirs[!grepl('Base', StochasticDirs)]

RepList <- ImportSSReport(file.path(SSDir, StochasticDirs))

OM <- ImportSS(RepList, 
               nSim=nsim, 
               pYear = proyears,
               Name=Name,
               Agency=Agency,
               Region=Region,
               StockName=StockName,
               Species=Species,
               Interval=Interval,
               DataLag=DataLag)

saveRDS(OM, 'OM/Stochastic.om')
