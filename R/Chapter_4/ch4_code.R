


# Simulate the coin flip experiment
# 1000 people flip a coin 16 times
# Each coin face corresponds to moving in a specified direction
# Using uniform because each side of zero is equally likely
# And each movement can be between 0 and 1 yards
position <- replicate(1e3,
                      sum(runif(16, -1, 1)))          # Normal by addition

hist(position, xlim = c(-10, 10), breaks = 250)

rethinking::dens(position, adj = 0.35, col = "dark blue", lwd = 2)


# How a normal distributin can be produced by 
# Variables interacting with one another
Normal_by_multiplication <- prod(1 + runif(12, 0, 0.1))

growth <- replicate(1e4, prod(1 + runif(12, 0, 0.1)))

rethinking::dens(growth, lwd = 3, col = "red", norm.comp = TRUE)


# Comparison of big and small effect interactions
big_effect <- replicate(1e4, prod(1 + runif(12, 0, 0.5)))
rethinking::dens(big_effect, lwd = 3, col = "red", norm.comp = TRUE)

small_effect <- replicate(1e4, prod(1 + runif(12, 0, 0.01)))
rethinking::dens(small_effect, lwd = 3, col = "red", norm.comp = TRUE)


# How a normal distribution can be produced by
# Variables interacting with one another with large deviates
log_big <- replicate(1e4, log(prod(1 + runif(12, 0, 0.5))))

rethinking::dens(log_big, lwd = 3, col = "red", norm.comp = TRUE)


# To update our globe tossing model definitions in a more
# Presentable way, we do the following
w <- 6
n <- 9

p_grid <- seq(from = 0, to = 1, length.out = 100)

posterior <- dbinom(w, n, p_grid) * dunif(p_grid, 0, 1)
posterior <- posterior / sum(posterior)

plot(posterior ~ p_grid, type = "l")


# First linear regression
# The data
library(rethinking)
data(Howell1)
d <- Howell1

# It can be good to inspect the structure of any new object
str(d)

# The variable/vector we're interested in
d$height

# We're only going to use adults of the data
# Since age is correlated with height
d2 <- d[d$age >= 18, ]
# This notation is dataframe[row, column]
# By keeping the column slot blank, we keep all columns


# The model
# Inspect the distribution of height
rethinking::dens(d2$height)
# Relatively normal

# The priors
# For the mean of height
curve(dnorm(x, 178, 20),
      from = 100,               # Setting the bounds
      to = 250)

# For the standard deviation of height
curve(dunif(x, 0, 50),
      from = -10,
      to = 60)

# Sample the priors
sample_mu <- rnorm(1e4, 178, 5)    # Sampling the prior of the mean
sample_sigma <- rnorm(1e4, 0, 5)   # Sampling the prior of the standard deviation

# Creating the prior for the height of each individual #####################################
prior_h <- rnorm(1e4, sample_mu, sample_sigma)

# View it
dens(prior_h, lwd = 3, col = "red")
# Remember this is the distribution of relative plausabilities before you see any 
# Of your data


# Grid approximation of the posterior distribution
# the grid values for the Mean
mu_list <- seq(from = 140,
               to = 160,
               length.out = 200)
# the grid values for the standard deviation
sigma_list <- seq(from = 4,
                  to = 9,
                  length.out = 200)

# Make those grid values into a grid of combinations
post <- expand.grid(mu = mu_list,
                    sigma = sigma_list)
# Computing log likelihood (LL)
post$LL <- sapply(1:nrow(post), function(i) sum(dnorm(
  d2$height,
  mean = post$mu[i],
  sd = post$sigma[i],
  log = TRUE
)))

# Standardizing it - makes it sum to 1
# Addition instead of multiplying because it has been log transformed
post$prod <- post$LL + dnorm(post$mu, 178, 20, TRUE) + dunif(post$sigma, 0, 50, TRUE)

# Un-log-transform it
# the max(post$prod) prevents rounding to zero
post$prob <- exp(post$prod - max(post$prod))

# Get a contour plot
contour_xyz(post$mu, post$sigma, post$prob)

