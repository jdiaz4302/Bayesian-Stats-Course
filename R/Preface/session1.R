


# A reminder that things are less complicated when you inspect line-by-line
x <- 1:2
x <- x*10
x <- log(x)
x <- sum(x)
x <- exp(x)
x



# Two things that are mathematically identical, yet different in R
# Due to computing methods
log(0.01^200)
200 * log(0.01)
# The reason these are different is because 0.01^200 is rounded to zero in
# The first of the two lines. The second yields the correct answer.
# Lesson: use the log of a probability when its very small.



# Import the data
data(cars)

# Fit a linear regression of distance on speed
m <- lm(dist ~ speed,
         data = cars)

# Estimated coefficients from the model
coef(m)

# Plot residuals against speed
plot(resid(m) ~ speed,
     data = cars)



# Installing rstan
install.packages("rstan",
                 repos = "https://cloud.r-project.org/",
                 dependencies = TRUE)



# Verifying that the toolchain works
fx <- inline::cxxfunction(signature(x = "integer",
                                    y = "numeric"),
                          'return ScalarReal(INTEGER(x)[0] * REAL(y)[0]);
                          ')

# Should return 10
fx(2L,
   5)
# And it did


