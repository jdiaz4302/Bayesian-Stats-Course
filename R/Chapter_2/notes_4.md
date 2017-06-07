## Notes from session #4
### Pages 27-33


Formally, to randomize something means that you know almost nothing about its arrangement - to erase prior knowledge. If you have randomized sufficiently, then the arrangement is said to have high 'information entropy' (disorder).

#### Building a model

Designing a simple Bayesian model benefits from a design loop with 3 steps:

1. "Data story: Motivate the model by narrating how the data might arise."

2. "Update: Educate your model by feeding it the data."

3. "Evaluate: All statistical models require supervision, leading possibily to model revision."

#### A data story

You want to have a story for how the data came to be. Whether the story be purely description or strongly causal, it must sufficiently explain a way for generating new data, because simulating new data is a useful part of model criticism. You want to start by describing the underlying reality and the sampling process.

For example, lets say you want to know how much of Earth is covered in water. Your method is to toss a small globe and, with each catch, record if your "right index finger" is on water (W) or land (L). The realities here are:

1. There is a true proportion, p, of water covering Earth.

2. Each toss has probability p of resulting in a W and probability 1-p of resulting in L.

3. Each toss observation is independent of all others.

Telling a story is beneficial because it makes you more thoughtfully evaluate the 'large world'. Eventually you should discard the story because models can correspond to many stories and our model performing well does not say, 'Our small world idea is correct.'

#### Bayesian Updating

When we want to know the proportion of water on Earth, p, every possible p is more or less plausible based on the already-given data. A Bayesian model starts with assigning these plausibilities to the possible options - these are the prior plausibilities. The prior plausibilities are updating in light of new data to produce posterior plausibilities. This is 'Bayesian Updating'.

In this approach, every data point leads to an update. Prior leads to posterior, which becomes the next prior, until all the data is accounted for. This process also works backwards, you can obtain a prior from a posterior when knowing the new data that led to the posterior.

This is often not done iteratively, but it is approximated and easily-conceptualized when thought of iteratively.

In non-Bayesian statistical inference, sample size is more stressed because everything is justified by behavior at very large sample sizes, 'asymptotic behavior'. Behavior at small sample sizes is generally considered questionable, if not anecdotal.

The Bayesian approach does not question validity at small sample sizes, however the prior must be more heavily scrutinized because the prior is more dominant at small sample sizes.

#### Evaluate

Bayesian models are praised for how well they work with the small world, however that small world must be representative of the large world for highly optimal results to matter. There is no gaurentee of good large world performance.

A model's certainty is no gaurantee that the model is a good one. As the dataset grows, the model will become increasingly certain, however this certainty should be interpretted as, 'GIVEN A COMMITMENT TO THIS PARTICULAR MODEL, we can be very sure that plausable values are in a narrow range'. There is no gaurantee that your model is the best or even a good approximation of reality.

Think about everything that is irrelevent to your model, things that it doesn't account for, such as the order of the data it is given, and see how those 'irrelevant' or rather 'unaccounted-for' things affect the model. This is a creative endeavor. "FAILURE TO CONCLUDE THAT A MODEL IS FALSE MUST BE A FAILURE OF OUR IMAGINATION, NOT A SUCCESS OF THE MODEL."

There is no branch of applied mathematics that can provide universal gaurantees because math is not discovered, it is invented.

#### Components of the model

1. Likelihood

The likelihood is a mathematical function that specifies the plausibility of the data. Think of it as a probability mass/density function.

For our water proportion example, we know that (1) every toss is independent of the others, and (2) the probability of W on each toss is the same, p. Knowledge of probability theory tells us to the the binomial distribution.

Bayesian and non-Bayesian inference is mostly contrasted, but they both really of PDF/PMF's and how those affect the parameters of a model. These assumptions about PMF/PDF's matter more and more as the data grows, and that is why Bayesian and non-Bayesian can often be similar.