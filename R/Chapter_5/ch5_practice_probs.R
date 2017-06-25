


### EASY ###   
### 5E1 ###
# Which of the following are multiple linear regressions
# (1) mu = alpha + beta(x)
# (2) mu = betax(x) + betaz(z)
# (3) mu = alpha + beta(x - z)
# (4) mu = alpha + betax(x) + betaz(z)
#
# (2) and (4) are
# (1) only contains 1 predictor
# (3) uses (x-z) as 1 variable


### 5E2 ###
# Write the mode definition for "Animal diversity is linearly
# Related to latitude, but only after controlling for plant
# Diversity."
alist(animal_diversity ~ dnorm(mu, sigma),
      mu <- a + bl*latitude + bp*plant_diversity,
      a <- dnorm(...),
      bl <- dnorm(0, ...),
      br <- dnorm(0, ...),
      sigma <- dunif(0, ...))


### 5E3 ###
# Write down model definition for "Together ... are both
# Positively associated with time to degree" and indicate
# The sign of the coefficients
alist(time_to_degree ~ dnorm(mu, sigma),
      mu <- a + bf*funding + bs*size_of_lab,
      a <- dnorm(...),
      bf <- dnorm(0, ...),
      bs <- dnorm(0, ...),
      sigma <- dunif(0, ...))
# The sign of both bf and bs should be positive


### 5E4 ###
# Suppose you have a categorical variable with 4 unique values,
# A, B, C, and D. Upper-case letter variables are indicators of the
# Equivalent category. Which models are inferentially equivalent;
# That is, you can get all the same information
# (1) mu = a + bA(A) + bB(b) + bD(D)
# (2) mu = a + bA(A) + bB(B) + bC(C) + bD(D)
# (3) mu = a + bB(B) + bC(C) + bD(D)
# (4) mu = aA(A) + aB(B) + aC(C) + aD(D)
# (5) mu = aA(1 - B - C - D) + aB(B) + aC(C) + aD(D)
#
# (2), (4), and (5) are both wrong because they leave no category as an intercept
# (1) and (3) are different approaches to the same, correct thing


### MEDIUM ###
### 5M1 ###
# Invent a sprurious correlation
# Number of cases
N <- 1000
# The real and spurious predictor
x_real <- rnorm(N)
x_spur <- rnorm(N,
                mean = x_real)      # This part is key
# The outcome
y <- rnorm(N, mean = x_real)
# Bind them into df
d <- data.frame(y, x_real, x_spur)
# View it
pairs(d)
# Make sure package is loaded
library(rethinking)
# Model to view coefficients
precis(map(alist(y ~ dnorm(mu, sigma),
                 mu <- a + bs*x_spur + br*x_real,
                 a <- dnorm(0, 5),
                 bs <- dnorm(0, 2),
                 br <- dnorm(0, 2),
                 sigma <- dunif(0, 2)),
           data = d))


### 5M2 ###
# Invent a masked relationship
# Set the correlation coefficient for the predictors
rho <- 0.97
# The conflicting predictors
x_pos <- rnorm(N)
x_neg <- rnorm(N, mean = rho*x_pos, sd = sqrt(1 - rho^2))
# The outcome
y <- rnorm(N,
           mean = x_pos - x_neg)   # This creates the masking
# Make into df
d <- data.frame(y, x_pos, x_neg)
# View it
pairs(d)
# Model to view coefficients
# When using x_pos
precis(map(alist(y ~ dnorm(mu, sigma),
                 mu <- a + bp*x_pos,
                 a <- dnorm(0, 5),
                 bp <- dnorm(0, 2),
                 sigma <- dunif(0, 2)),
           data = d))
# When using x_neg
precis(map(alist(y ~ dnorm(mu, sigma),
                 mu <- a + bn*x_neg,
                 a <- dnorm(0, 5),
                 bn <- dnorm(0, 2),
                 sigma <- dunif(0, 2)),
           data = d))
# When using both - notice how the huge difference
# In coefficients when compared to the first two models
# First two are centered on 0
# Here they are centered on 1 and -1
precis(map(alist(y ~ dnorm(mu, sigma),
                 mu <- a + bp*x_pos + bn*x_neg,
                 a <- dnorm(0, 5),
                 bp <- dnorm(0, 2),
                 bn <- dnorm(0, 2),
                 sigma <- dunif(0, 2)),
           data = d))


### 5M3 ###
# Fires cause more firefights, which can, by themselves, be correlated
# With fire risk
# Similarly, more marriages mean more divorces, which can, by itself,
# Be correlated with more marriages
# A simple way to show that number of marriages is the true predictor, while
# Divorce rate have essentially no effect would be...
# precis(map(alist(marriage_rate ~ dnorm(mu, sigma),
#                  mu <- a + bD(divorce_rate) + bT(total_marriages),
#                  a <- dnorm(...),
#                  bD <- dnorm(0, ...),
#                  bT <- dnorm(0, ...),
#                  sigma <- dunif(0, ...)),
#            data = d))


### 5M4 ###
data("WaffleDivorce")
d <- WaffleDivorce
str(d)

# Scrape some LDS-by-state info
# Set up
library(xml2)
library(dplyr)
library(rvest)

