


# Performing the calculation
# P(vamp|pos) = P(pos|vamp)P(vamp)/P(pos)
prob_pos_given_vamp <- 0.95

prob_vamp <- 0.001

# P(pos) = P(pos|vamp)P(vamp) + P(pos|not vamp)P(not vamp)
prob_pos_given_not_vamp <- 0.01

prob_pos <- prob_pos_given_vamp * prob_vamp + prob_pos_given_not_vamp * (1 - prob_vamp)

prob_vamp_given_pos <- prob_pos_given_vamp * prob_vamp / prob_pos

print(prob_vamp_given_pos)
# So if there's a 0.1% chance of being a vampire, and you test positive on a test
# That correctly detects vampires 95% if the time (true positive), while incorrectly detecting
# Vampires 1% of the time (false positive). There is a 8.7% chance that you're a vampire.


# Reminder on how to compute posterior from the globe example
# Using grid approximation
p_grid <- seq(from = 0, to = 1, length.out = 1000)

prior <- rep(1, 1000)

likelihood <- dbinom(6, size = 9, prob = p_grid)

unstand_posterior <- likelihood * prior

posterior <- unstand_posterior / sum(unstand_posterior)

plot(posterior)

# Sample the posterior
samples <- sample(p_grid, prob = posterior, size = 1e4, # size = 10,000
                  replace = TRUE)
# sample() randomly pulls samples

# Plot it
plot(samples, col = "darkblue")
# The x axis is index of sample and the y axis is the proportion gotten on that sample

# Plot the more immediately informative 'density estimate'
library(rethinking)

dens(samples, lwd = 2, col = "darkblue")
# This is very similar to the plots we made in Chapter 2 of the same example
# The more samples, the more similar


# Intervals of defined boundaries
# P(proportion of water < 0.5)
sum(posterior[p_grid < 0.5])
# That was easy enough, not using samples, but instead the distribution
# It will not be this easy with more than 1 parameter

# Do it with samples
sum(samples < 0.5) / 1e4
# This code/process is much easier / more basic

# You can also get the proportion of the distribution that lies between values
sum(samples > 0.5 & samples < 0.75) / 1e4


# Intervals of defined mass
# Get the lower 80% of the distribution bounds
quantile(samples, 0.8)

# Get the middle 80% of the distribution
# That is, between the lower 10% and the upper 90%
quantile(samples, c(0.1, 0.9))
# This is a percentile interval


# A case of bad percentile intervals
# Globe example but where 3 tosses all landed W
p_grid <- seq(from = 0, to = 1, length.out = 1000)      # 1000 possible proportion values

prior <- rep(1, 1000)                                   # uniform

likelihood <- dbinom(3, size = 3, prob = p_grid)        # 3 W for 3 tosses

unstand_posterior <- likelihood * prior

posterior <- unstand_posterior / sum(unstand_posterior) # probability of each value

samples <- sample(p_grid, size = 1e4, replace = TRUE,   # sample the values 10,000 times
                   prob = posterior)

# Get the middle 50% of the distribution/samples
rethinking::PI(samples, prob = 0.5)

# My attempt to plot it all
density <- density(samples)

q25 <- quantile(samples, 0.25)
q75 <- quantile(samples, 0.75)

x1 <- min(which(density$x > q25))
x2 <- max(which(density$x < q75))

plot(density, lwd = 3,
     xlab = "Proportion Value",
     ylab = "Count",
     main = "Distribution of Sampled Proportion Values")

mtext("50% Percentile Confidence Interval")

with(density,
     polygon(x = c(x[c(x1, x1:x2, x2)]),
             y = c(0, y[x1:x2], 0),
             col = "darkblue"))
# As you can see, this confidence interval does not accurately
# Describe the shape of the distribution. Afterall, it excludes
# The most probable values of p


# Highest posterior density interval
a <- rethinking::HPDI(samples, prob = 0.50)

x1 <- as.numeric(as.character(a[1]))
x2 <- as.numeric(as.character(a[2]))

abline(v = x1, lwd = 4, col = "grey")
abline(v = x2, lwd = 4, col = "grey")
# As you can see, this appears to be a better representation of the
# Distribution


# Proof that they're similar in non skewed data
p_grid <- seq(from = 0, to = 1, length.out = 1000)      # 1000 possible proportion values

prior <- rep(1, 1000)                                   # uniform

likelihood <- dbinom(6, size = 9, prob = p_grid)        # 6 W for 9 tosses

unstand_posterior <- likelihood * prior

posterior <- unstand_posterior / sum(unstand_posterior) # probability of each value

samples <- sample(p_grid, size = 1e4, replace = TRUE,   # sample the values 10,000 times
                  prob = posterior)

density <- density(samples)

q05 <- quantile(samples, 0.05)
q95 <- quantile(samples, 0.95)

x1 <- min(which(density$x > q05))
x2 <- max(which(density$x < q95))

plot(density, lwd = 3,
     xlab = "Proportion Value",
     ylab = "Count",
     main = "Distribution of Sampled Proportion Values")

mtext("50% Percentile Confidence Interval")

with(density,
     polygon(x = c(x[c(x1, x1:x2, x2)]),
             y = c(0, y[x1:x2], 0),
             col = "darkblue"))

a <- rethinking::HPDI(samples, prob = 0.90)

x1 <- as.numeric(as.character(a[1]))
x2 <- as.numeric(as.character(a[2]))

abline(v = x1, lwd = 4, col = "grey")
abline(v = x2, lwd = 4, col = "grey")


# Resetting the data
p_grid <- seq(from = 0, to = 1, length.out = 1000)      # 1000 possible proportion values

prior <- rep(1, 1000)                                   # uniform

likelihood <- dbinom(3, size = 3, prob = p_grid)        # 3 W for 3 tosses

unstand_posterior <- likelihood * prior

posterior <- unstand_posterior / sum(unstand_posterior) # probability of each value

samples <- sample(p_grid, size = 1e4, replace = TRUE,   # sample the values 10,000 times
                  prob = posterior)


# MAP estimator from distribution
p_grid[which.max(posterior)]

# MAP estimator using mode from samples
mode_samp <- chainmode(samples, adj = 0.01)

# Mean
aver_samp <- mean(samples)

# Median
med_samp <- median(samples)

# Plot them
df <- cbind(p_grid, posterior)

plot(df, type = "l", lwd = 3)

abline(v = mode_samp, lwd = 2, col = "red")
abline(v = med_samp, lwd = 2, col = "red")
abline(v = aver_samp, lwd = 2, col = "red")


# Calculating the loss for an estimator
estimator <- 0.5

sum(posterior * abs(estimator - p_grid))
# p_grid = each value
# posterior = P(each value)


# Do this for every possible estimator
loss <- sapply(p_grid, function(d) sum(posterior * abs(d - p_grid)))

# Make it into a dataframe
library(dplyr)

df <- cbind(df, loss) %>%
  as.data.frame()

# Plot it
plot(df$loss ~ df$p_grid)

# Get the lowest loss
m <- p_grid[which.min(loss)]

n <- median(samples)
# These two are approximately identical
# The only reason they're not is because of sampling variation


