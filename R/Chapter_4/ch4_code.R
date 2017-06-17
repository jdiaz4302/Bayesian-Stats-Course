


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


