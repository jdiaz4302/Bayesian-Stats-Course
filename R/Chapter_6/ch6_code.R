


# More parameters always improves fit
# Create the df
# Each column first
sppnames <- c("afarensis",
              "africanus",
              "habilis",
              "boisei",
              "rudolfensis",
              "ergaster",
              "sapiens")

brainvolcc <- c(438, 452, 612, 521, 732, 871, 1350)

masskg <- c(37.0, 35.5, 34.5, 41.5, 55.5, 61.0, 53.5)

# The df
d <- data.frame(species = sppnames, brain = brainvolcc,
                mass = masskg)

# The simplest model
m6_1 <- lm(brain ~ mass, data = d)

# View R-squared
1 - var(resid(m6_1)) / var(d$brain)
# This is also under "Multiple R-squared" in...
summary(m6_1)
# At .47

# More complex model
m6_2 <- lm(brain ~ mass + I(mass^2), data = d)
summary(m6_2)
# At .52

# Increasingly complex models
m6_3 <- lm(brain ~ mass + I(mass^2) + I(mass^3), data = d)
summary(m6_3)
# At .66

m6_4 <- lm(brain ~ mass + I(mass^2) + I(mass^3) + I(mass^4),
           data = d)
summary(m6_4)
# At .80

m6_5 <- lm(brain ~ mass + I(mass^2) + I(mass^3) + I(mass^4) +
             I(mass^5), data = d)
summary(m6_5)
# At .98

m6_6 <- lm(brain ~ mass + I(mass^2) + I(mass^3) + I(mass^4) +
             I(mass^5) + I(mass^6), data = d)
summary(m6_6)
# At 1.00

# Visualize it
plot(d$brain ~ d$mass, pch = 16, ylim = c(-500, 2000))
# 1st model added
x <- with(d, seq(min(mass), max(mass), length.out = 1e4))
y <- predict(m6_1, newdata = data.frame(mass = x))
lines(x, y, col = "yellow", lwd = 2)
# 2nd model added
y <- predict(m6_2, newdata = data.frame(mass = x))
lines(x, y, col = "purple", lwd = 2)
# 3rd model added
y <- predict(m6_3, newdata = data.frame(mass = x))
lines(x, y, col = "orange", lwd = 2)
# 4th model added
y <- predict(m6_4, newdata = data.frame(mass = x))
lines(x, y, col = "limegreen", lwd = 2)
# 5th model added
y <- predict(m6_5, newdata = data.frame(mass = x))
lines(x, y, col = "blue", lwd = 2)
# 6th model added
y <- predict(m6_6, newdata = data.frame(mass = x))
lines(x, y, col = "red", lwd = 2)
# Add 0 line
abline(h = 0, lty = 2)


# Too few parameters hurts too
# A model that is only an intercept
m6_7 <- lm(brain ~ 1, data = d)
plot(d$brain ~ d$mass, pch = 16)
y <- predict(m6_7, newdata = data.frame(mass = x))
lines(x, y, col = "red", lwd = 2)
# All this does is predict mean(brain volume)


# View the sensitivity to training data
# Underfit model
plot(brain ~ mass, d, col = "slateblue", pch = 16)
for (i in 1:nrow(d)) {
  d_new <- d[-i, ]
  m0 <- lm(brain ~ mass, d_new)
  abline(m0, col = "grey35")
}

# Overfit model
plot(brain ~ mass, d, col = "slateblue", pch = 16,
     ylim = c(-500, 2000))
for (i in 1:nrow(d)) {
  d_new <- d[-i, ]
  m0 <- lm(brain ~ mass + I(mass^2) + I(mass^3) + I(mass^4) +
             I(mass^5), d_new)
  y <- predict(m0, newdata = data.frame(mass = x))
  lines(x, y, col = "grey35")
}


# Deviance and Log-probabilities
# It's generally easy to get deviance in R
(-2) * logLik(m6_1)
# Deviance is based on uncertain parameters, so it
# Has a posterior distribution, although R only reports
# A point estimate


