source('Condition/Specifications.R')

pak::pkg_install('tmvtnorm')
pak::pkg_install('James-Thorson-NOAA/FishLife')

# Assumptions:
# - natural mortality (M) is log-normally distributed with mean M_mu and SD M_sd specified in LifeHistoryParameters.R
# - steepess (h) is log-normally distributed with mean h_mu and SD h_sd specified in LifeHistoryParameters.R
# - log-normal distributions are truncated at 1.96 SD
# - correlation between M & h taken from FishLife estimates for Thunnus alalunga

# Note: this methodology is adapted from the Southern Swordfish MSE work developed
#       by Nathan Taylor (ICCAT)

truncSD <- 1.96

# Correlation Matrix from FishLife
FL <- FishLife::Plot_taxa(FishLife::Search_species(
  Genus='Thunnus',Species='alalunga')$match_taxonomy, mfrow=c(3,2))[[2]]

cor <- stats::cov2cor(FL$Cov_pred[ind, ind]) 
diag(cor) <- NA
cor <- cor |>  dplyr::as_tibble() |>
  dplyr::mutate(term=colnames(cor)) |>
  dplyr::relocate(term)
class(cor) <-c("cor_df", "tbl_df", "tbl", "data.frame")

cor.mat <- cor |>
  corrr::focus(c('M', 'h'), mirror = TRUE) |>
  dplyr::arrange(match(term, c('M', 'h'))) |>
  dplyr::select(-term) |>
  as.matrix()
diag(cor.mat) <- 1


means <- c(M_mu, h_mu) |> log()
sds <- c(M_sd, h_sd)


# very weak correlation
covar <- cor.mat *as.matrix(sds) %*% t(as.matrix(sds))
colnames(covar) <- NULL
lower <- means - sds*truncSD
upper <- means + sds*truncSD

Vals <- tmvtnorm::rtmvnorm(nsim,
                           mean = means,
                           sigma = covar,
                           lower=lower,
                           upper=upper) |>
  exp()

ValsDF <- data.frame(M=Vals[,1], h=Vals[,2])

panel.hist <- function(x, ...) {
  usr <- par("usr")
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col = "darkgray", ...)
}

pairs(ValsDF, pch=16, diag.panel=panel.hist)

write.csv(ValsDF, 'Condition/LHSamples.csv', row.names = FALSE)

