
pak::pkg_install('r4ss/r4ss')

library(r4ss)

# Paths - update if not working from SALB-MSE Github repo file structure

WD <- getwd()
Root <- file.path(WD, 'Condition') # root directory 
SS3Dir <- file.path(Root, 'SS3')

# Put the Base Case SS3 output in `SSDirBase`
SSDirBase <- file.path(SS3Dir, 'Base') # path to base case SS3 output (mean value)
DataFileName <- 'SALB.dat' # name of the data file - REPLACE
CrtFileName <- 'control.ss_new' # name of the control file - REPLACE

StochasticValues <- read.csv('Condition/LHSamples.csv') # generated in GenerateDistributions.R
nsim <- nrow(StochasticValues)

# Loop over rows in StochasticValues and create directories with SS3 files
for (i in 1:nsim) {
  message(i, '/', nsim)
  
  dat <- r4ss::SS_readdat_3.30(file.path(SSDirBase, DataFileName), verbose = FALSE)
  ctl <- r4ss::SS_readctl_3.30(file.path(SSDirBase, CrtFileName), datlist=dat, verbose = FALSE)
  
  # M
  ind <- grepl('NatM', rownames(ctl$MG_parms)) |> which()
  for (j in seq_along(ind)) {
    ctl$MG_parms[ind[j], c("INIT", "PRIOR")] <- StochasticValues$M[i]
  }
  
  # steepness
  ctl$SR_parms["SR_BH_steep",c('INIT', 'PRIOR')] <- StochasticValues$h[i]
  
  # create directory 
  i_char <- as.character(i)
  if (nchar(i_char)==1) i_char <- paste0('00', i_char)
  if (nchar(i_char)==2) i_char <- paste0('0', i_char)
  
  dir <- paste('Stochastic', i_char, sep="_")
  if (!dir.exists(file.path(SS3Dir, dir)))
    dir.create(file.path(SS3Dir, dir))
  
  # modify starter.ss
  starter <- r4ss::SS_readstarter(file.path(SSDirBase, 'starter.ss'),verbose = FALSE)
  starter$ctlfile <- 'control.ss'
  starter$datfile <- DataFileName  # indices will differ based on llq
  starter$init_values_src <- 0 # use control file for initial values
  starter$run_display_detail <- 0
  starter$cumreport <- 0
  
  # write the modified files
  SS_writectl_3.30(ctl, file.path(SS3Dir, dir, 'control.ss'), verbose=F, overwrite = TRUE)
  SS_writedat_3.30(dat, file.path(SS3Dir, dir, DataFileName), verbose=F, overwrite = TRUE)
  SS_writestarter(starter, file.path(SS3Dir, dir), verbose=F, overwrite = TRUE)
  
  # copy over other files
  file.copy(file.path(SSDirBase, "forecast.ss"),
            file.path(SS3Dir, dir, "forecast.ss"),
            overwrite = TRUE)
  
  file.copy(file.path(SSDirBase, "ss3.exe"),
            file.path(SS3Dir, dir, "ss3.exe"),
            overwrite = TRUE)
  
  
}

# Run the SS3 models 
# Note: can run this in parallel if it takes too long 
SS3Dirs <- list.dirs(SS3Dir, recursive = FALSE)
SS3Dirs <- SS3Dirs[!grepl('Base', SS3Dirs)]


for (i in seq_along(SS3Dirs)) {
  setwd(SS3Dirs[i])
  system2('ss3.exe', stdout = FALSE, stderr = FALSE)
  
  # cleanup
  if (file.exists('ss3.exe'))
    file.remove('ss3.exe')
}
setwd(WD)



