library(MSEtool)
library(ggplot2)

Hist <- readRDS('Hist/Base_Updated.hist')


CPUE <- Hist@Data$`1`$Albacore@Survey@Value |> 
  Array2DF() |> 
  dplyr::group_by(Fleet) |>
  dplyr::mutate(Value=Value/mean(Value, na.rm=TRUE))

ggplot(CPUE, aes(x=Year, y=Value)) +
  facet_wrap(~Fleet) +
  geom_line(linewidth=1.2) +
  expand_limits(y=0) +
  labs(y='CPUE Index') +
  theme_bw()

ggsave('Figures/Updated_OM/Indices.png',width=12, height=4)

Landings <- Hist@Data$`1`$Albacore@Landings@Value |> 
  Array2DF()

ggplot(Landings, aes(x=Year, y=Value)) +
  facet_wrap(~Fleet) +
  geom_line(linewidth=1.2) +
  expand_limits(y=0) +
  labs(y='Catch (ton)') +
  theme_bw()

ggsave('Figures/Updated_OM/Landings.png',width=12, height=6)

ggplot(Landings |> dplyr::group_by(Year) |> dplyr::mutate(Value=sum(Value)), aes(x=Year, y=Value)) +
  
  geom_line(linewidth=1.2) +
  expand_limits(y=0) +
  labs(y='Catch (ton)') +
  theme_bw()

ggsave('Figures/Updated_OM/Landings_2.png',width=12, height=6)

# ---- Get SS3 Reference Points ----

SSDir <- "G:/Shared drives/BM shared/1. Projects/TOF-MSE-SALB/ALB_test__CHI_cpue_update"
RepList <- ImportSSReport(SSDir)
replist <- RepList[[1]]
SSB_MSY_num <- replist$derived_quants |> dplyr::filter(Label=='SSB_MSY') |> dplyr::pull('Value')
MSY_num <- replist$derived_quants |> dplyr::filter(Label=='Ret_Catch_MSY') |> dplyr::pull('Value')

SSB_MSY <- array(SSB_MSY_num, dim=c(1,1,1),
      dimnames = list(
        Sim = 1,
        Stock = StockNames(Hist),
        Year = Years(Hist, 'H')[1]
      )) # Sim, Stock, Year



# ---- Historical ----

Hist@Reference@MSY@SPMSY <- SSB_MSY

SB_SBMSY <- ArrayDivide(Hist@SProduction, Hist@Reference@MSY@SPMSY) |>
  Array2DF() 

ggplot(SB_SBMSY, aes(x=Year, y=Value)) +
  geom_line(linewidth=1.2) + 
  expand_limits(y=0) +
  theme_bw() +
  labs(y='SB/SBMSY') +
  geom_hline(yintercept = 1, linetype=2)

ggsave('Figures/Updated_OM/SB_SBMSY.png', width=12, height=6)


# ----- Projection ----
MSE <- readRDS('MSE/Base_Updated.mse')


SProduction_Hist <- Hist@SProduction |> Array2DF() |>
  dplyr::mutate(MP='Historical') |>
  dplyr::mutate(Value=Value/SSB_MSY_num)

SProduction_Proj <- MSE@SProduction  |> Array2DF() |>
  dplyr::mutate(Value=Value/SSB_MSY_num) |>
  dplyr::group_by(Year, MP) |>
  dplyr::summarise(Median=median(Value),
                   Lower=quantile(Value, 0.05),
                   Upper=quantile(Value, 0.10))


ggplot() +
  geom_line(aes(x=Year, y=Value), data=SProduction_Hist, linewidth=1.2) + 
  geom_line(aes(x=Year, y=Median, color=MP), data=SProduction_Proj, linewidth=1.2) +
  expand_limits(y=0) +
  theme_bw() +
  labs(y='SB/SBMSY') +
  geom_hline(yintercept = 1, linetype=2)


ggsave('Figures/Updated_OM/SB_SBMSY_proj.png', width=12, height=6)



Landings_Hist <- Hist@Landings |> 
  SumOverFleet() |>
  Array2DF() |>
  dplyr::mutate(MP='Historical') 


Landings_Proj <- MSE@Landings |> 
  SumOverFleet() |>
  Array2DF() |>
  dplyr::group_by(Year, MP) |>
  dplyr::summarise(Median=median(Value),
                   Lower=quantile(Value, 0.05),
                   Upper=quantile(Value, 0.10))
  
ggplot() +
  geom_line(aes(x=Year, y=Value), data=Landings_Hist, linewidth=1.2) + 
  geom_line(aes(x=Year, y=Median, color=MP), data=Landings_Proj, linewidth=1.2) +
  expand_limits(y=0) +
  theme_bw() +
  labs(y='Catch (ton)') 

ggsave('Figures/Updated_OM/Catch_proj.png', width=12, height=6)





library(Slick)

Slick <- Slick::Slick()
Slick@Timeseries <- MSEtool:::MSE2Timeseries(MSE,
                                             Code  = c('SB_SBMSY', 'Landings'),
                                             Label = c('SB/SBMSY', 
                                                       'Landings'))


saveRDS(Slick, 'Slick/Stochastic.slick')




