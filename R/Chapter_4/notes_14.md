## Notes from session #14
### Pages 102-


#### Plotting regression intervals and contours

Since the posterior is a distribution, we can find intervals for it - rather than plotting a million semi-transparent lines.

You can plot distribution summaries with just a few lines of code. The process is essentially:

1. Using `link()` to generate posterior values for mu. `link()`'s default is to use the original data, so you should input an evenly spaced sequence along the x-axis.

2. Use summary functions, such as `mean()` and `rethinking::HPDI()`.

3. Plot them using `lines()` or `shade()`, for lines and intervals, respectively.

Even really bad models can have very narrow confidence intervals, seemingly indicating that it is very sure of the mean value at a given point on the line. This should more accurately be interpretted as, "Conditional on the assumption that y and x are related by a straight line, then this is the most plausible line, and these are its plausible bounds."

All that `link()` does is compute outcomes using the original (or input) predictor values for each combination of parameter values sampled from the posterior.

#### Prediction intervals

The less samples you take, the more jagged your confidence interval will apepar due to simulation variance in the tails of the sample distributions.

# Two kinds of uncertainty

Remember there is uncertainty associated with parameters due to our model's outcome being a posterior distribution, and there is also uncertainty associated with the outcomes because they're stochastic.

Sometimes you use a Gaussian as a way of estimating mean and variance, rather than because you think the variable is "normal"; in this case, it doesn't entirely make sense to take samples because you do not believe they are accurate.

#### Polynomial Regression

Polynomial regression can be non-ideal because polynomials can be difficult to interpret, however they're common and sometimes practical. Here's the model we're going to use:

1. mu of i = alpha + beta1(weight of i) + beta2(weight of i)^2

"Linear model" refers to a model using only 1 predictor variable, weight. These models are easier to fit, but they generally incorporate only partial correlations (things are left out) and are used thoughtlessly, from a rigorous analytical perspective.

*Standardizing variables*, (var - mean(var))/sd(var), is a good practice because:

1. It makes it to where every variable involved changes by a unit 1 when standard deviation changes by a unit of 1, this makes different types of variables easier to compare.

2. Standardizing resolves issues with fitting on the computational end.

The new model definition is:

1. h of i ~ Normal(mu of i, sigma)
2. mu of i = alpha + beta1(weight of i) + beta2(weight of i)^2
3. alpha ~ Normal(178, 100)
4. beta1 ~ Normal(0, 10)
5. beta2 ~ Normal(0, 10)
6. sigma ~ Uniform(0, 50)


