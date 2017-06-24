


# Load data
library(rethinking)

data("WaffleDivorce")
d <- WaffleDivorce

# Standardize the predictor - good habit to get into
d$MedianAgeMarriage_s <- (d$MedianAgeMarriage - mean(d$MedianAgeMarriage)) /
  sd(d$MedianAgeMarriage)

# Fit the model
m5_1 <- map(alist(Divorce ~ dnorm(mu, sigma),
                  mu <- a + bA*MedianAgeMarriage_s,
                  a ~ dnorm(10, 10),
                  bA ~ dnorm(0, 1),
                  sigma ~ dunif(0, 10)),
            data = d)

# Get PI for mean
MAM_seq <- seq(from = -3, to = 3.5, length.out = 30)
mu <- link(m5_1, data = data.frame(MedianAgeMarriage_s = MAM_seq))
mu_PI <- apply(mu, 2, PI)

# Plot it
plot(Divorce ~ MedianAgeMarriage_s, data = d)
abline(m5_1, col = "red", lwd = 2)
shade(mu_PI, MAM_seq)

# Inspect
precis(m5_1)
# Each standard deviation of MedianAgeMarriage results in
# A reliably negative change between -0.72 and -1.37
# This means ~1 less divorce per thousand for +1 standard
# Deviation of MedianAgeMarriage


# Other model/plot
d$Marriage_s <- (d$Marriage - mean(d$Marriage)) / sd(d$Marriage)

m5_2 <- map(alist(Divorce ~ dnorm(mu, sigma),
                  mu <- a + bR*Marriage_s,
                  a ~ dnorm(10, 10),
                  bR ~ dnorm(0, 1),
                  sigma ~ dunif(0, 10)),
            data = d)

M_seq <- seq(from = -2, to = 3, length.out = 30)
mu <- link(m5_2, data = data.frame(Marriage_s = M_seq))
mu_PI <- apply(mu, 2, PI)

plot(Divorce ~ Marriage_s, data = d)
abline(m5_2, col = "red", lwd = 2)
shade(mu_PI, M_seq)

precis(m5_2)
# This shows +0.27 to +1.02 divorces / thousand when
# Marriage rate goes up by 1 standard deviation


# Fit lmultivariate regression
m5_3 <- map(alist(Divorce ~ dnorm(mu, sigma),
                  mu <- a + bR*Marriage_s + bA*MedianAgeMarriage_s,
                  a ~ dnorm(10, 10),
                  bR ~ dnorm(0, 1),
                  bA ~ dnorm(0, 1),
                  sigma ~ dunif(0, 10)),
            data = d)

precis(m5_3)
# Now the coefficient for marriage rate is between
# -0.58 and 0.31, mean at -0.13
# Also, the coefficient for median age is between
# -0.69 and -1.58, slightly further from 0

# Visualize
plot(precis(m5_3))
# This all can be interpretted as "Once you know median age,
# There is little to no additional predictive power gained
# In also knowing the rate of marriage in that State."


# Predictor residual plot
# Model 1 predictor by the other
m5_4 <- map(alist(Marriage_s ~ dnorm(mu, sigma),
                  mu <- a + b*MedianAgeMarriage_s,
                  a ~ dnorm(0, 10),
                  b ~ dnorm(0, 1),
                  sigma ~ dunif(0, 10)),
            data = d)

# Compute residuals
# Get expected standardized Marriage rate for each state
mu <- coef(m5_4)['a'] + coef(m5_4)['b']*d$MedianAgeMarriage_s

# Get the residual for each
m_resid <- d$Marriage_s - mu

# View points
plot(Marriage_s ~ MedianAgeMarriage_s, d, cex = 1.25)
# Plus line
abline(m5_4, lwd = 3, col = "red")
# Plus residuals
for (i in 1:length(m_resid)) {
  x <- d$MedianAgeMarriage_s[i]
  y <- d$Marriage_s[i]
  lines(c(x,x), c(mu[i], y), lwd = 0.65,
        col = col.alpha("black", 0.3))
}


# Plot outcome as a function of these residuals
plot(d$Divorce ~ m_resid,
     xlab = "Marriage Rate Residuals",
     ylab = "Divorce Rate")
