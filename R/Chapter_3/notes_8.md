## Notes from session #8
### Pages 61-68


#### Sampling to simulate prediction

Another common job for samples from the posterior is to ease **simulation**. Simulation, or a set of generated implied observations, is helpful for several reasons:

1. *Model checking*. After the model is fit to the data, it is worth generating implied observations to check the fit and to investivage model behavior.

2. *Software validation*. It's useful to simulate observations from a model and then recover the parameters that the new observations were generated under in order to make sure the code is right.

3. *Research design*. If you can simulate data, then you can evaluate whether the research design can be effect. Somewhat similar to *power analysis*.

4. *Forecasting*. Estimates can be used to simulate new predictions. Use them as data for training?

#### Dummy data

Bayesian models are always **generative**, capable of simulating predictions, because they provide us with a PDF/PMF that describes P(each outcome), which can be used to generate 'implied data' or *dummy data*. 

Without our globe example, the posterior PDF will be a binomial distribution with parameters n and p, where n = number of tosses and p = proportion that is water. We can use that resulting binomial distribution to simulate.

#### Model checking

This term means to ensure that the model was fit correctly and to evaluate the model's adequacy for some purpose.

**Retrodictions** are very useful for checking fitting. These are the predictions generated when the model uses the data it was fit on. An exact match isn't good (overfitting) and a complete mismatch is obviously bad.

#### Is the model adequate?

After making sure the model fit well enough, it's important to identify *how the model failed*, and work to improve that. All models fail, you can never predict on a large number of untrained data perfectly.

We can use the sampling of simulated observations to sample parameters from the posterior distribution.

It's important to use the entire posterior distribution, which contains a lot of uncertainty, because if we use a single parameter, then we have inflated confidence.

In our globe example there are two sources of uncertainty:

1. *Observation uncertainty*. There is uncertainty in the predicted observations because even if you know the parameter p with certainty, you won't know the next globe toss value with certainty, unless p = 0 or 1.

2. *Uncertainty about p*. The fact that we have a posterior distribution displays this. We are uncertain about p, so we are uncertain about everything that depends on p. This uncertainty will also interact with sampling variation - more uncertainty.

So, it'd be nice to **carry all the uncertainty forward**, as we evaluate predictions. We can do this by computing a *posterior predictive distribution*. This uses the entire posterior distribution to predict data rather than some single parameter or point estimate of the posterior. That is, P(generating estimate given by posterior) * estimate = prediction

Try to inspect your data for abnormalities in training data. Inspect it for patterns or correlations and determine what those mean for your data and whether or not those specifics are extreme enough to matter. Defining extreme will be its own task.

Model fitting is inherently objective, it is optimization, however model checking and evaluation are inherently subjective - we have a goal, we want to predict for Y reason. Subjectivity is scoffed at initially, but it allows for expertise to shine and become innovative.

#### Summary

Our fundamental tool is samples of a parameter value(s) drawn from the posterior distribution, this moves from calculus to counting. These samples can be used to produce intervals of defined mass and/or bounds, point estimates, posterior predictive distributions, etc...

Posterior predictive checks combine uncertainty about parameters with uncertainty about outcomes, which will better allow you to evaluate how your model is in adequate.

Sampling is a highly useful tool and increasingly becomes so with complex models.