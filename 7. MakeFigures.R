library(MSEtool)
library(Slick)

Slick <- readRDS('Slick/Stochastic.slick')
SlickGrid <- readRDS('Slick/Grid.slick')


plotQuilt(Slick)
plotQuilt(SlickGrid)

plotQuilt(Slick, kable=TRUE)
plotQuilt(SlickGrid, kable=TRUE)


plotTimeseries(Slick, 3, byMP=TRUE)

L <- Landings(MSE)
L |> dplyr::filter()

L |> dplyr::filter(MP=='IT1') |>
  dplyr::group_by(TimeStep) |>
  dplyr::summarise(max(Value))


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


Data <- MSE@PPD$IT1[[sim]]$Albacore  |> DataTrim(TimeStep=ManagementTS[i]-1)
Data@TAC

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
    LastTAC <- tail(Data@Catch@Value,1) |> sum()
  LastTAC
}

LastTAC(Data)