# Dashed line shows no deviation from expected marriate rate
abline(v = 0, lty = 2, lwd = 2)
# Get and plot linear model for this
div_mar_rate_resid <- map(alist(Divorce ~ dnorm(mu, sigma),
                                mu <- a + b*m_resid,
                                a ~ dnorm(0, 10),
                                b ~ dnorm(0, 1),
                                sigma ~ dunif(0, 10)),
                          data = d)
precis(div_mar_rate_resid)
abline(div_mar_rate_resid, lwd = 3, col = "red")
resid_seq <- seq(from = -2, to = 2, length.out = 30)
mu <- link(div_mar_rate_resid, data = data.frame(m_resid = resid_seq))
mu_PI <- apply(mu, 2, PI)
shade(mu_PI, resid_seq)
# There is essentially no correlation
precis(div_mar_rate_resid)
# The mean(b) is approximately that of mean(bR) from earlier
# Should be identical


# Counterfactual plots
# Get the average for median age at marriage
A_avg <- mean(d$MedianAgeMarriage_s)
# Marriage rate sequence
R_seq <- seq(from = -3, to = 3, length.out = 30)
# Predict for that sequence
pred_data <- data.frame(Marriage_s = R_seq,
                        MedianAgeMarriage_s = A_avg)

# Get mu values for that sequence
mu <- link(m5_3, data = pred_data)
# Get the mean of those mu values
mu_mean <- apply(mu, 2, mean)
# Get the PI for those mu values
mu_PI <- apply(mu, 2, PI)

# Simulate 10000 divorce rates
R_sim <- sim(m5_3, data = pred_data, n = 1e4)

# Get the PI for those simulated rates
R_PI <- apply(R_sim, 2, PI)

# Plot the points
plot(Divorce ~ Marriage_s, data = d, type = "n")
# Title
mtext("Standardized Median Age at Marriage = 0")
# Plot the MAP line
lines(R_seq, mu_mean)
# Plot the PI for the line
shade(mu_PI, R_seq)
# Plot the PI for predictions
shade(R_PI, R_seq)


# Same thing for Median Age at Marriage
R_avg <- mean(d$Marriage_s)
A_seq <- seq(from = -3, to = 3.5, length.out = 30)
pred_data2 <- data.frame(Marriage_s = R_avg,
                         MedianAgeMarriage_s = A_seq)

mu <- link(m5_3, data = pred_data2)
mu_mean <- apply(mu, 2, mean)
mu_PI <- apply(mu, 2, PI)

A_sim <- sim(m5_3, data = pred_data2, n = 1e4)
A_PI <- apply(A_sim, 2, PI)

plot(Divorce ~ MedianAgeMarriage_s, data = d, type = "n")
mtext("Standardize Marriage Rate = 0")
lines(A_seq, mu_mean)
shade(mu_PI, A_seq)
shade(A_PI, A_seq)


# Posterior prediction plots 1
# Predicted versus observed
# Get mu values for the predictor values from the data
mu <- link(m5_3) # Defaults to 1e3 samples

# Get the summaries
mu_mean <- apply(mu, 2, mean)
mu_PI <- apply(mu, 2, PI)

# Simulate observations at those data points
divorce_sim <- sim(m5_3, n = 1e4)
# PI for those
divorce_PI <- apply(divorce_sim, 2, PI)

# Plot mean(predictions) by actual
plot(mu_mean ~ d$Divorce, ylim = range(mu_PI), cex = 1.25,
     xlab = "Observed Divorce", ylab = "Predicted Divorce")
# 1-to-1 line
abline(a = 0, b = 1, lty = 2, lwd = 2, col = "red")
# Plot PI for each mean(prediction)
for (i in 1:nrow(d)) {
  lines(rep(d$Divorce[i], 2),
        c(mu_PI[1, i], mu_PI[2, i]),
        col = col.alpha("black", 0.35))
}
# Really interesting interactive way to label points
identify(x = d$Divorce, y = mu_mean, labels = d$Loc, cex = 0.8)


