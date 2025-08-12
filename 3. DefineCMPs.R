

SP1 <- function(Data, MSY_frac=0.75, MaxChange=0.3, ...) {
  advice <- Advice()
  
  do_Assessment <- SAMtool::SP(x = 1, Data = data2Data(Data))
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
class(SP1) <- 'mp'

SP2 <- SP1
formals(SP2)$MSY_frac <- 0.5
class(SP2) <- 'mp'
  
IT1 <- function(Data, MaxChange=0.3, Imulti=1) {
  advice <- Advice()
  
  Rec <- DLMtool:::Itarget1(1, data2Data(Data), reps=1, Imulti=Imulti)
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
class(IT1) <- 'mp'


IT2 <- IT1
formals(IT2)$MSY_frac <- 0.5
class(IT2) <- 'mp'

CC1<- function(Data) {
  advice <- Advice()
  advice@TAC <- 15000
  advice
}
class(CC1) <- 'mp'

CC2 <- function(Data) {
  advice <- Advice()
  advice@TAC <- 20000
  advice
}
class(CC2) <- 'mp'
