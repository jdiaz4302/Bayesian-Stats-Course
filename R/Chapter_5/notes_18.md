## Notes from session #18 and # 19
### Pages 153-162


#### Binary categories

The simpliest case of categories are binary categories, where there are only 2, such as male and female.

In these cases, you have a *dummy/indicator variable*, which has value 1 when the variable name is present and 0 if not present.

#### Many categories

If you have k categories, you need k-1 dummy/indicator variables.

#### Adding regular predictor variables

When you incorporate continuous variables into a model with categorical variables, the coefficients for the continuous variables can be adjusted such that different categories respond differently to changes in the continuous variables.

#### Ordinary least sqaures and `lm()`

Gaussian regression models are more commonly known as *ordinary least squares regression* or *OLS* for short. Instead of maximizing posterior probability, OLS minimizes the sum of squared residuals. **OLS was invented to compute Bayesian MAP estimates**.

`R` has a built in way of doing OLS via `lm()`, which yields very similar results to `map()` with flat priors.

OLS via `lm()` is much more compact, and, although flat priors are not always ok, it's useful to understand how it works from a Bayesian perspective. Also, its important to note that *amount of data can trump any reasonable prior*.

#### Design formulas

*Design* formula is much more compact than what we've been using because it doesn't deal with priors. It reduces:

1. y ~ Normal(mu, sigma)
2. mu = alpha + (beta)(x) + ...

into:

1. y = 1 + x + ...

This is easily thought of and converted to the linear algebra that the computer does.

#### Using `lm()`

Doing OLS in `R` largely boils down to... `lm(y ~ 1 + x + ... , data = df)`

#### Intercepts are optional

Both:

`lm(y ~ 1 + x, data = d)`

`lm(y ~ x, data = d)`

return exactly the same thing, R assumes that you want an intercept.

The following omits an intercept:

`lm(y ~ 0 + x, data = d)`

`lm(y ~ x - 1, data = d)`

#### Categorical variables

Although it automatically handles categorical variables, `R` can get confused, so it's safe to always specify, such as:

`lm(y ~ 1 + as.factor(season of year), data = d)`

#### Transform variables first

`lm()` can be finicky about doing variable transformations, such as `log()`, inside its function, so it's best to do these specifically before you try to fit a model.

#### No estimate for sigma

`lm()` does not provide a distribution for sigma, it instead provides **residual standard error**, which is a slightly different estimates. This is okay, as long as you do not want to construct prediction intervals.

#### Building `map` formulas from `lm` formulas

The `rethinking::glimmer` function which writes a `lm` function as a more-Bayesian `map`. See `?glimmer` for more options.

#### Summary

In light of everything else, it's important to remember that a model describes the data it is fed; therefore, it may not always translate as you expect. Also, the models so far have assumed that all the predictors are independent; this may not truly be the case.