# Get a heat map
image_xyz(post$mu, post$sigma, post$prob)


# Sample from the posterior
# The sampling - remember, "post" is a dataframe with columns for
# Each parameter value combination and the associated plausibility
sample_rows <- sample(1:nrow(post), size = 1e4, replace = TRUE, prob = post$prob)
sample_mu <- post$mu[sample_rows]
sample_sigma <- post$sigma[sample_rows]

# View it
plot(sample_mu, sample_sigma, pch = 16, cex = 0.5,
     col = col.alpha("red", 0.025))
# The darkest region of the plot corresponds to the most likely parameter values


# View the marginal distributions of mu and sigma
# Where marginal means "averaging over the other parameters"
dens(sample_mu)
dens(sample_sigma)
# Each of these is approximately normal
# However, the sigma distribution has a relatively longer right-tail
# This is because there is sigma must be > 0, which entails there
# Being less uncertainty on the left-tail since we have some information
# About its bound
HPDI(sample_mu)
HPDI(sample_sigma)


# Let's look at a smaller subset of the height data
d3 <- sample(d2$height, size = 20)

# Running the same workflow
mu_list <- seq(from = 150, to = 170, length.out = 200)
sigma_list <- seq(from = 4, to = 20, length.out = 200)
post2 <- expand.grid(mu = mu_list, sigma = sigma_list)
post2$LL <- sapply(1:nrow(post2), function(i)
  sum(dnorm(d3, mean = post2$mu[i], sd = post2$sigma[i], log = TRUE)))
post2$prod <- post2$LL + dnorm(post2$mu, 178, 20, TRUE) + dunif(post2$sigma, 0, 50, TRUE)
post2$prob <- exp(post2$prod - max(post2$prod))
sample2_rows <- sample(1:nrow(post2), size = 1e4, replace = TRUE, prob = post2$prob)
sample2_mu <- post2$mu[sample2_rows]
sample2_sigma <- post2$sigma[sample2_rows]
plot(sample2_mu, sample2_sigma, cex = 0.5,
     col = col.alpha("red", 0.25))

# This reduction in sample size leads to a disproportionately 
# Large increase in the right tail of sigma
dens(sample2_sigma, norm.comp = TRUE, lwd = 3, col = "red")
# This is much less "Normal" than before


# Quadratic approximation
# Set everything up again
library(rethinking)

data("Howell1")
d <- Howell1

d2 <- d[d$age >= 18, ]

# Define the model again
# Now in an alist
flist <- alist(
  height ~ dnorm(mu, sigma),
  mu ~ dnorm(178, 20),
  sigma ~ dunif(0, 50)
)

# Fit the model to the d2 data
m4_1 <- map(flist, data = d2)

# View it
precis(m4_1)
# What you see are approximation for the parameters'
# Marginal distributions
# These marginal distributions are Gaussian approximations
# That have averaged over all the values of the other
# Parameter("s" more generally)
# It also shows the 89% percentile interval bound
# Our posterior is approximately Gaussian, so the HPDI from
# Our earlier, grid-approximation-derived marginal distributions
# Is nearly identical to this
HPDI(sample_mu)
HPDI(sample_sigma)

# 89% is still a large interval, but it is mostly randomly chosen
# You can change 89 to 95, but it may cause confusion with
# Significance testing
precis(m4_1, prob = 0.95)


# alist() does not execute the code within
# while list() does


# map starts at a random point before climbing to the max
# You can start the initialization as such
start <- list(
  mu = mean(d2$height),
  sigma = sd(d2$height)
)


# The priors we've used so far have been exceptionally broad
# Lets now use a very narrow, or confident, prior
m4_2 <- map(alist(height ~ dnorm(mu, sigma),
                  mu ~ dnorm(178, 0.1),           # "We're highly certain mu is approx 178"
                  sigma ~ dunif(0, 50)),
            data = d2)
precis(m4_2)
# mean(mu) has barely changed off the prior
# This is because we stated high confidence in the prior
# mean(sigma) has changed dramatically from precis(m4_1)
# This is because sigma is essentially being fit with the 
# Condition that mu = 178


