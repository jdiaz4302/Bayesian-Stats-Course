


# Compute probabilties/plausibilities in R
ways <- c(0, 3, 8, 9, 0)

ways/sum(ways)


# Binomial distribution - water proportion on Earth example
# This tells us the probability of getting six heads/W's
# out of 9 attempts when the probability of getting
# a head/W is 0.5
dbinom(6, size = 9, prob = 0.5)


