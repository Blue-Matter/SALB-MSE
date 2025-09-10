library(MSEtool)
library(Slick)
library(ggplot2)
library(flextable)

# ---- OM ----

Stochastic <- read.csv('Condition/LHSamples.csv') 

p <- ggplot(Stochastic, aes(x=M, y=h)) +
  geom_point() +
  theme_bw()

p <- ggExtra::ggMarginal(p, type='histogram')
ggsave('Figures/M_h_plot.png', p, width=4, height=4)


## ---- Stochastic ----
OM <- readRDS("OM/Stochastic.om")
Hist <- readRDS("Hist/Stochastic.hist")

SProduction(Hist) |> dplyr::filter(TimeStep==max(TimeStep)) |>
  dplyr::summarise(Lower=quantile(Value, 0.025),
                   Median=median(Value),
                   Upper=quantile(Value, 0.975)) |>
  dplyr::mutate(Variable='SBiomass')

SP_SPMSY(Hist) |> dplyr::filter(TimeStep==max(TimeStep)) |>
  dplyr::summarise(Lower=quantile(Value, 0.025),
                   Median=median(Value),
                   Upper=quantile(Value, 0.975)) |>
  dplyr::mutate(Variable='SB/SBMSY')


F_FMSY(Hist) |> dplyr::filter(TimeStep==max(TimeStep)) |>
  dplyr::summarise(Lower=quantile(Value, 0.025),
                   Median=median(Value),
                   Upper=quantile(Value, 0.975)) |>
  dplyr::mutate(Variable='F/FMSY')

MSY(Hist) |> dplyr::filter(TimeStep==max(TimeStep)) |>
  dplyr::summarise(Lower=quantile(Value, 0.025),
                   Median=median(Value),
                   Upper=quantile(Value, 0.975)) |>
  dplyr::mutate(Variable='MSY')

## ---- Grid ----

# 
# SB_SBMSY(MSE) |> dplyr::group_by(MP, TimeStep) |>
#   dplyr::filter(Period=='Projection') |>
#   dplyr::summarise(Mean=mean(Value)) |>
#   tidyr::pivot_wider(names_from = MP, values_from = Mean) |>
#   print(n=90)
# 
# 
# Landings(MSE) |> dplyr::group_by(MP, TimeStep) |>
#   dplyr::filter(Period=='Projection') |>
#   dplyr::summarise(Mean=median(Value)) |>
#   tidyr::pivot_wider(names_from = MP, values_from = Mean) |>
#   print(n=90)

# ---- Projections ----
MSE <- readRDS('MSE/Stochastic.mse')
Slick <- readRDS('Slick/Stochastic.slick')
SlickGrid <- readRDS('Slick/Grid.slick')

size.title <- 12
size.axis.title <- 12
size.axis.text <- 10
size.mp.label <- 4
plotTimeseries(Slick, 4, targ_name = '', lim_name = '',
               includeHist = T,
               byMP=T,
               includeQuants = T, ncol=2,
               size.title = size.title,
               size.axis.title = size.axis.title,
               size.axis.text = size.axis.text,
               size.mp.label = size.mp.label)

ggsave("Figures/SB_SBMSY_Stochastic.png",
       width=4, height=6)

plotTimeseries(SlickGrid, 4, targ_name = '', lim_name = '',
               includeHist = T,
               byMP=T,
               includeQuants = T, ncol=2,
               size.title = size.title,
               size.axis.title = size.axis.title,
               size.axis.text = size.axis.text,
               size.mp.label = size.mp.label)

ggsave("Figures/SB_SBMSY_Grid.png",
       width=4, height=6)


t = plotQuilt(Slick, kable=TRUE)
flextable::save_as_image(t, 'Figures/Quilt_Stochastic.png')

t = plotQuilt(SlickGrid, kable=TRUE)
flextable::save_as_image(t, 'Figures/Quilt_Grid.png')


plotKobe(Slick, Time=T, ncol=2,
         axis.text.size = 10,
         axis.title.size = 12,
         strip.text.size = 12)
ggsave("Figures/KobeTime_Stochastic.png",
       width=4, height=4)

