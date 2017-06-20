


### 4M1 ###
# From the model...
# y of i ~ Normal(mu, sigma)
# mu ~ Normal(0, 10)
# sigma ~ Uniform(0, 10)
# Simulate observed heights FROM THE PRIOR
# Parameter priors
mu_prior_samp <- rnorm(1e4, 0, 10)
sigma_prior_samp <- runif(1e4, 0, 10)

# Outcome prior
y_prior_samp <- rnorm(1e4, mu_prior_samp, sigma_prior_samp)

# View distribution
rethinking::dens(y_prior_samp, adj = 0.27)


### 4M2 ###
# Translate that model into a MAP formula
alist(y ~ dnorm(mu, sigma),
      mu ~ dnorm(0, 10),
      sigma ~ dunif(0, 10))


### 4M3 ###
# y ~ dnorm(mu, sigma)
"Y is normally distributed with mean mu and standard deviation sigma"
# mu <- a + b*x
"Mu is deterministically defined by A plus the product of B and X"
# a ~ dnorm(0, 50)
"A is normally distributed with mean 0 and standard deviation 50"
# b ~ dunif(0, 10)
"B is uniformly distributed with bounds 0 and 10"
# sigma ~ dunif(0, 50)
"Sigma is uniformly distributed with bounds 0 and 50"


### 4M4 ###
my_model <- alist(y ~ dnorm(mu, sigma),
                  mu <- a + b*x,
                  a ~ dnorm(60, 40),         # Based of growth rate and how close age will be to zero,
                                             #     This shouldn't be too crazy
                  b ~ dnorm(5, 10),          # Kids grow at wildly different rates
                  sigma ~ dunif(0, 15))      # Kids vary dramatically in height


### 4M5 ###
# Now we know 1st year mean height was 120
# Also, they got taller every year
my_model <- alist(y ~ dnorm(mu, sigma),
                  mu <- a + b*x,
                  a ~ dnorm(60, 40),        # No new information
                  b ~ dnorm(15, 7),         # Essentially no chance of negative, emphasizes faith in growth
                  sigma ~ dunif(0, 15))     # No new information       


### 4M6 ###
# Now we know variance is never greater than 64
# So sigma (standard deviation) is never greater than 8
my_model <- alist(y ~ dnorm(mu, sigma),
                  mu <- a + b*x,
                  a ~ dnorm(60, 40),
                  b ~ dnorm(15, 7),
                  sigma ~ dunif(0, 8))      # Updated this prior


### 4H1 ###
# What we need to predict for
no_height_obs <- c(46.95, 43.72, 64.78, 32.59, 54.63)

# Import training data
library(rethinking)
data("Howell1")
d <- Howell1
d2 <- d[d$age >= 18, ]

# Standardize weight
d2$weight_s <- (d2$weight - mean(d2$weight)) / sd(d2$weight)

# Get model and train it
kung_model <- map(alist(height ~ dnorm(mu, sigma),
                        mu <- a + b*weight_s,
                        a ~ dnorm(178, 100),
                        b ~ dnorm(0, 10),
                        sigma ~ dunif(0, 50)),
                  data = d2)
precis(kung_model)

# Get simulated heights for unmeasured weights
sim_heights <- sim(kung_model,
                   data = list(weight_s = (no_height_obs - mean(d2$weight)) / sd(d2$weight)))

# Get highest probability density interval
sim_heights_HPDI <- apply(sim_heights, 2, HPDI, prob = 0.89)

# Get the percentile interval
sim_heights_PI <- apply(sim_heights, 2, PI, prob = 0.89)

# Get the mean (expected value) for each unmeasured weight
exp_heights <- apply(sim_heights, 2, mean)

# VIEW THE ANSWERS
exp_heights
sim_heights_HPDI
sim_heights_PI

# EXTRA STUFF
# Get the mean heights for evenly-spaced weights
# Evenly-spaced weights
weight_seq <- seq(30, 65, length.out = 35)

