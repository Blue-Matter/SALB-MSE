library(MSEtool)

if (!packageVersion('MSEtool') >= '4.0.0') {
  cli::cli_alert_warning('This analysis requires latest development version of `MSEtool`. Installing now ...')
  pak::pkg_install('blue-matter/MSEtool@dev')
}

SSDir <- 'Condition/SS3/ALB-S_Stochastic/Condition/SS3'

source('1a. OMSpecifications.R')


# Mean SS ----
replist <- ImportSSReport(file.path(SSDir, 'Base'))
# fl <- tempfile()
# fl 
# saveRDS(replist, fl)

SS_Mean <- ImportSS(file.path(SSDir, 'Base'), 
                    nSim=nsim, 
                    pYear = proyears,
                    Name=Name,
                    Agency=Agency,
                    Region=Region,
                    StockNames=StockName,
                    SpeciesNames=Species,
                    Interval=Interval,
                    DataLag=DataLag)

saveRDS(SS_Mean, 'OM/Base.om')


# Grid ----
GridDir <- 'Condition/SS3/ALB-S_Unc-Grid'
GridDirs <- list.dirs(file.path(GridDir), full.names = FALSE, recursive = FALSE)

for (i in seq_along(GridDirs)) {
  run <- GridDirs[i]
  om <- ImportSS(file.path(GridDir, GridDirs[i]), 
                 nSim=nsim, 
                 pYear = proyears,
                 Name=Name,
                 Agency=Agency,
                 Region=Region,
                 StockNames=StockName,
                 SpeciesNames=Species,
                 Interval=Interval,
                 DataLag=DataLag)
  
  nm <- gsub('ALB-S_', '', run)
  nm <- paste0('Grid_', nm, '.om')
  saveRDS(om, file.path('OM', nm))
}


# Stochastic ---- 
StochasticDirs <- list.dirs(file.path(SSDir), full.names = FALSE, recursive = FALSE)
StochasticDirs <- StochasticDirs[!grepl('Base', StochasticDirs)]

RepList <- ImportSSReport(file.path(SSDir, StochasticDirs))

OM <- ImportSS(RepList, 
               nSim=nsim, 
               pYear = proyears,
               Name=Name,
               Agency=Agency,
               Region=Region,
               StockNames=StockName,
               SpeciesNames=Species,
               Interval=Interval,
               DataLag=DataLag)

saveRDS(OM, 'OM/Stochastic.om')