plotKobe(SlickGrid, Time=T, ncol=2,
         axis.text.size = 10,
         axis.title.size = 12,
         strip.text.size = 12)
ggsave("Figures/KobeTime_Grid.png",
       width=4, height=4)







plotTimeseries(Slick, 3, targ_name = '', lim_name = '',
               includeHist = T,
               byMP=T,
               includeQuants = T, ncol=2,
               size.title = size.title,
               size.axis.title = size.axis.title,
               size.axis.text = size.axis.text,
               size.mp.label = size.mp.label)

ggsave("Figures/Landings_Stochastic.png",
       width=4, height=6)












plotKobe(Slick, Time=T, ncol=2)
plotKobe(SlickGrid, Time=T, ncol=2)

plotQuilt(Slick, kable=TRUE)
plotQuilt(SlickGrid, kable=TRUE)

plotTimeseries(Slick, 4, targ_name = '', lim_name = '',
               includeHist = T,
               byMP=T,
               includeQuants = T, ncol=2)





plotTimeseries(SlickGrid, 4, targ_name = '', lim_name = '',
               includeHist = T,
               byMP=T,
               includeQuants = T, ncol=2)

               byMP=T,
               linewidth.median.line = linewidth.median.line, alpha1 =alpha1,
               quants1=c(0.1,.9), quants2=c(0,0),
               ncol=2)


plotTimeseries(Slick, 4, targ_name = '', lim_name = '',
               includeHist = F, byMP=T,
               linewidth.median.line = linewidth.median.line, alpha1 =alpha1,
               quants1=c(0.1,.9), quants2=c(0,0),
               ncol=2)

## ---- Stochastic 


## ---- Grid ----
MSEFiles <- list.files('MSE', full.names = TRUE)
GridMSEFiles <- MSEFiles[-c(grep("Stochastic.mse", MSEFiles),grep("Base.mse", MSEFiles))]
MSEList <- purrr::map(GridMSEFiles, readRDS)





SB_SBMSY(MSE)

apicalF(MSE) |> dplyr::filter(Period=='Projection') |>
  dplyr::group_by(MP) |>
  dplyr::summarise(max(Value))

Landings(MSE) |> dplyr::filter(MP=="CC1") |>
  dplyr::group_by(MP, TimeStep) |>
  dplyr::summarise(median(Value))


SlickGrid <- readRDS('Slick/Grid.slick')

plotQuilt(Slick)


plotKobe(Slick, Time=TRUE, ncol=2)


linewidth.median.line <- 1.1
alpha1 <- 0.9


# TODO - fix the quants stuff ..
# figure out correct way to plot mean vs median


plotTimeseries(Slick, 4, targ_name = '', lim_name = '',
               includeHist = F, byMP=T,
               linewidth.median.line = linewidth.median.line, alpha1 =alpha1,
               quants1=c(0.1,.9), quants2=c(0,0),
               ncol=2)
ggsave("Figures/SB_SBMSY_Stochastic.png",
       width=11, height=5.5)

# plotTimeseries(Slick, 5, targ_name = '', lim_name = '',
#                includeHist = F, byMP=T,
#                linewidth.median.line = linewidth.median.line, alpha1 =alpha1,
#                ncol=2)
# ggsave("Figures/F_FMSY_Stochastic.png",
#        width=11, height=5.5)


plotTimeseries(Slick, 3, targ_name = '', lim_name = '',
               includeHist = T, byMP=T,
               linewidth.median.line = linewidth.median.line, alpha1 =alpha1,
               ncol=2)
ggsave("Figures/Landings_Stochastic.png",
       width=11, height=5.5)

t = plotQuilt(Slick, kable=TRUE)
flextable::save_as_image(t, 'Figures/Quilt_Stochastic.png')

# Grid 
t = plotQuilt(SlickGrid, kable=TRUE)
flextable::save_as_image(t, 'Figures/Quilt_Grid.png')


plotTimeseries(SlickGrid, 4, targ_name = '', lim_name = '',
               includeHist = T, byMP=F, byOM=T, includeQuants = FALSE,
               includeLabels =FALSE,
               linewidth.median.line = 0.8, alpha1 =alpha1 )
