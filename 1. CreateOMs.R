library(MSEtool)

if (!packageVersion('MSEtool') >= '4.0.0') {
  cli::cli_alert_warning('This analysis requires latest development version of `MSEtool`. Installing now ...')
  pak::pkg_install('blue-matter/MSEtool@prelease')
}


# OM Specifications 
nSim <- 200
pYear <- 30

Interval <- 3 
Name <- 'Southern Atlantic Albacore'
StockName <- "Albacore"
Species <- "Thunnus alalunga"
Region <- 'South Atlantic'
Agency <- 'ICCAT'
DataLag <- 1 # lagged by 1 year?

source('Condition/LifeHistoryParameters.R')

# Update Base Case OM ----

SSDir <- "G:/Shared drives/BM shared/1. Projects/TOF-MSE-SALB/ALB_test__CHI_cpue_update"

OM <- ImportSS(SSDir=SSDir, 
               Name=Name,
               nSim=nSim, 
               pYear = pYear,
               Agency=Agency,
               Region=Region,
               StockName=StockName,
               Species=Species,
               Interval=Interval,
               DataLag=DataLag)

saveRDS(OM, file.path('OM', 'Base_Updated.om'))





# Grid ----

GridDir <- 'G:/Shared drives/BM shared/1. Projects/TOF-MSE-SALB/ALB-S_Unc-Grid/ALB-S_Unc-Grid'
GridDirs <- list.dirs(file.path(GridDir), full.names = FALSE, recursive = FALSE)

for (i in seq_along(GridDirs)) {
  run <- GridDirs[i]
  SSDir <- file.path(GridDir, GridDirs[i])
  om <- ImportSS(SSDir=SSDir, 
                 Name=Name,
                 nSim=nSim, 
                 pYear = pYear,
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


SetupParallel()
RepList <- ImportSSReport(SSDir=file.path(SSDir, StochasticDirs), parallel = TRUE)

OM <- ImportSS(SSDir=RepList, 
               Name=Name,
               nSim=nSim, 
               pYear = pYear,
               Agency=Agency,
               Region=Region,
               StockName=StockName,
               Species=Species,
               Interval=Interval,
               DataLag=DataLag,
               Populate)

saveRDS(OM, 'OM/Stochastic.om')
