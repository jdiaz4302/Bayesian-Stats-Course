


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

