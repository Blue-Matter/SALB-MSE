library(openMSE)
library(ggplot2)

RCMData <- readRDS('Condition/SALB.rcmdata')


Catch <- array2DF(RCMData@Chist, 'Catch') 
Catch$Year <- as.numeric(Catch$Year)

ggplot(Catch, aes(x=Year, y=Catch)) +
  facet_wrap(~Fleet, scales='free_y') +
  geom_line() +
  theme_bw()


Catch |> dplyr::group_by(Fleet) |>
  dplyr::filter(Catch>0.1) |>
  dplyr::summarise(First=min(Year),
                   Last=max(Year))





Indices <- array2DF(RCMData@Index, 'Index') 
Indices$Year <- as.numeric(Indices$Year)

Indices <- Indices |> 
  dplyr::group_by(Fleet) |>
  dplyr::mutate(Index=Index/mean(Index, na.rm=TRUE))
  

ggplot(Indices, aes(x=Year, y=Index)) +
  facet_wrap(~Fleet, scales='free_y') +
  geom_line() +
  expand_limits(y=0)+
  theme_bw()


Indices |> dplyr::group_by(Fleet) |>
  dplyr::filter(is.na(Index)==FALSE) |>
  dplyr::summarise(First=min(Year),
                   Last=max(Year))



CAL <- array2DF(RCMData@CAL, 'CAL') 
CAL$Year <- as.numeric(CAL$Year)
CAL$Class <- as.numeric(CAL$Class)

CAL <- CAL |>
  dplyr::group_by(Fleet) |>
  dplyr::filter(is.na(CAL)==FALSE, CAL>0.01) |>
  dplyr::group_by(Fleet, Class) |>
  dplyr::summarise(CAL=sum(CAL)) |>
  dplyr::group_by(Fleet) |>
  dplyr::mutate(n=sum(CAL), CAL=CAL/n) 
  

CALn <- CAL |> dplyr::group_by(Fleet) |>
  dplyr::summarise(n=unique(n),
                   Class=min(Class))

ggplot(CAL) +
  facet_wrap(~Fleet, scales='free_y') +
  geom_line(linewidth=0.8, aes(x=Class, y=CAL)) +
  expand_limits(y=0)+
  geom_text(data=CALn, aes(x=-Inf, y=0.5* Inf, label=paste('n = ', n)), hjust=-0.1, vjust=2) +
  theme_bw() +
  labs(x='Length Class (cm)',
       y='Relative Number')


