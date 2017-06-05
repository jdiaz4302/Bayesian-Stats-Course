


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


