


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


