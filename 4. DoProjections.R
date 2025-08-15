library(MSEtool)

source('3. DefineCMPs.R')
MPs <- avail('mp')

# ----- Stochastic OM ------

Hist <- readRDS('Hist/Stochastic.hist')
MSE <- Project(Hist, MPs)
saveRDS(MSE, 'MSE/Stochastic.mse')


# ----- Uncertainty Grid ------

HistFiles <- list.files('Hist')
GridHistFiles <- HistFiles[!HistFiles %in% c("Base.hist", "Stochastic.hist")]


for (i in seq_along(GridHistFiles)) {
  OMFile <- GridHistFiles[i]
  Hist <- readRDS(file.path('Hist', OMFile))
  MSE <- Project(Hist, MPs)
  MSEFile <- tools::file_path_sans_ext(OMFile) |> paste0('.mse')
  saveRDS(MSE, file.path('MSE', MSEFile))
}


