
library(MSEtool)

# Simulate Historical Fisheries -----
OMFiles <- list.files("OM", pattern='.om')

for (i in seq_along(OMFiles)) {
  omfile <- OMFiles[i]
  histfile <- paste0(gsub('.om', '', omfile), '.hist')
  
  OM <- readRDS(file.path("OM", omfile))
  Hist <- SimulateDEV(OM)
  saveRDS(Hist, file.path('Hist', histfile))
}