# Fetch the page
webpage <- read_html("https://en.wikipedia.org/wiki/The_Church_of_Jesus_Christ_of_Latter-day_Saints_membership_statistics_(United_States)")

# Get the table as a dataframe
tbls <- html_nodes(webpage, "table") %>%
  .[2] %>%
  html_table(fill = TRUE, header = 1) %>%
  as.data.frame()
# View table
tbls

# Only columns I need
tbls <- select(tbls, c(State, LDS))
# Get rid of percent signs
tbls$LDS <- gsub("%", "", tbls$LDS) %>%
  as.numeric()
# Make state a factor
tbls$State <- tbls$State %>% factor()
# Rename state to same name
tbls$Location <- tbls$State
# Get rid of extra rows
tbls <- filter(tbls, Location != "Totals")
tbls <- filter(tbls, Location != "Nevada")

# Bind the two
d <- cbind(tbls, d)

# Quick view
pairs(~Divorce + LDS + Marriage + MedianAgeMarriage, data = d, col = rangi2)

# Standardize function
standardize <- function(x) {
  numerator <- x - mean(x)
  standardized <- numerator / sd(x)
  return(standardized)
}

# Use new function
d$LDS_s <- standardize(d$LDS)
d$Marriage_s <- standardize(d$Marriage)
d$MedianAgeMarriage_s <- standardize(d$MedianAgeMarriage)

# Another quick view
pairs(~Divorce + LDS_s + Marriage_s + MedianAgeMarriage_s,
      data = d, col = rangi2)

# Make and fit model
LDS_model <- map(alist(Divorce ~ dnorm(mu, sigma),
                       mu <- a + bl*LDS_s + bm*Marriage_s + bMAM*MedianAgeMarriage_s,
                       a ~ dnorm(0, 5),
                       c(bl, bm, bMAM) ~ dnorm(0, 2),
                       sigma ~ dunif(0, 3)),
                 data = d)
precis(LDS_model)


### 5M5 ###
# Its sometimes argued that higher gas prices are associated with
# lower obesity
# There are important things to consider
# Higher gas -> Less driving? -> more exercise
# Higher gas -> Less eating out?
# Make a model to address this
# precis(map(alist(obesity_rate ~ dnorm(mu, sigma),
#                  mu <- a + bg*gas_price + bet*avg_exercise_time + beo*avg_times_eat_out_per_week,
#                  ....)))


### 5H1 ###
# This is the data
data(foxes)
d <- foxes
str(d)
# Fit two bivariate linear regressions
# (1) Body weight as a function of territory size
area_mod <- map(alist(weight ~ dnorm(mu, sigma),
                      mu <- a + ba*area,
                      a <- dnorm(0, 100),
                      ba <- dnorm(0, 10),
                      sigma <- dunif(0, 50)),
                data = d)
precis(area_mod)
# All the plotting
area_seq <- seq(1, 5.25, length.out = 50)
mu <- link(area_mod, data = data.frame(area = area_seq))
mu_mean <- apply(mu, 2, mean)
mu_PI <- apply(mu, 2, PI)
pred_weight <- sim(area_mod, data = data.frame(area = area_seq), n = 1e4)
weight_PI <- apply(pred_weight, 2, PI)
plot(weight ~ area, data = d, pch = 16)
lines(area_seq, mu_mean)
shade(mu_PI, area_seq)
shade(weight_PI, area_seq)

# (2) Body weight as a function of territory size
group_mod <- map(alist(weight ~ dnorm(mu, sigma),
                       mu <- a + bg*groupsize,
                       a <- dnorm(0, 100),
                       bg <- dnorm(0, 10),
                       sigma <- dunif(0, 50)),
                 data = d)
precis(group_mod)
# All the plotting
group_seq <- seq(2, 8, length.out = 50)
mu <- link(group_mod, data = data.frame(groupsize = group_seq))
mu_mean <- apply(mu, 2, mean)
mu_PI <- apply(mu, 2, PI)
pred_weight <- sim(group_mod, data = data.frame(groupsize = group_seq), n = 1e4)
weight_PI <- apply(pred_weight, 2, PI)
plot(weight ~ groupsize, data = d, pch = 16)
lines(group_seq, mu_mean)
shade(mu_PI, group_seq)
shade(weight_PI, group_seq)
# Territory area is not important by itself
# Group size is weakly associated with weight by itself


### 5H2 ###
# Use the two predictors above ina multiple linear regression
both_mod <- map(alist(weight ~ dnorm(mu, sigma),
                      mu <- a + bg*groupsize + ba*area,
                      a <- dnorm(0, 100),
                      bg <- dnorm(0, 10),
                      ba <- dnorm(0, 10),
                      sigma <- dunif(0, 50)),
                data = d)
precis(both_mod)

group_avg <- mean(d$groupsize)
pred_data <- data.frame(area = area_seq,
                        groupsize = group_avg)

mu <- link(both_mod, data = pred_data)
mu_mean <- apply(mu, 2, mean)
mu_PI <- apply(mu, 2, PI)

pred_weight <- sim(both_mod, data = pred_data, n = 1e4)
weight_PI <- apply(pred_weight, 2, PI)