# OMList <- list()
# Fails <- NULL
# for (i in seq_along(StochasticDirs)) {
#   ssoutput <- try(SS2MOM(file.path(SSDir, StochasticDirs[i]), nsim=1, proyears = proyears), silent=TRUE)
#   if (class(ssoutput)=="try-error") {
#     Fails <- c(Fails, i)
#   } else {
#     OMList[[i]] <-ssoutput
#   }
# }
# OMList[[Fails]] <- NULL
# 
# MOM <- new('MOM')
# MOM@Name <- 'SALB Stochastic'
# MOM@nsim <- length(OMList)
# MOM@proyears <- proyears
# MOM@interval <- 1
# MOM@pstar <- 0.5
# MOM@maxF <- 3
# MOM@reps <- 1
# 
# MOM@cpars <- vector('list', length(OMList[[1]]@Stocks))
# for (i in seq_along(MOM@cpars)) {
#   MOM@cpars[[i]] <- vector('list', length(OMList[[1]]@Fleets$Female))
#   
#   for (fl in 1:length( MOM@cpars[[i]])) {
#     nms <- names(OMList[[i]]@cpars[[1]][[fl]])
#     nms <- nms[!nms == 'Data']
#     
#     for (j in seq_along(nms)) {
#       vals <- purrr::map(OMList, \(om)
#                          om@cpars[[i]][[fl]][[nms[j]]]
#       )
#       if (is.null(dim(vals[[1]]))) {
#         if (nms[j] %in% c('CAL_bins', 'CAL_binsmid')) {
#           vals <- unlist(vals) |> unique()
#         } else {
#           vals <- unlist(vals)  
#         }
#         
#       } else {
#         vals <- abind::abind(vals, along=1)  
#       }
#       MOM@cpars[[i]][[fl]][[nms[j]]] <- vals
#     }
#   }
#   
#   # r0 
#   R0s <- purrr::map(OMList, \(om)
#                      slot(om@Stocks[[i]],'R0')
#   )
#   
#   MOM@cpars[[i]][[1]]$R0 <- unlist(R0s)
# }
# 
# 
# 
# MOM@Stocks <- vector('list', length(OMList[[1]]@Stocks))
# for (i in seq_along(MOM@Stocks)) {
#   MOM@Stocks[[i]] <- new('Stock')
#   nms <- slotNames('Stock')
#   for (j in seq_along(nms)) {
#     vals <- purrr::map(OMList, \(om)
#                        slot(om@Stocks[[i]],nms[j])
#     )
#     value <- slot(OMList[[1]]@Stocks[[1]], nms[j]) 
#     cls <- class(value)
#     if (cls =='character') {
#       slot(MOM@Stocks[[i]], nms[j]) <- vals[[1]]
#     } else if (cls=='numeric') {
#       rng <- range(unlist(vals)) 
#       if (length(rng)==1)
#         rng <- rep(rng, 2)
#       slot(MOM@Stocks[[i]], nms[j]) <- rng
#     } else if (cls=='integer') {
#       slot(MOM@Stocks[[i]], nms[j]) <- vals[[1]] 
#     } else {
#       stop()
#     }
#   }
# }
# 
# MOM@Fleets <- vector('list', length(OMList[[1]]@Stocks))
# 
# for (i in seq_along(MOM@Fleets)) {
#   MOM@Fleets[[i]] <- vector('list', length(OMList[[1]]@Fleets[[1]]))
#   for (fl in seq_along(MOM@Fleets[[i]])) {
#     MOM@Fleets[[i]][[fl]] <- new('Fleet')
#     nms <- slotNames('Fleet')
#     for (j in seq_along(nms)) {
#       vals <- purrr::map(OMList, \(om)
#                          slot(om@Fleets[[i]][[fl]],nms[j])
#       )
#       value <- slot(OMList[[1]]@Fleets[[i]][[fl]], nms[j]) 
#       cls <- class(value)
#       if (cls =='character') {
#         slot(MOM@Fleets[[i]][[fl]], nms[j]) <- vals[[1]]
#       } else if (cls=='numeric') {
#         rng <- range(unlist(vals)) 
#         if (length(rng)==1)
#           rng <- rep(rng, 2)
#         slot(MOM@Fleets[[i]][[fl]], nms[j]) <- rng
#       } else if (cls=='integer') {
#         slot(MOM@Fleets[[i]][[fl]], nms[j]) <- vals[[1]] 
#       } else if (cls=='logical') {
#         slot(MOM@Fleets[[i]][[fl]], nms[j]) <- vals[[1]] 
#       } else {
#         print(paste('Skipping:', nms[j]))
#       }
#     }
#   }
# }
# 
# MOM@Obs <- list(
#   vector('list', length(OMList[[1]]@Fleets[[1]]))
# )
# MOM@Imps <- list(
#   vector('list', length(OMList[[1]]@Fleets[[1]]))
# )
# 
# 
# for (i in seq_along(MOM@Obs)) {
#   for (fl in seq_along(MOM@Obs[[i]])) {
#     MOM@Obs[[i]][[fl]] <- Perfect_Info
#     MOM@Imps[[i]][[fl]] <- Perfect_Imp
#   }
# }
# 
# for (i in seq_along(MOM@Obs)) {
#  
#   CatchFrac <- purrr::map(OMList, \(om)
#                           om@CatchFrac[[1]]
#   )
#   MOM@CatchFrac[[i]] <- abind::abind(CatchFrac, along=1)
# }
# 
# MOM@cpars[[1]][[1]]$Data <- OMList[[1]]@cpars[[1]][[1]]$Data

# saveRDS(MOM, 'OM/SS_Stochastic.om')





