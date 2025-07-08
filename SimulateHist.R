
# RCM ----
OM_Mean <- readRDS('OM/RCM_Mean.om')
Hist_Mean <- Simulate(OM_Mean)
saveRDS(Hist_Mean, 'Hist/RCM_Mean.hist')


OM_Stochastic <- readRDS('OM/RCM_Stochastic.om')
Hist_Stochastic <- Simulate(OM_Stochastic)
saveRDS(Hist_Stochastic, 'Hist/RCM_Stochastic.hist')


HistYears <- seq(OM_Mean@CurrentYr, by=-1, length.out=OM_Mean@nyears) |> rev()

SB_SBMSY_Mean <- apply(Hist_Mean@TSdata$SBiomass, 1:2, sum)/matrix(Hist_Mean@Ref$ReferencePoints$SSBMSY, OM_Mean@nsim, OM_Mean@nyears, byrow=FALSE)
dimnames(SB_SBMSY_Mean) <- list(Sim=1:OM_Mean@nsim,
                                Year=HistYears)
SB_SBMSY_Stochastic <- apply(Hist_Stochastic@TSdata$SBiomass, 1:2, sum)/matrix(Hist_Stochastic@Ref$ReferencePoints$SSBMSY, OM_Mean@nsim, OM_Mean@nyears, byrow=FALSE)

dimnames(SB_SBMSY_Stochastic) <- list(Sim=1:OM_Mean@nsim,
                                Year=HistYears)


SB_SBMSY_Mean <- array2DF(SB_SBMSY_Mean)
SB_SBMSY_Mean$Year <- as.numeric(SB_SBMSY_Mean$Year)
SB_SBMSY_Mean$Value <- as.numeric(SB_SBMSY_Mean$Value)
SB_SBMSY_Mean$Model <- 'Mean'

SB_SBMSY_Stochastic <- array2DF(SB_SBMSY_Stochastic)
SB_SBMSY_Stochastic$Year <- as.numeric(SB_SBMSY_Stochastic$Year)
SB_SBMSY_Stochastic$Value <- as.numeric(SB_SBMSY_Stochastic$Value)
SB_SBMSY_Stochastic$Model <- 'Stochastic'

df <- dplyr::bind_rows(SB_SBMSY_Mean, SB_SBMSY_Stochastic)


library(ggplot2)
ggplot(df, aes(x=Year, y=Value, group=Sim)) +
  facet_wrap(~Model) +
  geom_line() +
  expand_limits(y=0) +
  labs(y='SB/SBMSY') +
  geom_hline(yintercept =1, linetype=2) +
  theme_bw()

M <- Hist_Stochastic@SampPars$Stock$M_ageArray[,1,1]
h <- Hist_Stochastic@SampPars$Stock$hs

DF2 <- data.frame(Sim=as.character(1:OM_Mean@nsim), M=M, h=h) 

DF2 <- dplyr::left_join(SB_SBMSY_Stochastic |> dplyr::filter(Year==max(Year)), DF2)

ggplot(DF2, aes(x=M, y=Value, color=h)) +
  geom_point()

ggplot(DF2, aes(x=h, y=Value, color=M)) +
  geom_point()

DF2 |> dplyr::filter(Value < 0.95)
