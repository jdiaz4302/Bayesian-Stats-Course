


### Set up ###
p_grid <- seq(from = 0, to = 1, length.out = 1000)     # 1000 values are between 0 and 1 possible

prior <- rep(1, 1000)                                  # Uniform prior - each value is equally likely

likelihood <- dbinom(6, size = 9, prob = p_grid)       # P(getting 6 Ws from 9 tosses) for each value

posterior <- likelihood * prior                        # P(each value) * P(data|each value)
posterior <- posterior / sum(posterior)                # Divided by sum(P(each value * P(data|each value))) = P(data)
                                                       # Yields P(each value|data)
set.seed(100)                                          # Set where pseudoRNG starts

samples <- sample(p_grid, prob = posterior,            # Taking 1000 samples from the posterior
                  size = 1e4, replace = TRUE)


### 3E1 ###
# I believe this will help with all problems
hist(samples, breaks = 100, xlim = c(0, 1))

# How much of the posterior is below 0.2?
sum(posterior[p_grid < 0.2])


### 3E2 ###
# Above 0.8?
sum(posterior[p_grid > 0.8])


### 3E3 ###
# Between 0.2 and 0.8?
sum(posterior[p_grid > 0.2 & p_grid < 0.8])


### 3E4 ###
# 20% of the posterior lies below what value of p?
quantile(samples, 0.2)


### 3E5 ###
# 20% of the posterior lies above what value of p?
quantile(samples, c(0.8, 1))


### 3E6 ###
# What values of p contain the narrowest interval equal to 66% of the posterior probability
rethinking::HPDI(samples, prob = 0.66)

# Adding this to the hist
abline(v = .52, lwd = 3, col = "dark blue")
abline(v = 0.78, lwd = 3, col = "dark blue")


### 3E7 ###
# Which values of p contain 66% of the posterior probability, assuming equal posterior
# Probability both below and above the interval
rethinking::PI(samples, prob = 0.66)

# Visualization
hist(samples, breaks = 100, xlim = c(0, 1))
abline(v = 0.50, lwd = 3, col = "dark blue")
abline(v = 0.77, lwd = 3, col = "dark blue")


### 3M1 ###
# Suppose the globe tossing example had yielded 8 W out of 15 total
# Construct the posterior using the flat prior and grid approximation
likelihood_2 <- dbinom(8, size = 15, prob = p_grid)

posterior_2 <- likelihood_2 * prior
posterior_2 <- posterior_2 / sum(posterior_2)

plot(posterior_2 ~ p_grid, type = "l")


### 3M2 ###
# Draw 10,000 samples and calculate the 90% HPDI for the value of p
samples_2 <- sample(p_grid, prob = posterior_2,
                    size = 1e4, replace = TRUE)

hist(samples_2, breaks = 250, xlim = c(0, 1))

a <- rethinking::HPDI(samples_2, prob = 0.90)

x1 <- as.numeric(as.character(a[1]))
x2 <- as.numeric(as.character(a[2]))

abline(v = x1, lwd = 3, col = "red")
abline(v = x2, lwd = 3, col = "red")


### 3M3 ###
# Construct a posterior predictive check
# What is the probability that number of W = 8
post_pred_check <- rbinom(1e4, size = 15, prob = samples_2)

hist(post_pred_check, breaks = 50, col = "dark blue")

sum(grepl(8, post_pred_check)) / 1e4


### 3M4 ###
# Using the posterior from the 8 out of 15 data
# calculate P(6 W out of 9 total)
post_pred_check_3 <- rbinom(1e4, size = 9, prob = samples_2)

hist(post_pred_check_3, breaks = 50, col = "dark blue", xlim = c(0, 10))

sum(grepl(6, post_pred_check_3)) / 1e4


### 3M5 ###
# Redo 3M1 with a prior that is 0 for p < 0.5 and a constant for p > 0.5
# This is using the prior knowledge that most of Earth is water
# Repeat 3M2 - M4, what difference does it make?
# Remember the true value is approx p = 0.7
### Redoing 3M1 ###
p_grid_4 <- seq(from = 0, to = 1, length.out = 1000)