# Posterior prediction plots 2
# Residuals
divorce_resid <- d$Divorce - mu_mean

# Order by divorce rat
o <- order(divorce_resid)

# Make the plot
dotchart(divorce_resid[o], labels = d$Loc[o], xlim = c(-6, 5),
         pch = 16)
# Perfect mean(prediction)
abline(v = 0, col = col.alpha("black", 0.2))
# Plot the PI for the mean (as lines) and prediction (as points)
for (i in 1:nrow(d)) {
  j <- o[i]
  lines(d$Divorce[j] - c(mu_PI[1, j], mu_PI[2, j]), rep(i, 2))
  points(d$Divorce[j] - c(divorce_PI[1, j], divorce_PI[2, j]), rep(i, 2),
         pch = 3, cex = 0.75, col = "red")
}



# Posterior prediction plots 3
# Residuals against new predictor variables
# Get WaffleHouses per capita
d$waff_per_cap <- d$WaffleHouses / d$Population
# Have the divorce resid in d dataframe
d$divorce_resid <- divorce_resid

# Plot points
plot(divorce_resid ~ waff_per_cap, data = d)

# Get model and fit
new_mod <- map(alist(divorce_resid ~ dnorm(mu, sigma),
                     mu <- a + b*waff_per_cap,
                     a ~ dnorm(0, 1),
                     b ~ dnorm(0, 1),
                     sigma ~ dunif(0, 2)),
               data = d)

# Plot line
abline(new_mod)

# Get evenly-spaced seq for predicting off of
waff_seq <- seq(from = 0, to = 40, length.out = 50)
# Format it
waff_seq_form <- list(waff_per_cap = waff_seq)

# Get mu's from it
mu <- link(new_mod, data = waff_seq_form)
# Get the mean of those mu's - line
mu_mean <- apply(mu, 2, mean)
# Get the PI of those mu's - uncertainty of the line
mu_PI <- apply(mu, 2, PI)

# Simulation predictions
pred_resid <- sim(new_mod, data = waff_seq_form)
# Get PI for those predictions
pred_PI <- apply(pred_resid, 2, PI)

# Shade in line uncertainty
shade(mu_PI, waff_seq)
# Shade in prediction uncertainty
shade(pred_PI, waff_seq)


# Simulating spurious variable
N <- 100
x_real <- rnorm(N)
x_spur <- rnorm(N, x_real)
y <- rnorm(N, x_real)
d <- data.frame(y, x_real, x_spur)
pairs(d)
# If you include both x's into a linear regression predicting
# Y, then the parameter value for the rate associated with x_spur
# Will be near 0, while x_real will be close to 1


# Masked Relationships
# Set up
library(rethinking)
data(milk)
d <- milk
str(d)
# The variables we'll focus on are...
# kcal.per.g
# -> kilocalories of energy per gram of milk
# mass
# -> average female body mass, in kg
# and neocortex.perc
# -> the percent of total brain mass that is neocortex mass
# kcal.per.g is the outcome


# Fit the first model
m5_5 <- map(alist(kcal.per.g ~ dnorm(mu, sigma),
                  mu <- a + bn*neocortex.perc,
                  a ~ dnorm(0, 100),
                  bn ~ dnorm(0, 1),
                  sigma ~ dunif(0, 1)),
            data = d)
# This returns an error
# "initial value in 'vmmin' is not finite
d$neocortex.perc
# There are NA values

# Only keep complete data entries, no NAs
dcc <- d[complete.cases(d), ]

# Redo the earlier code
m5_5 <- map(alist(kcal.per.g ~ dnorm(mu, sigma),
                  mu <- a + bn*neocortex.perc,
                  a ~ dnorm(0, 100),
                  bn ~ dnorm(0, 1),
                  sigma ~ dunif(0, 1)),
            data = dcc)
# Quick look
precis(m5_5, digits = 3)
# Telling us that neocortex percent has ~0 influence
# Because the 89% PI is approximately centered on 0
# Also
dif <- range(dcc$neocortex.perc)[2] - range(dcc$neocortex.perc)[1]
dif*coef(m5_5)["bn"]
# From min to max neocortex.perc, this model suggests that you would
# See only a  < 0.1 rise in kilocaries per gram

