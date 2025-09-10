
# ----- Surplus Production Model ----
SP_FMSY <- function(Data, MSY_frac=1, MaxChange=0.4, ...) {
  advice <- Advice()

  data <- data2Data(Data, 'Survey')
  data@Year <- data@Year[1:length(data@Cat[1,])]
  do_Assessment <- SAMtool::SP(x = 1, Data = data)
  Rec <- SAMtool::HCR_MSY(Assessment = do_Assessment, MSY_frac = MSY_frac)

  NewTAC <- as.numeric(Rec@TAC)
  LastTAC <- LastTAC(Data)
  
  if (!is.finite(NewTAC)) {
    NewTAC <- LastTAC
    advice@Log <- list(warning="non-finite TAC; using previous TAC")
  }
    
  
  deltaTAC <- NewTAC/LastTAC
  if (deltaTAC>(1+MaxChange)) {
    NewTAC <- LastTAC * (1+MaxChange)
  }
  if (deltaTAC<(1-MaxChange)) {
    NewTAC <- LastTAC * (1-MaxChange)
  }
  
  advice@TAC <- NewTAC
  advice
}
class(SP_FMSY) <- 'mp'


SP_75FMSY <- SP_FMSY
formals(SP_75FMSY)$MSY_frac <- 0.75
class(SP_75FMSY) <- 'mp'

# ---- Index Ratio ----

IRatio <- function(Data, MaxChange=0.4) {
  advice <- Advice()
  data <- data2Data(Data, 'Survey')
  data@Year <- data@Year[1:length(data@Cat[1,])]
  Rec <- DLMtool::Iratio(1, data, reps=1)
  NewTAC <- as.numeric(Rec@TAC)
  LastTAC <- LastTAC(Data)
  if (!is.finite(NewTAC)) {
    NewTAC <- LastTAC
    advice@Log <- list(warning="non-finite TAC; using previous TAC")
  }
  
  deltaTAC <- NewTAC/LastTAC
  if (deltaTAC>(1+MaxChange)) {
    NewTAC <- LastTAC * (1+MaxChange)
  }
  if (deltaTAC<(1-MaxChange)) {
    NewTAC <- LastTAC * (1-MaxChange)
  }

  advice@TAC <- NewTAC
  advice
}
class(IRatio) <- 'mp'

ISlope <- function(Data, MaxChange=0.4) {
  data <- data2Data(Data, 'Survey')
  data@Year <- data@Year[1:length(data@Cat[1,])]
  Rec <- DLMtool::Islope1(1, data, reps=1, xx=0)
  NewTAC <- as.numeric(Rec@TAC)
  LastTAC <- LastTAC(Data)
  if (!is.finite(NewTAC)) {
    NewTAC <- LastTAC
    advice@Log <- list(warning="non-finite TAC; using previous TAC")
  }
  
  deltaTAC <- NewTAC/LastTAC
  if (deltaTAC>(1+MaxChange)) {
    NewTAC <- LastTAC * (1+MaxChange)
  }
  if (deltaTAC<(1-MaxChange)) {
    NewTAC <- LastTAC * (1-MaxChange)
  }
  
  advice <- Advice()
  advice@TAC <- NewTAC
  advice
}
class(ISlope) <- 'mp'

# ---- Constant Catch ----

CC24000 <- function(Data) {
  advice <- Advice()
  advice@TAC <- 24000
  advice
}
class(CC24000) <- 'mp'


CC28000 <- function(Data) {
  advice <- Advice()
  advice@TAC <- 28000
  advice
}
class(CC28000) <- 'mp'

