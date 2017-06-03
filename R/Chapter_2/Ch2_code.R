


# Package installation
install.packages(c("coda",
                   "mvtnorm",
                   "devtools"))

library(devtools)

devtools::install_github("rmcelreath/rethinking")

library(rethinking)


# Compute probabilties/plausibilities in R
ways <- c(0, 3, 8, 9, 0)

ways/sum(ways)


# Binomial distribution - water proportion on Earth example
# This tells us the probability of getting six heads/W's
# Out of 9 attempts when the probability of getting
# A head/W is 0.5
dbinom(6, size = 9, prob = 0.5)


# Grid Approximation - using the above water proportion of
# The Earth example
# Define the grid
p_grid <- seq(from = 0,
              to = 1,
              length.out = 20)

# Define the prior
prior <- rep(1, 20)

# Compute the likelihoods
# This is the probability of getting the water 6 times
# Out of 9, if proportion is equal to each value in
# p_grid
likelihood <- dbinom(6, size = 9,
                     prob = p_grid)

# Compute the unstandardized posterior
unstd.posterior <- likelihood * prior

# Standardize the posterior
posterior <- unstd.posterior / sum(unstd.posterior)


# Plot those
plot(p_grid, posterior, type = "b",
     xlab = "Proportion that is Water",
     ylab = "Posterior Probability")


# With a different prior
prior <- ifelse(p_grid < 0.5, 0, 1)

unstd.posterior <- likelihood * prior

posterior <- unstd.posterior * sum(unstd.posterior)

plot(p_grid, posterior, type = "b",
     xlab = "Proportion that is Water",
     ylab = "Posterior Probability")


# Another different one
prior <- exp(-5*abs(p_grid - 0.5))

unstd.posterior <- likelihood * prior

posterior <- unstd.posterior * sum(unstd.posterior)

plot(p_grid, posterior, type = "b",
     xlab = "Proportion that is Water",
     ylab = "Posterior Probability")


# With less grids
p_grid <- seq(from = 0,
              to = 1,
              length.out = 5)

prior <- exp(-5*abs(p_grid - 0.5))

likelihood <- dbinom(6, size = 9,
                     prob = p_grid)

unstd.posterior <- likelihood * prior

posterior <- unstd.posterior * sum(unstd.posterior)

plot(p_grid, posterior, type = "b",
     xlab = "Proportion that is Water",
     ylab = "Posterior Probability")


# These calculations are fast and easy due to
# R's use of vectorized calculations, which tend to
# Be better than loops, which you could've also done


# Quadratic Approximation
# Same example
globe.qa <- map(alist(w ~ dbinom(9, p),   # 9 total attempts/trials
                      p ~ dunif(0, 1)),   # Prior is uniform(0, 1)
                data = list(w = 6))       # Getting 6 W's

# Display
precis(globe.qa)
# This can be read as "Assuming that the posterior
# Is normally distributed, the best approximation
# Is with mean 0.67 and standard deviation 0.16

# This can be done analytically do determine the 'right answer'
w <- 6
n <- 9

# The exact - analytically determined
curve(dbeta(x, w+1, n-w+1), from = 0, to = 1,
      col = "red", lwd = 2)

# The approximation
curve(dnorm(x, 0.67, 0.16), lty = 2, add = TRUE,
      lwd = 2)
# One failure with this approximation is that it assigns
# A positive probability to proportion = 1
# Approximations generally improve with sample size
# And most statistical procedure uses them
# However a good improvement upon bad can still be bad