# View this
np_seq <- 0:100
pred_data <- data.frame(neocortex.perc = np_seq)

mu <- link(m5_5, data = pred_data, n = 1e4)
mu_mean <- apply(mu, 2, mean)
mu_PI <- apply(mu, 2, PI)

plot(kcal.per.g ~ neocortex.perc, data = dcc, pch = 16)
lines(np_seq, mu_mean)
lines(np_seq, mu_PI[1, ], lty = 2)
lines(np_seq, mu_PI[2, ], lty = 2)
# Notice how large PI for the map line is
# It's large for even the prediction PI


# Lets try a single predictor regression with log(female body mass)
# As the predictor
dcc$log_mass <- log(dcc$mass)

# Fit the new model
m5_6 <- map(alist(kcal.per.g ~ dnorm(mu, sigma),
                  mu <- a + bm*log_mass,
                  a ~ dnorm(0, 100),
                  bm ~ dnorm(0, 1),
                  sigma ~ dunif(0, 1)),
            data = dcc)
# Quick look
precis(m5_6, digits = 3)
# Points
plot(kcal.per.g ~ log_mass, dcc, pch = 16)
# MAP line and PI for line
mass_seq <- seq(-3, 5, length.out = 30)
pred_data <- data.frame(log_mass = mass_seq)
mu <- link(m5_6, data = pred_data, n = 1e4)
mu_mean <- apply(mu, 2, mean)
mu_PI <- apply(mu, 2, PI)
# MAP line
lines(mass_seq, mu_mean, lwd = 2)
# PI for it
lines(mass_seq, mu_PI[1, ], lty = 2)
lines(mass_seq, mu_PI[2, ], lty = 2)


# Using both predictors
m5_7 <- map(alist(kcal.per.g ~ dnorm(mu, sigma),
                  mu <- a + bn*neocortex.perc + bm*log_mass,
                  a ~ dnorm(0, 100),
                  bn ~ dnorm(0, 1),
                  bm ~ dnorm(0, 1),
                  sigma ~ dunif(0, 1)),
            data = dcc)

precis(m5_7)
# Both rates' PIs are out of 0 now

# Plot counterfactual for these
# FOr neocortex.perc
mean_log_mass <- mean(log(dcc$mass))
np_seq <- 1:100
pred_data <- data.frame(neocortex.perc = np_seq,
                        log_mass = mean_log_mass)

mu <- link(m5_7, data = pred_data, n = 1e4)
mu_mean <- apply(mu, 2, mean)
mu_PI <- apply(mu, 2, PI)

plot(kcal.per.g ~ neocortex.perc, data = dcc, type = "n")
lines(np_seq, mu_mean, lwd = 2)
lines(np_seq, mu_PI[1, ], lty = 2)
lines(np_seq, mu_PI[2, ], lty = 2)

# For log_mass
mean_neo_perc <- mean(dcc$neocortex.perc)
mass_seq <- seq(-2.5, 4.5, length.out = 100)
pred_data <- data.frame(neocortex.perc = mean_neo_perc,
                        log_mass = mass_seq)

mu <- link(m5_7, data = pred_data, n = 1e4)
mu_mean <- apply(mu, 2, mean)
mu_PI <- apply(mu, 2, PI)

plot(kcal.per.g ~ log_mass, data = dcc, type = "n")
lines(mass_seq, mu_mean, lwd = 2)
lines(mass_seq, mu_PI[1, ], lty = 2)
lines(mass_seq, mu_PI[2, ], lty = 2)


# Multicollinear legs
N <- 100
height <- rnorm(N, 10, 2)                          # Height
leg_prop <- runif(N, 0.4, 0.5)                     # Proportion of height that is legs
leg_left <- leg_prop*height + rnorm(N, 0, 0.02)    # Legs are not exactly same length
leg_right <- leg_prop*height + rnorm(N, 0, 0.02)
d <- data.frame(height, leg_left, leg_right)       # Making a df

