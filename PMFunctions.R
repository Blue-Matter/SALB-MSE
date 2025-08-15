Status <- function(MSE) {
  FFMSY <- F_FMSY(MSE) |> dplyr::filter(Period=='Projection') 
  SBSBMSY <- SB_SBMSY(MSE) |> dplyr::filter(Period=='Projection')
  
  dplyr::bind_rows(SBSBMSY, FFMSY) |> 
    dplyr::select(Sim, TimeStep, Value, Variable, MP) |>
    tidyr::pivot_wider(names_from = Variable, values_from = Value) |>
    dplyr::mutate(Green=SB_SBMSY>=1 & F_FMSY<=1) |>
    dplyr::group_by(MP) |>
    dplyr::summarise(Value=mean(Green),
                     Variable="Status")
  
}


Safety <- function(MSE, Ref=0.4) {
  SB_SBMSY(MSE) |> 
  dplyr::filter(Period=='Projection') |>
  dplyr::group_by(MP) |>
  dplyr::summarise(Value=mean(Value>Ref),
                   Variable='Safety')
}

MeanLandings <- function(MSE) {
  Landings(MSE) |> dplyr::filter(Period=='Projection') |>
    dplyr::group_by(MP) |>
    dplyr::summarise(Value=mean(Value),
                     Variable='Mean Landings')
}

# TODO - add to MSEtool


CalcVar <- function(vals) {
  ind <- seq_along(vals)
  ind1 <- ind[1:(length(ind)-1)]
  ind2 <- ind[2:length(ind)]
  sqrt(((vals[ind1]-vals[ind2])/vals[ind2])^2) |> mean() 
}

AvgVar <- function(MSE, type=c('TAC', 'Landings', 'Removals')) {
  type <- match.arg(type)
  if (type != 'TAC')
    cli::cli_abort("Only `type='TAC'` currently supported", .internal=TRUE)
  
  TACs(MSE) |> dplyr::filter(is.na(Value)==FALSE) |>
    dplyr::group_by(Sim, MP) |>
    dplyr::reframe(Value=CalcVar(Value),
                   Variable=paste0('AvgVar', type)) 
}


Stability <- function(MSE, type=c('TAC', 'Landings', 'Removals')) {
  type <- match.arg(type)
  
  Variable <- paste0('AvgVar', type)
  
  AvgVar(MSE, type) |>
    dplyr::group_by(MP) |>
    dplyr::summarise(Value=mean(Value)) |>
    dplyr::ungroup() |>
    dplyr::mutate(Variable=Variable)
}