# Computed MAP line value for each weight
mu_mean <- apply(link(kung_model,
                      data = list(weight_s = (weight_seq - mean(d2$weight)) / sd(d2$weight))),
                 2, mean)

# Plot
# Our predictions
plot(exp_heights ~ no_height_obs, cex = 1.5, pch = 16, col = "black",
     xlab = "Weight", ylab = "Height")

# The MAP line
# Joins MAP line values from evenly-spaced weights into a line
lines(weight_seq, mu_mean, lwd = 3, col = "red")


### 3H2 ###
### A ###
# We only want children from Howell1
d3 <- d[d$age < 18, ]

# Going to use the model developed in the medium problems since it deals
# With aging children
kung_childrens_model <- map(alist(height ~ dnorm(mu, sigma),
                                  mu <- a + b*weight,
                                  a ~ dnorm(100, 75),
                                  b ~ dnorm(5, 5),
                                  sigma ~ dunif(0, 20)),
                            data = d3)

precis(kung_childrens_model)
# For every 10 kgs heavier, a child is 27 centimeters taller


### B ###
# Get prediction data
# Get evenly spaced sequences
weight_seq_kids <- seq(from = 4, to = 45, length.out = 41)
# For formatting reasons
weight_seq_kids_form <- list(weight = weight_seq_kids)

# Sample mu values from the posterior at those weights
mu <- link(kung_childrens_model, data = weight_seq_kids_form)

# Get the mean of those mu values
mu_mean <- apply(mu, 2, mean)
# Get the PI for the mu values
mu_HPDI <- apply(mu, 2, HPDI, prob = 0.89)

# Sample predictions at those weights
pred_heights <- sim(kung_childrens_model, data = weight_seq_kids_form)
# Get the 89% PI for those predictions
pred_HPDI <- apply(pred_heights, 2, HPDI, prob = 0.89)

# Plot raw points
plot(height ~ weight, data = d3, col = "dark blue", cex = 1.5)
# The MAP line
lines(weight_seq_kids, mu_mean, lwd = 3, col = "black")
# The confidence interval for the line
shade(mu_HPDI, weight_seq_kids)
# The confidence interval for the predictions
shade(pred_HPDI, weight_seq_kids)


### C ###
# The fit is poor at the extremes
# This is likey due to the fact that
# Young children grow quickly while
# Teens approaching adulthood are growing slowly, if at all.
# I suspect a quadratic or log function would fit much better


### 4H3 ###
# Fit the model
kung_all_model <- map(alist(height ~ dnorm(mu, sigma),
                            mu <- a + b*log(weight),
                            a ~ dnorm(178, 100),
                            b ~ dnorm(0, 100),
                            sigma ~ dunif(0, 50)),
                      data = d3)

precis(kung_all_model)

# Get prediction data
# Get evenly spaced sequences
weight_seq_all <- seq(from = 0, to = 70, length.out = 70)
# For formatting reasons
weight_seq_all_form <- list(weight = weight_seq_all)

# Sample mu values from the posterior at those weights
mu <- link(kung_all_model, data = weight_seq_all_form)

# Get the mean of those mu values
mu_mean <- apply(mu, 2, mean)
# Get the PI for the mu values
mu_HPDI <- apply(mu, 2, HPDI, prob = 0.97)

# Sample predictions at those weights
pred_heights <- sim(kung_all_model, data = weight_seq_all_form)
# Get the 89% PI for those predictions
pred_HPDI <- apply(pred_heights, 2, HPDI, prob = 0.97)

# Plot raw points
plot(height ~ weight, data = d, col = "blue")
# The MAP line
lines(weight_seq_all, mu_mean, lwd = 3, col = "black")
# The confidence interval for the line
shade(mu_HPDI, weight_seq_all)
# The confidence interval for the predictions
shade(pred_HPDI, weight_seq_all)


