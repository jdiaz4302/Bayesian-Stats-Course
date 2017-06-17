## Notes from session #10
### Pages 77-84


#### A language for describing models

Learning the 'statistical language/vocabulary' is an important investment.

1. *Outcome variable*. This is what we're trying to predict or model.

2. For each outcome variable, we define a *likelihood distribution* or PDF/PMF. In linear regression, the distribution is always Gaussian.

3. There are also variables that we wish to use to predict or understand the outcome. These are the *predictor variables*.

4. We relate the shape of the likelihood distribution to the predictor variables, and, by doing so, we're forced to name and define all *parameters* that relate predictors to outcomes.

5. Also, we must choose *priors* to define the initial state of the model before seeing the data. *There is a prior for every parameter in the model*.

*Homoscedasticity* means constant variance.

#### Re-describing the globe tossing model

In this example, it was always the case that:

1. w ~ Binomial(n, p)
2. p ~ Uniform(0, 1)

This can be read as: The count "w" is distributed binomially with sample size "n" and probability "p", and the prior for "p" is assumed to be uniform between zero and one. From reading this, we now know all the assumptions. This is a standard model presentation. The first line is the likelihood function for the outcome, while the following lines define priors. The "~" indicates that something is *stochastic*, that it is mapped to a probability distribution - it is not certain; there can be *deterministic* definitions as well, those that are certain.

#### A Gaussian model of height - The first linear regression model of the book

We want our Bayesian model to consider every possible combination of mean and standard deviation and then rank them by posterior plausibility. What this is doing is *providing a measure of logical compatibility of each possible distribution with the data and the model*. So, the posterior will be a distribution of Gaussian distributions.

#### The data

We're going to model height. In doing so, we're going to exclude children, since age is correlated with height. The outcome is height, the potential predictors are age, sex, and weight.

#### The model

Our goal is to model these values using a Gaussian distribution, height tends to be Gaussian - afterall **height is a sum** of many small growth factors.

When doing proper modelling, you shouldn't inspect the data before deciding on the prior distribution. The prior should be conceptual and from existing knowledge and logic. If you're experimental data do not match the prior distribution, that is okay.

So far, we've decided that: h subscript i ~ Normal(mean, standard deviation)

We've decided that our prior will be Gaussian, but which Gaussian? Which mean and standard deviation?

*When looking at model definitions make sure to note index subscripts for proper interpretation; the indexing states that we assume that each values of that variable is independent and identically distributed*. This IID condition is rarely completely true; in our case, family members share genes - their heights will not be truly independent. It's normal to assume IID unless proven/inclined otherwise. It also doesn't tend to affect performance strongly unless the dependence (lack of independence) is strong.

**Back to our prior**. You often state each prior for the parameters independently, stating that they are independent. Let's say.

1. Height of each individual = h subscript i ~ Normal(Mean, Standard Deviation)
2. Mean ~ Normal(178, 20)
3. Standard Deviation ~ Uniform(0, 50)

*The prior for the mean is a Gaussian distribution centered on 178, with P(Mean within 40 of 178) = 0.95*.

You could've picked 178 because that's how tall you are in centimeters and the mean being within 40 of you is very likely. This is reasonable, however it's not always easy to be plainly reasonable.

*It's a good idea to plot your priors in order to see what you're saying*. It's important to note that:

1. A Gaussian prior isn't particularly informative, but it is slightly.
2. A uniform prior sets, and excludes, a positive probability for a range, out of that range.

*An upper limit of 50 for the uniform distribution, which is the prior for the standard deviation, states that there is a 95% chance that an individual's height is within 100cm of the average (your) height.* This is a very large, non-exclusive range.

You can sample priors and evaluate them similarly to how you did posteriors; afterall, prior/posterior is relative - one can be the other.