ggsave("Figures/SB_SBMSY_Grid.png",
       width=11, height=5.5)




plotQuilt(Slick)
plotQuilt(SlickGrid)

plotQuilt(Slick, kable=TRUE)
plotQuilt(SlickGrid, kable=TRUE)


plotTimeseries(Slick, 3, byMP=TRUE)
plotTimeseries(SlickGrid, 3, byMP=TRUE)


L <- Landings(MSE)
L |> dplyr::filter()

L |> dplyr::filter(MP=='IT1') |>
  dplyr::group_by(TimeStep) |>
  dplyr::summarise(mean(Value))


TACs <- GetTAC(MSE)

TACs |> dplyr::filter(MP=='IT1') |>
  dplyr::filter(is.na(Value)==FALSE) |>
  dplyr::group_by(TimeStep) |>
  dplyr::summarise(Mean=mean(Value),
                   Max=max(Value))

df <- L |> dplyr::filter(MP=='IT1')

df |> dplyr::group_by(TimeStep) |>
  dplyr::summarise(Mean=mean(Value),
                   Upper=quantile(Value,0.6),
                   Max=max(Value)) |>
  print(n=30)


sim <- 200

ManagementTS <- TACs |> dplyr::filter(is.na(Value)==FALSE) |> dplyr::pull(TimeStep) |> unique()

List <- list()
for (i in seq_along(ManagementTS)) {
  tac = TACs |> dplyr::filter(MP=='IT1', TimeStep==ManagementTS[i], Sim==sim) |>
    dplyr::pull(Value)
  land = L |> dplyr::filter(MP=='IT1', TimeStep==ManagementTS[i], Sim==sim) |>
    dplyr::pull(Value)
  
  Data <- MSE@PPD$IT1[[sim]]$Albacore
  thistac <- Data@TAC |> MSEtool:::ArraySubsetTimeStep(ManagementTS[1]:ManagementTS[i]-1, AddPast = FALSE)
  Data <- Data |> DataTrim(ManagementTS[i]-1)
  Data@TAC <- thistac

  tac2 = IT1(Data)@TAC
  
  List[[i]] <- data.frame(TS=ManagementTS[i], TAC=tac, TAC2=tac2, Landing=land)
  
}

do.call('rbind', List)

library(MSEtool)

MSE <- readRDS('MSE/Stochastic.mse')
Data <- MSE@PPD$IT1[[sim]]$Albacore  
Data@TAC

Data2 <- Data |> DataTrim(TimeStep=2025)

Data2@TAC


DataTrim

function(Data, TimeStep) {
  CheckClass(Data, 'data', 'Data')
  
  if (!is.numeric(TimeStep))
    cli::cli_abort("`TimeStep` must be a numeric value")
  if (!length(TimeStep)==1)
    cli::cli_abort("`TimeStep` must be a numeric value length 1")
  
  TimeSteps <- Data@TimeSteps
  if (!TimeStep %in% TimeSteps)
    cli::cli_abort("{.var TimeStep} {.val {TimeStep}} is not in `TimeSteps(Data)`: {.val {TimeSteps(Data)}}")
  
  if (TimeStep == max(Data@TimeSteps))
    return(Data)
  
  
  OutTimeSteps <- TimeSteps[TimeSteps <= TimeStep]
  
  
  fl <- tempfile()
  fl
  saveRDS(Data@TAC, fl)
  
  OutData <- MSEtool:::SubsetTimeStep(Data, OutTimeSteps, AddPast=FALSE)
  
  cbind(Data@TAC,OutData@TAC)
  
  OutData@TimeSteps <- OutTimeSteps
  OutData
}


LastTAC <- function(Data) {
  CheckClass(Data, 'data', 'Data')
  LastTAC <- tail(Data@TAC[!is.na(Data@TAC)],1) |> as.numeric()
  if (length(LastTAC)<1)
    LastTAC <- sum(tail(Data@Landings@Value,1) + tail(Data@Discards@Value,1))
  LastTAC
}

LastTAC(Data)

