## Notes from session #18
### Pages 153-159


#### Binary categories

The simpliest case of categories are binary categories, where there are only 2, such as male and female.

In these cases, you have a *dummy/indicator variable*, which has value 1 when the variable name is present and 0 if not present.

#### Many categories

If you have k categories, you need k-1 dummy/indicator variables.

#### Adding regular predictor variables

When you incorporate continuous variables into a model with categorical variables, the coefficients for the continuous variables can be adjusted such that different categories respond differently to changes in the continuous variables.

#### Ordinary least sqaures and `lm()`

Gaussian regression models are more commonly known as *ordinary least squares regression* or *OLS* for short. Instead of maximizing posterior probability, OLS minimizes the sum of squared residuals. **OLS was invented to compute Bayesian MAP estimates**.

`R` has a built in way of doing OLS via `lm()`