# View the variance-covariance matrix
vcov(m4_1)


# View the variances
diag(vcov(m4_1))
# If you take the sqaure roots of these
# You get the StdDev from precis()
# Remember that there is some rounding

# View the correlation matrix
cov2cor(vcov(m4_1))
# Correlations with theirselves should always be 1
# Correlation with others would ideally be close to 0
# Stating that 1 parameter value gives little-to-no information
# About the other(s)


# Now to sample this multi-dimensional posterior
library(rethinking)
post <- extract.samples(m4_1, n = 1e4)
head(post)
# Post is a dataframe where each row is a sample
# From the posterior

# So...
precis(post)
# Should be nearly identical to precis(m4_1)
# And it is


# Lets see how the new samples compare to the grid approximation samples
plot(post, pch = 16, cex = 0.5,
     col = col.alpha("red", 0.15))
plot(sample_mu, sample_sigma, pch = 16, cex = 0.5,
     col = col.alpha("red", 0.15))


# What is extract.samples() doing?
# Its essentially doing a multivariable form of rnorm()
# The following produces the same results as extract.samples()
library(MASS)
post <- mvrnorm(n = 1e4, mu = coef(m4_1), Sigma = vcov(m4_1))

# Make sure the new plot is approximately the same
plot(post, pch = 16, cex = 0.5,
     col = col.alpha("red", 0.15))
# It is, axes shifted slightly due to changes in extreme samples


# It can be problematic to assume that sigma is Gaussian
# Because we know that its right-tail tends to defy this
# Its log can be much better to use
# Heres how to compute the quadratic approximation of sigma's log
m4_1_logsigma <- map(alist(height ~ dnorm(mu, exp(log_sigma)), # Having exp(log_sigma) effectively 
                                                               # Keeps the sigma > 0 restriction
                           mu ~ dnorm(178, 20),
                           log_sigma ~ dnorm(2, 10)),    # log_sigma can lie below 0
                                                         # so it no longer needs a uniform restricting it
                                                         # from 0
                     data = d2)

# Get samples
post <- extract.samples(m4_1_logsigma)

# Get sigma on natural scale
sigma <- exp(post$log_sigma)


# Adding a predictor
# View how and how strong height and weight covary
plot(d2$height ~ d2$weight, pch = 16, col = "dark blue")
# Pretty strong and positively


# Fitting the model with a predictor: weight
# Reload the data
library(rethinking)
data(Howell1)
d <- Howell1
d2 <- d[d$age >= 18, ]

# Fit the model
m4_3 <- map(alist(height ~ dnorm(mu, sigma),
                  mu <- a + b*weight,
                  a ~ dnorm(156, 100),
                  b ~ dnorm(0, 10),
                  sigma ~ dunif(0, 50)),
            data = d2)
# mu isn't really a parameter anymore
# Its a function of parameters


# Table of estimates
precis(m4_3)
# mean(b) = 0.90, which can be read as "A person that is
# 1kg heavier is expected to be 0.9 inches taller"
# The bounds for the middle 89% are 0.84 and 0.97, so our
# Prior mean of 0 is extremely incompatible with the model
# The model suggests a strong evidence of a positive relationship
#
# The value of the intercept is often uninterpretable because
# It often says strange things, such as "A person of 0 weight should
# Be 114 cm tall".
# This is part of the justification for weak priors for the intercept
# 
# The sigma mean is 5.07, which can then lead us to "95% of the plausible
# Heights lie within ~10cm of the mean." However, there is uncertainty
# As indicated by the 89% percentile interval.

# View the correlation matrix with it
precis(m4_3, corr = TRUE)
# Notice how the parameters from the relationship are almost
# Perfectly, negatively correlated. This is almost always bad.


# One trick to help this is centering
# Here is how you do it
d2$weight_c <- d2$weight - mean(d2$weight)

# Confirm new mean is zero
mean(d2$weight_c)
# Approximately

# Refit the model
m4_4 <- map(alist(height ~ dnorm(mu, sigma),
                  mu <- a + b*weight_c,
                  a ~ dnorm(178, 100),
                  b ~ dnorm(0, 10),
                  sigma ~ dunif(0, 50)),
            data = d2)

