## Notes from session #16
### Pages 119-135


#### Multivariate Linear Models

Waffle House is likely the most reliable source of waffles in the entire world; waffle houses tend to even be open following hurricanes due to their disaster preparedness, sometimes with limited menus. FEMA informally uses the status of Waffle Houses to gauge the severity of a disaster event.

A strange thing is that states with more Waffle Houses tend to have higher divorce rates. Do waffles and hashbrowns push marriage at risk?

Likely not; what explanatory mechanism could account for that? The more likely answer is that Waffle House is more present in the south, where people tend to marry younger. The fact that these two occur together is likely just coincidence. 

In large data sets, every pair of variables has a statistically discernible non-zero correlation. These do not necessarily imply causal relationships; they usually just mean association, because that is so easy to find with a lot of data.

This is why *multivariate regression* is important, more specifically:

1. They profound control for *confounds*; you can see strong correlations between variables and determine if one is actually mysterious or just associated with a strong predictor. *Sometimes a confound can even reverse a trend, from positive to negative correlations (or vice-versa)*.

2. They provide a way to examine *multiple causation*. Further this helps *decompose larger singular effects into smaller, multiple effects that covary to some extent*.

3. They allow us a way to examine *interaction*, allowing *effective inference to depend upon the consideration of other variables*.

#### Chapter goals

Two foci here will be to *(1) learn how to reveal spurious correlations* and *(2) learn how to reveal important correlations that may be masked by unrevealed correlations with other variables*.

#### Forewarning

Multivariate models can hurt just as much as they can help; particular *multicollinearity*; that is, you collected for and made a more complicated model for nothing.

There is no way to gaurantee causation from statistical tests; there can always be someone who will argue against it.

#### Spurious association

Comparing single variable regressions is no way to determine the value of each. *Multivariate regressions allow us determine the predictive value of a variable, once you already know all of the other predictor varaibles - instead of having no information about them, as is the case in single variable.*

A multivariate regression allows you to ask and answer "After I know X1, what *additional value* is there in knowing X2 (and vice-versa)?" 

**Discipline your statistical language: remember to distinguish between the small and large worlds. Always question absolute language.**

#### Multivariate notation

The model definition is essentially just expanded, you include all of your predictors into the mu definition and add the appropriate number of prior definitions. For example:

1. Divorce Rate ~ Normal(mu, sigma)

2. mu = intercept + (Marriage rate coefficient)(Marriage rate observation) + (Median age at marriage coefficient)(Median age observed)

3. intercept ~ <prior distribution 1>

4. Marriage rate coefficient ~ <prior distribution 2>

5. Median age at marriage coefficient ~ <prior distribution 3>

6. sigma ~ <prior distribution 4>

Summation notation of mu: mu of i = Alpha + (the sum from j to n of (Betaj*Xij))

#### The computationally popular notation

Design matrix notation: *m* = *X**b*. Here, *m* is a vector of predicted means, *X* is the matrix of observations, and *b* is the vector/column of parameters. *X* gets an extra column of 1's, which are multipled by the first row of *b*, which is the intercept value.

#### Fitting the model

Fitting the model simply ammounts to putting the new model into the old workflow.

If `precis()` contains some predictors with large-magnitude parameter rates/slopes and some with very small magnitudes, it means that those small-magnitude-rate variables provide little-to-no additional predictive power. They are not necessarily useless though, *they could provide predictive power by themselves without any other information*. 

#### Plotting multivariate posteriors

Visualizing performance over several variables is difficult, but three good approaches are:

1. *Predictor residual plots*

2. *Counterfactual plots*

3. *Posterior prediction plots*

None of these plots are perfect; each has advantages and disadvantages.

#### 1: Predictor residual plots

The summary of what this does is as follows:

1. Model 1 predictor (acts as temp outcome) on the another predictor

2. Get the residuals: (temp outcome value at predictor value) - (predicted mean at that predictor value)

3. Build model which uses those residuals to predict the true outcome variable

4. Examine parameters of that model

5. Plot it

This approach works best in linear models that are purely additive; that is, intercept + rate1(var1) + rate2(var2) + etc. They clearly show the association between a predictor and the outcome after accounting for the knowledge of the other predictor(s); the residuals supply that "knowledge".

#### 2: Counterfactual plots

These plots simulate predictions from the posterior, and, without showing true data points, display probability intervals (PI's or HPDI's) on the scale of the data using the multivariate model on 1-predictor-as-x plots. As a result, they display the impact on prediction which comes about from changing each variable (granted that you plot them for each variable).

*These draw criticism from the fact that sometimes its not possible to change 1 variable without changing others, and that is afterall what these plots display - the change brought about by only changing 1 variable*.

#### 3: Posterior prediction plots

These plots include plotting:

1. Each mean prediction versus its real observation; where each prediction/observation point includes a PI/HPDI segment for the mean prediction.

2. The difference/residual of each observation from the mean observation (*average residual*), along with mean PI/HPDI and prediction PI/HPDI about that differenced point.

3. *Plot average residuals against new possible predictors to see if new predictors are associated with the remaining variation in the the data*.

#### Stats, what is it good for?

People often use statistics to answer, "Is there a real effect?" A correlation could, however, always be eliminated or reversed with the addition of a new predictor. Statistical "tests" are not the truest tests, model criticism and revisions of scientific hyptheses are more accurately the true tests.

Particular spurious variables can come about if they and the outcome variable are both effected by the true variable(s).