# Fit model
m5_8 <- map(alist(height ~ dnorm(mu, sigma),
                  mu <- a + bl*leg_left + br*leg_right,
                  a ~ dnorm(10, 100),
                  bl ~ dnorm(2, 10),
                  br ~ dnorm(2, 10),
                  sigma ~ dunif(0, 10)),
            data = d)
precis(m5_8)
# Table is strange, lets plot it
plot(precis(m5_8))
# Huge uncertainty in coefficients

# View all the combinations of the coefficients
post <- extract.samples(m5_8)
plot(bl ~ br, post, col = col.alpha(rangi2, 0.1), pch = 16)


sum_blbr <- post$bl + post$br
dens(sum_blbr, col = rangi2, lwd = 2, xlab = "Sum of the Two Coefficients")
# Notice the peak of this distribution lies at the sum of the means for the
# Coefficients
abline(v = coef(m5_8)["bl"] + coef(m5_8)["br"])


# If you fit a regression model with only 1 of the multicollinear variables
# You get approximately the same coefficient as the sums of the multicollinear
# Coefficients
m5_9 <- map(alist(height ~ dnorm(mu, sigma),
                  mu <- a + bl*leg_left,
                  a ~ dnorm(10, 100),
                  bl ~ dnorm(2, 10),
                  sigma ~ dunif(0, 10)),
            data = d)
precis(m5_9)
post <- extract.samples(m5_9)
dens(post$bl, col = rangi2, lwd = 2, xlab = "Posterior Distribution of Left Leg Coefficients")
# Approximately the same as the last plot


# Returning to milk to see multicollinear in more realistic setting
library(rethinking)
data(milk)
d <- milk

# Model based on percent fat
m5_10 <- map(alist(kcal.per.g ~ dnorm(mu, sigma),
                   mu <- a + bf*perc.fat,
                   a ~ dnorm(0.6, 10),
                   bf ~ dnorm(0, 1),
                   sigma ~ dunif(0, 10)),
             data = d)

# Based on percent lactose
m5_11 <- map(alist(kcal.per.g ~ dnorm(mu, sigma),
                   mu <- a + bl*perc.lactose,
                   a ~ dnorm(0.6, 10),
                   bl ~ dnorm(0, 1),
                   sigma ~ dunif(0, 10)),
             data = d)

precis(m5_10, digits = 3)
precis(m5_11, digits = 3)

plot(d$kcal.per.g ~ d$perc.fat, pch = 16)
abline(m5_10)

plot(d$kcal.per.g ~ d$perc.lactose, pch = 16)
abline(m5_11)
# Although coefficients are small, the plots
# Show pretty sizable effects

# A model based on percent lactose and fat
m5_12 <- map(alist(kcal.per.g ~ dnorm(mu, sigma),
                   mu <- a + bf*perc.fat + bl*perc.lactose,
                   a ~ dnorm(0.6, 10),
                   bf ~ dnorm(0, 1),
                   bl ~ dnorm(0, 1),
                   sigma ~ dunif(0, 10)),
             data = d)
# Everything looks a lot less good now
precis(m5_12, digits = 3)
# This is why
precis(m5_12, digits = 3, corr = TRUE)
# multicollinearity that is almost perfect

# Another way to see this
pairs(~kcal.per.g + perc.fat + perc.lactose, data = d, col = rangi2)
# Fat and lactose percents are essentially giving us the same information
# To the point of redudancy


# Post-treatment bias
# Simulation of data
# Number of plants
N <- 100

# Simulate initial heights
h0 <- rnorm(N, 10, 2)

# Assign treatments and simulate fungus and growth
treatment <- rep(0:1, each = N/2)
# The following variable is influenced by treatment
fungus <- rbinom(N, size = 1, prob = 0.5 - treatment*0.4)
# Simulate ending heights
h1 <- h0 + rnorm(N, 5 - 3*fungus)

# Make it all into a df
d <- data.frame(h0 = h0, h1 = h1, treatment = treatment, fungus = fungus)

# Make a model
m5_13 <- map(alist(h1 ~ dnorm(mu, sigma),
                   mu <- a + bh*h0 + bt*treatment + bf*fungus,
                   a ~ dnorm(0, 100),
                   c(bh, bt, bf) ~ dnorm(0, 10),
                   sigma ~ dunif(0, 10)),
             data = d)
