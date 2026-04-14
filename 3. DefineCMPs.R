
# ----- Surplus Production Model ----
SP_FMSY <- function(Data, MSY_frac=1, MaxChange=0.4, ...) {
  advice <- Advice()
  
  data <- new('Data')
  data@Year <- Data@Years
  data@LHYear <- Data@YearLH
  data@Cat <- matrix(rowSums(Data@Landings@Value), 1, length(data@Year))
  Index <- Data@Survey@Value[,1] # CTP-LL
  data@Ind <- matrix(Index, 1, length(data@Year))
  data@CV_Ind <- array(0.2, dim(data@Ind))
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
  
  data <- new('Data')
  data@Year <- Data@Years
  data@LHYear <- Data@YearLH
  data@Cat <- matrix(rowSums(Data@Landings@Value), 1, length(data@Year))
  Index <- Data@Survey@Value[,1] # CTP-LL
  data@Ind <- matrix(Index, 1, length(data@Year))
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
  
  data <- new('Data')
  data@Year <- Data@Years
  data@LHYear <- Data@YearLH
  data@Cat <- matrix(rowSums(Data@Landings@Value), 1, length(data@Year))
  Index <- Data@Survey@Value[,1] # CTP-LL
  data@Ind <- matrix(Index, 1, length(data@Year))
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

# ---- Stepped TAC ----

# Based on MCC methods adopted for NSWO 

MCC1 <- function(Data, tunepar = 1) {
  
  TACbase <- 20693 * tunepar # 2024 catch
  
  HistRefYears <- 2009:2012
  Index <- Data@Survey@Value[,1]
  ind <- match(HistRefYears, names(Index))
  
  Ibase <- mean(Index[ind], na.rm=TRUE)
  
  Icurr <- mean(tail(Index,3))
  
  Irat <- Icurr/Ibase
  
  fixed_low_TAC <- NULL  # initialize
  
  if (Irat>=1.70) {
    deltaTAC <- 1.70
  }
  if (Irat>=1.60 & Irat<1.70) {
    deltaTAC <- 1.60
  }
  if (Irat>=1.50 & Irat<1.60) {
    deltaTAC <- 1.50
  }
  if (Irat>=1.40 & Irat<1.50) {
    deltaTAC <- 1.40
  }
  if (Irat>=1.30 & Irat<1.40) {
    deltaTAC <- 1.30
  }
  if (Irat>=1.20 & Irat<1.30) {
    deltaTAC <- 1.20
  }
  if (Irat>=0.75 & Irat<1.20) {
    deltaTAC <- 1
  }
  if (Irat>=0.5 & Irat<0.75) {
    deltaTAC <- 0.75
  }
  if (Irat<0.5) {
    fixed_low_TAC <- 5000
  }
  
  if (is.null(fixed_low_TAC)) {
    TAC <- TACbase * deltaTAC
  } else {
    TAC <- fixed_low_TAC
  }
  Advice(TAC=TAC)
}
class(MCC1) <- 'mp'

MCC2 <- MCC1
formals(MCC2)$tunepar <- 1.1
class(MCC2) <- 'mp'




