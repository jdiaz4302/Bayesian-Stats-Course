


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


