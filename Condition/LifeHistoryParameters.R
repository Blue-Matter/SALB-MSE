################################################
#                                              #
# Assumed Life History Parameters for SALB MSE #
#                                              #
################################################

# See TS Document (TS/TS.Rmd) for justifications for these parameters
# Update TS document with any changes made here

# July 2025: Currently assuming uncertainty in natural mortality (M) and steepness (h)



# ---- Natural Mortality ----

M_range <- c(0.3, 0.4)

M_mu <- mean(M_range)



# ---- Length-at-Age ----

Linf_mu <- 147.5 
K_mu <- 0.126
t0_mu <- -1.89

# ---- Length-Weight ----

Wa_mu <- 1.3718E-5 
Wb_mu <-  3.09773

# ---- Maturity ----

L50_mu <- 89.7 
L95_mu <- 94

# ---- Stock Recruit ----

h_range <- c(0.7, 0.9)

h_mu <- mean(h_range)


PE_mu <- 0.4