# New estimates
precis(m4_4, corr = TRUE)
# All covariances are 0 now

# Note that mean(a) is now equal to
mean(d2$height)
# This is because "a" is the expected value of the outcome
# When the predictor is equal to 0, and now the expected value
# Of the predictor is 0. So mean(a) can be read as "the expected
# Value of the outcome at the expected value of the predictor"


# Plotting posterior inference against the data
plot(height ~ weight, data = d2, col = "grey45", pch = 16)
abline(a = coef(m4_3)["a"], b = coef(m4_3)["b"],
       lwd = 3, col = "red")


# Adding uncertainty around the mean
# Extract samples from the model
post <- extract.samples(m4_3)
head(post)
# Each row is a correlated random sample from the joint posterior
# Of the parameters, using the marginal posteriors and convariances
# Each row specifies a line, the average of these lines is the 
# MAP line
# The scatter around the MAP line meaningful because it conveys
# The uncertainty


# Exercise in visualize the uncertainty
# Fit the model using only 10 data points
N <- 10
dN <- d2[1:N, ]
mN <- map(alist(height ~ dnorm(mu, sigma),
                mu <- a + b*weight,
                a ~ dnorm(178, 100),
                b ~ dnorm(0, 10),
                sigma ~ dunif(0, 50)),
          data = dN)
# Get 20 of the lines to see the uncertainty
post <- extract.samples(mN, n = 20)

# Plot the data
plot(dN$weight, dN$height, xlim = range(dN$weight),
     ylim = range(dN$height), col = "grey45", pch = 16,
     xlab = "Weight", ylab = "Height")

# Add the lines
for (i in 1:20) {
  abline(a = post$a[i], b = post$b[i], lwd = 3,
         col = col.alpha("dark blue", 0.3))
}
# The most uncertainty lies at the bounds of the range
# This is very common
# The more data used, the less uncertainty there will be

# Run the above code after running each N value
N <- 50
N <- 150
N <- 352


# View the uncertainty of 1 mu value
# At one predictor value
mu_at_50 <- post$a + post$b * 50
# This is the Alpha + Beta*weight
# where $a and $b are length 20 vectors
mu_at_50


# View the density
dens(mu_at_50, col = "red", lwd = 3, xlab = "mu | weight = 50")
# Note that this is Gaussian because adding Gaussians produce 
# Gaussians


# HPDI for it
HPDI(mu_at_50, prob = 0.89)
# This intervals' bounds indicate that the densest 89% of ways for
# The model to produce the data have the MAP line between lower bound 
# And upper bound
# We want to do this for every value, not just 50.


# This function samples the posterior and computes mu
mu <- link(m4_3)
str(mu)
# It creates a distribution of mu's for each individual in the 
# Original data

# So, lets feed it 'new data'
# Define sequence of weights for mu computation
weight_seq <- seq(from = 25, to = 70, by = 1)
# Using this sequence because its evenly spaced and unique
# Where the original data may not have been so

# Feed that into link()
mu <- link(m4_3, data = data.frame(weight = weight_seq))
str(mu)


# Plot each mu for each height
plot(height ~ weight, d2,
     type = "n")                 # Hides the data points

for (i in 1:100) {
  points(weight_seq, mu[i, ], pch = 16, col = col.alpha(rangi2, 0.15))
}


# Summarize the distribution for each weight value
mu_mean <- apply(mu, 2,                       # Dimension 2, aka the columns
                 mean)                        # For each unique weight value

mu_HPDI <- apply(mu, 2,
                 HPDI, prob = 0.89)


# To view the means for each
mu_mean
# To view the lower bounds for each
mu_HPDI[1,]
# ...The upper bounds
mu_HPDI[2,]
### REMEMBER ###
# Everything above is describing uncertainty associated with the
# mu parameter, the mean height at each weight


# Prediction intervals
# Now we plot the prediction interval for actual heights - not average
# So we need to incorporate mu and sigma into Normal(mu, sigma)
sim_height <- sim(m4_3,                                   # Uses the fit model
                  data = list(weight = weight_seq))       # Evenly-spaced x's