prior_4 <- ifelse(p_grid_4 < 0.5, 0, 2)

likelihood_4 <- dbinom(8, size = 15, prob = p_grid_4)

posterior_4 <- likelihood_4 * prior_4 
posterior_4 <- posterior_4 / sum(posterior_4)

plot(posterior_4 ~ p_grid_4, type = "l")

### Redoing 3M2 ###
samples_4 <- sample(p_grid_4, prob = posterior_4,
                    size = 1e4, replace = TRUE)

hist(samples_4, breaks = 250, xlim = c(0, 1))

a_4 <- rethinking::HPDI(samples_4, prob = 0.90)

x_1_4 <- as.numeric(as.character(a_4[1]))
x_2_4 <- as.numeric(as.character(a_4[2]))

abline(v = x_1_4, lwd = 3, col = "red")
abline(v = x_2_4, lwd = 3, col = "red")

### Redoing 3M3 ###
post_pred_check_4 <- rbinom(1e4, size = 15, prob = samples_4)

hist(post_pred_check_4, breaks = 50, col = "dark blue")

sum(grepl(8, post_pred_check_4)) / 1e4

### Redoing 3M4 ###
post_pred_check_5 <- rbinom(1e4, size = 9, prob = samples_4)

hist(post_pred_check_5, breaks = 50, col = "dark blue", xlim = c(0, 10))

sum(grepl(6, post_pred_check_5)) / 1e4


### 3H1 ###
# Set up provided
library(rethinking)
data(homeworkch3)
# male birth = 1
# female birth = 0
# p_grid will work for our prior
likelihood_6 <- dbinom(sum(birth1 + birth2), size = length(birth1) + length(birth2), prob = p_grid)

posterior_6 <- likelihood_6 * prior
posterior_6 <- posterior_6 / sum(posterior_6)

plot(posterior_6 ~ p_grid, type = "l")

p_grid[which.max(posterior_6)]


### 3H2 ###
samples_6 <- sample(p_grid, prob = posterior_6,
                    size = 1e4, replace = TRUE)

hist(samples_6, breaks = 40, xlim = c(0, 1))

a_6 <- HPDI(samples_6, prob = c(0.50, 0.89, 0.97))

hpdi_50_1 <- as.numeric(as.character(a_6[3]))
hpdi_50_2 <- as.numeric(as.character(a_6[4]))
hpdi_89_1 <- as.numeric(as.character(a_6[2]))
hpdi_89_2 <- as.numeric(as.character(a_6[5]))
hpdi_97_1 <- as.numeric(as.character(a_6[1]))
hpdi_97_2 <- as.numeric(as.character(a_6[6]))

abline(v = hpdi_50_1, lwd = 4, col = "red")
abline(v = hpdi_50_2, lwd = 4, col = "red")
abline(v = hpdi_89_1, lwd = 3, col = "dark blue")
abline(v = hpdi_89_2, lwd = 3, col = "dark blue")
abline(v = hpdi_97_1, lwd = 2, col = "grey35")
abline(v = hpdi_97_2, lwd = 2, col = "grey35")


### 3H3 ###
comparison_samples <- rbinom(1e4, size = 200, prob = samples_6)

rethinking::dens(comparison_samples, lwd = 2)

abline(v = 111, lwd = 3, col = "red")


### 3H4 ###
comparison_samples_2 <- rbinom(1e4, size = 100, prob = samples_6)

rethinking::dens(comparison_samples_2, lwd = 2)

abline(v = sum(birth1), lwd = 3, col = "red")


### 3H5 ###
library(dplyr)

males_births_that_followed_females <- cbind(birth1, birth2) %>%
  as.data.frame() %>%
  filter(birth1 == 0)

males_that_followed_females <- sum(males_births_that_followed_females$birth2)

count_first_born_females <- length(males_births_that_followed_females$birth1)

comparison_samples_3 <- rbinom(1e4,
                               size = count_first_born_females,
                               prob = samples_6)

rethinking::dens(comparison_samples_3, lwd = 2)

abline(v = males_that_followed_females, lwd = 3, col = "red")


