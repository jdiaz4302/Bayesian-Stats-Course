


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