str(sim_height)


# Simulate the confidence interval for the simulated height
height_PI <- apply(sim_height, 2, PI, prob = 0.89)
height_PI_2 <- apply(sim_height, 2, PI, prob = 0.97)
height_PI_3 <- apply(sim_height, 2, PI, prob = 0.67)


# Plot it all
# The point
plot(height ~ weight, d2, pch = 21)

# The MAP line
lines(weight_seq, mu_mean, lwd = 3)

# The HPDI for MAP line
shade(mu_HPDI, weight_seq, col = col.alpha("red", 0.45))

# The 89% confidence interval for the height prediction
shade(height_PI, weight_seq, col = col.alpha('grey50', 0.25))

# The other 2
shade(height_PI_2, weight_seq, col = col.alpha('grey50', 0.15))
shade(height_PI_3, weight_seq, col = col.alpha('grey50', 0.35))


# Smoothing out jagged edges
sim_height <- sim(m4_3, data = list(weight = weight_seq), n = 1e4)

height_PI <- apply(sim_height, 2, PI, prob = 0.89)
height_PI_2 <- apply(sim_height, 2, PI, prob = 0.97)
height_PI_3 <- apply(sim_height, 2, PI, prob = 0.67)

plot(height ~ weight, d2, pch = 21)
lines(weight_seq, mu_mean, lwd = 3)
shade(mu_HPDI, weight_seq, col = col.alpha("red", 0.45))
shade(height_PI, weight_seq, col = col.alpha('grey50', 0.25))
shade(height_PI_2, weight_seq, col = col.alpha('grey50', 0.15))
shade(height_PI_3, weight_seq, col = col.alpha('grey50', 0.35))
# Its harder to get out the jaggedness from the larger intervals because
# They increasingly include extremer extremes


# Polynomial Regression
library(rethinking)
data("Howell1")
d <- Howell1

plot(d$height ~ d$weight)


# Standardize weight
d$weight_s <- (d$weight - mean(d$weight)) / sd(d$weight)

plot(d$height ~ d$weight_s)
# Literally no information loss, the plot even looks the same

# Get weight sqaured
d$weight_s2 <- d$weight_s^2


# Fit the model
m4_5 <- map(alist(height ~ dnorm(mu, sigma),
                  mu <- a + b1*weight_s + b2*weight_s2,
                  a ~ dnorm(178, 100),
                  b1 ~ dnorm(0, 10),
                  b2 ~ dnorm(0, 10),
                  sigma ~ dunif(0, 50)),
            data = d)

# View a summary table
precis(m4_5)


# The evenly-spaced x values
weight_seq <- seq(from = -2.2, to = 2, length.out = 30)

# Getting those values into the x and x^2 format
pred_dat <- list(weight_s = weight_seq, weight_s2 = weight_seq^2)

# Getting mu samples and mean(mu) for those
mu <- link(m4_5, data = pred_dat)
mu_mean <- apply(mu, 2, mean)

# Getting the confidence interval for mean(mu)
mu_PI <- apply(mu, 2, PI, prob = 0.89)

# Simulating outcomes based off the evenly-spaced predictor values
sim_height <- sim(m4_5, data = pred_dat)

# Creating a confidence interval with those simulated outcomes
height_PI <- apply(sim_height, 2, PI, prob = 0.89)


# Plot points
plot(height ~ weight_s, d, col = "grey45")

# MAP line
lines(weight_seq, mu_mean, lwd = 3)

# 89% confidence interval for MAP line
shade(mu_PI, weight_seq, col = col.alpha("red", 0.45))

# 89% condifence interval for predictions
shade(height_PI, weight_seq)


# Convert back to natural scale
plot(height ~ weight_s, d, col = "grey45",
     xaxt = "n")                              # Turn off x axis

# Construct it
at <- c(-2, -1, 0, 1, 2)
labels <- at*sd(d$weight) + mean(d$weight)
axis(side = 1, at = at, labels = round(labels, 1))