precis(m5_13)
# We know that the precense of fungus and treatment are both things that matter
# The issue is that precense of fungus is largely a result of treatment
# We simulated it that way
# So, the low values for the coefficient of treatment are telling us that
# After we know the precense of fungus
# Knowing the treatment tells us nothing
# After all, the treatment was likely SUPPOSED to control the precense of fungus
# This does, however, tell us that the treatment is working
# It is affecting fungal precense, which is affecting growth/height

# To properly know the treatment affect, we should omit the fungus variable from the model
m5_14 <- map(alist(h1 ~ dnorm(mu, sigma),
                   mu <- a + bh*h0 + bt*treatment,
                   a ~ dnorm(0, 100),
                   c(bh, bt) ~ dnorm(0, 10),
                   sigma ~ dunif(0, 10)),
             data = d)
precis(m5_14)
# m5_13 is not bad because it makes poor predictions or performs poorly
# It bad because it uses bad science


# Categorical variables
# Binary categories
library(rethinking)
data(Howell1)
d <- Howell1

# Make a model with sex, male indicator
m5_15 <- map(alist(height ~ dnorm(mu, sigma),
                   mu <- a + bm*male,
                   a ~ dnorm(178, 100),
                   bm ~ dnorm(0, 10),
                   sigma ~ dunif(0, 50)),
             data = d)
precis(m5_15)
# "a" is now the average height among females
# "bm" is the difference between males and females
# So, average male height is "a + bm"

# This gives you the PI for the mean(male height)
post <- extract.samples(m5_15)
mu_male <- post$a + post$bm
PI(mu_male)

# Another way to set this up is using
# mu <- af*(1-m) + am*m
# Which is equivalent to
# mu <- af - af*m + am*m
# mu <- af - (am - af)*m
# This more clearly demonstrates that the 
# Coefficient of "m" is the difference in means


# Multiple categories
# Reload primate data
data(milk)
d <- milk
unique(d$clade)
# Make indicator for new world monkey
d$clade_NWM <- ifelse(d$clade == "New World Monkey", 1, 0)
# To get complete number of indicators
d$clade_OWM <- ifelse(d$clade == "Old World Monkey", 1, 0)
d$clade_S <- ifelse(d$clade == "Strepsirrhine", 1, 0)
# No need to make an indicator for "Ape" because it will be
# The default intercept

# Fit the model
m5_16 <- map(alist(kcal.per.g ~ dnorm(mu, sigma),
                   mu <- a + b.NWM*clade_NWM + b.OWM*clade_OWM + b.S*clade_S,
                   a ~ dnorm(0.6, 10),
                   c(b.NWM, b.OWM, b.S) ~ dnorm(0, 1),
                   sigma ~ dunif(0, 10)),
             data = d)
precis(m5_16)
# The parameter values are the net change from mean(apes) to mean(variable)

# To view them easily
# Take samples
post <- extract.samples(m5_16)

mu_ape <- post$a
mu_NWM <- post$a + post$b.NWM
mu_OWM <- post$a + post$b.OWM
mu_S <- post$a + post$b.S

# Summarize the results
precis(data.frame(mu_ape, mu_NWM, mu_OWM, mu_S))
# This is much more intuitive to read

# Now you can get the estimate difference between monkey groups
diff_NWM_OWM <- mu_NWM - mu_OWM
quantile(diff_NWM_OWM, probs = c(0.025,    # PI lower bound
                                 0.5,      # Median
                                 0.975))   # PI upper bound


# Unique intercepts
# Make an index variable for a categorical variable
d$clade_id <- coerce_index(d$clade)
d$clade_id
d$clade
# Each category now has a numerical value based on its factor level

# How to put this into a model
m5_16_alt <- map(alist(kcal.per.g ~ dnorm(mu, sigma),
                       mu ~ a[clade_id],
                       a[clade_id] ~ dnorm(0.6, 10),
                       sigma ~ dunif(0, 10)),
                 data = d)
precis(m5_16_alt, depth = 2)
# Same result as earlier, works easier


