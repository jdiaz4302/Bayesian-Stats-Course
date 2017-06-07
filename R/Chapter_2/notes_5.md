## Notes from session #5
### Pages 34-45


#### Parameters

The Bayesian use of 'parameter' is particularly confusing because it includes both data and 'parameters'/constants. Usually, data = known & parameters = estimated. However, you can think of data as extremely narrow/likely estimates, and parameters as probabilistic/uncertain data. You can exploit this to incorporate missing data and errors, later.

PMF/PMF's have adjustable inputs called 'parameters'. They can be constants describing some aspect of the data or a quantity that we want to estimate; they represent causes or explanations. It can be thought that you provide some parameters literally or through data, and the model derives estimate parameters from those.

The most common questions in statistical modelling are answered by parameters:

1. "What is the average distance between treatment groups?"

2. "How strong is the association between a treatment and an outcome?"

3. "Does the effect of the treatment depend upon a covariate?"

4. "How much variation is there among groups?"

#### Prior

In Bayesian modelling, for everything you want estimated, you must provide a prior or initial set/distribution of plausibilities. The prior can be whatever is deemed reasonable or appropriate, from theory to previous empiracle results. When assuming no prior knowledge, you can use a uniform random variable as the prior and allow the model to learn from there.

Priors are often called regularlizing priors or weakly informative priors because, when non-uniform, they provide a nudge in the right conceptual direction, generally increasing inferential ability. This advantage has been mimicked in non-Bayesian procedures via 'penalized likelihood'. Priors are very helpful in making the model give reasonable estimates, because they can rule out impossibilities and suggest things that make sense or that are expected.

The sciences tend to express a desire to not be strongly subjective in prior - they don't like/want people choosing priors based on personal beliefs, however one method or the other is not inherently better. Also, by choosing any statistical procedure there is some degree of subjectivity.

"STATISTICIANS DO NOT IN GENERAL EXACTLY AGREE ON HOW TO ANALYZE ANYTHING BUT THE SIMPLEST OF PROBLEMS." There is generally more than one way to conduct an analysis, "ENGINEERING USES MATH AS WELL, BUT THERE ARE MANY WAYS TO BUILD A BRIDGE."

A prior is an assumption, and it should be scrutinized, tested, and thrown-out, just as all other assumptions would be.

"IF YOUR GOAL IS TO LIE WITH STATISTICS, YOU'D BE A FOOL TO DO IT WITH PRIORS". Afterall, they're right there at the beginning. It'd be easy to fake or alter data, not to promote that.

Choosing a prior is a requirement for using a Bayesian approach, just as non-Bayesian approaches must make choices exclusive to their approach. Often these choices have analogs.

#### Posterior

Model estimates are the logical results of your chosen PDF/PMF, parameters, and priors. The resulting esimates are the 'posterior distribution'. This takes on the form of P(parameter|data) and is explained by 'Bayes' Theorem', which states that P(E and F) = P(E|F)*P(F).

As a result, P(paramter|data) = (P(data|parameter)*P(parameter))/P(data), where:

1. P(parameter|data) = Posterior
2. P(data|parameter) = Likelihood
3. P(parameter) = Prior
4. P(data) = E[P(data|parameter)*P(parameter)] = Average/Marginal Likelihood. A marginal is the expectation of something that is conditioned.

The big idea: the posterior is proportional to the product of the likelihood and the prior.

Bayesian data analysis is not distinguished by the use of Bayes' Theorem, non-Bayesian analysis uses that as well. It is distinguished by the fact that it uses Bayes' Theorem more generally to quantify uncertainty about the estimated entities.

#### Making the model go

It is difficult to condition formally, it may require only using special forms of standard statistical techniques, however there are several numerical techniques that, when combined, can approximate the formal math. Here are widely-used ones:

1. Grid Approximation
2. Quadratic Approximation
3. Markov Chain Monte Carlo

Your choice of model-fitting-method (loss function?) influences your results. The same prior can be fitted to different posteriors when using different fitting techniques.

#### Grid Approximation

This is similar to Riemann Sums. You can approximate any posterior distribution with a finite number of values from that distribution. If you do this in equal-sized grids, you get an approximate picture of the posterior probability. This is called grid approximation. Grid approximation is not often practical, but it useful to learn. It becomes very difficult with a lot of parameters. 

How to do Grid Approximation:

1. Define the grid
2. Compute the value of the prior at each grid
3. Compute the value of the likelihood at each grid
4. Prior*likelihood = unstandardized posterior
5. Standardize the posterior by dividing each value by the sum of all values

#### Quadratic Approximation

For every parameter that your model has, you add a new dimension to the number of grids, so grid approximation becomes less viable with more parameters.

Qaudratic Approximation is computational cheap, and it works as follows:

1. Find the posterior 'mode'/peak/maximum.
2. Analyticly or through numeric approximation, find the curvature of the peak so that you can approximate a normal distribution.

The Qaudratic Approximation with a uniform prior or with a lot of data is the equivalent of a Maximum Likelihood Estimator and its standard error, which was a curse and a blessing to discover.

A "Hessian" is a sqaure matrix of 2nd derivatives. When used with the Quadratic Approximation, it is the 2nd derivatives of the log of posterior probability with respect to the parameters. These are sufficient to describe a normal distribution because the 2nd derivative of the log of a normal distribution is proportional to its inverse sqaured standard deviation, the 2nd derivative also tells where there mode/peak/maximum is. So the "Hessian" is usually a required computation; also, it'll give you error messages.

#### Markov chain Monte Carlo

MAP - posterior distribution, 'maximum a posteriori'

Markov chain Monte Carlo is a fitting technique that works well with highly complex models. We're apparently just skimming this for now. It involves sampling rather than analytical techniques.

#### Summary

The goal of Bayesian inference is a posterior probability distribution, which began as a prior and was updated in light of new data.

A Bayesian model consists of a likelihood (P(data|parameters)), parameters, and a prior.

Bayesian models are fit using numerical techniques / approximations, with varying trade-offs.