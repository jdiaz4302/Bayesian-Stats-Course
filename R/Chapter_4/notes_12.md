## Notes from session #12
### Pages 86-94


#### Fitting the model with *map*

We're now forgetting about grid approximation and, in replacement, moving on to the better *quadratic approximation*. The quadratic approximation quickly infers the shape of the posterior. The peak of the posterior will likely lie at the MAP (*maximum a posteriori*) estimate; we can then get a useful image of the posterior's shape by using quadratic approximation at that peak.

When you have a lot of data, you have to have *very* strong priors in order to strongly affect inference.

We have seen that priors can affect inference though, and most non-Bayesian estimates use flat priors (by not having priors at all); flat priors are hardly ever the best priors.

A prior can be interpretted as previous data, a former posterior to work with.


#### How strong is a prior?

We used mu ~ Normal(178, 0.1) as a prior. How can we be that confident in sd(mu) = 0.1; that its so narrowly distributed around 178? Perhaps because we have some amount of data suggesting so. There is a formula to determine the *implied amount of data* for a determining sd(mu) from a Gaussian posterior. It is sd(mu) = 1/sqrt(n); this is exactly the same as the *standard error of the sampling distribution* from non-Bayesian inference.

So, the implied amount of data = 1/(sd(mu)^2). This means that for us to say sd(mu) = 0.1, *we would need 1/(0.1^2) = 100 observations*; that's pretty "strong". Our earlier prior of sd(mu) = 20 would need 1/(20^2), less than 1, observation; that's extremely weak.

#### Sampling from a map fit

It's important to recognize that a quadratic approximation to a posterior distribution with more than 1 parameter dimension is just a multidimensional Gaussian distribution.

A list of means and a matrix of variances & covariances is sufficient to describe a multi-dimensional Gaussian distribution, so R computes all of that; the list and the matrix. The matrix tells us how each parameter relates to every other parameter in the posterior distribution.

The matrix can be reduced to:

1. A vector of variances and
2. A correlation matrix, which tells how changes in 1 parameter leads to correlated changes in other parameters

#### Adding a predictor

So far, we only have a Gaussian distribution to model height; there is no predictor variable. We will be adding weight as a predictor.

Regression is broadly used nowadays to mean "modelling the distribution of outcomes through the use of predictor variables"; it was originally used in noting that the sons of tall and short men tend to be more similar to the population mean - "regression to the mean".

This phenomenom arises statistically when individual measurements are assigned to a common distribution, leading to *shrinkage* as each measurement informs others. For the father-son example, each each is similar to their father, but regresses/shrinks towards the mean. This shrinkage to the mean is a more accurate estimate than using only the father's measurement. *This principle applies broadly and abstractly - each outcome is informed by its predictors but regressed towards the mean*.

#### The linear model strategy

In a linear model, the goal is to make the mean of the Gaussian distribution into a linear function of predictor(s). The assumption is then that the predictor(s) has a constant relationship with the mean of the outcome. You then compute the posterior distribution of this relationship.

Some parameters now stand for the strength of the relationship and the value of the predictor. For each parameter combination, you compute the relative plausibility, given the model and data.

So, recall the basic model for height:

1. h of i ~ Normal(mu, sigma)
2. mu ~ Normal(178, 20)
3. sigma ~ Uniform(0, 50)

We need to incorporate weight, as a predictor, into the model. This can be done as follows:

1. h of i ~ Normal(mu of i, sigma)
2. mu of i = alpha + beta*(x of i)
3. alpha ~ Normal(178, 100)
4. beta ~ Normal(0, 10)
5. sigma ~ Uniform(0, 50)
6. x of i = weight measurement

"mu of i" now exists because each height depends on each unique observation's weight; "the mean of the height, depends on the observation of the predictor(s)."

"mu" is no longer stochastic, it is deterministic; we know it, via the relationship, when we know the parameters defining it. "x" is the value of the predictor. 

Alpha is the expected height when weight = 0, and Beta is the expected change in height when weight changes by a unit of positive 1. What this amounts to is a line of intercept Alpha and slope Beta that relates weight to height. These line models are conventional, not necessarily good; its up to the science to determine the best functional form of mu.

#### Units and regression models

Having units allows you to more easily identify a model, for example Beta can be thought of as a rate. On the opposite side, there is a tradition called *dimensional analysis* that promotes constructing unit-less ratios; you divide your measurements by a reference measurement in order to remove units - after all, measurement scales are constructs and unit-less analysis is "more natural".