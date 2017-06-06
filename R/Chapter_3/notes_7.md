## Notes from session #4
### Pages 52-61


#### Sampling from a grid-approximate posterior

If our posterior represents the plausibility of water proportions on Earth, then you can think of it as a bucket full of parameter values, such as 0, 0.5, 0.75, etc... Each value exists in proportion to its posterior probability, so more counts of a value indicate that its more likely. If we sample a large number of samples, such as 10,000, then we'll have the posterior in frequency format; our samples will appear in the same proportion as their posterior probability.

More samples -> better approximation of the posterior

#### Sampling to summarize

"Once your model produces a posterior distribution, the model's work is done. But your work has just begun." The questions you ask from here are context-specific, but some common ones include:

1. How much posterior probability lies below some parameter value?
2. How much posterior probability lies between 2 parameter values?
3. Which parameter value marks the lower 5% of the posterior distribution?
4. Which range of parameter values contains 90% of the posterior distribution?
5. Which parameter value has the highest posterior probability

More generally, these are questions about:

1. Defined boundaries
2. Intervals of defined probability mass
3. Point estimates

And all of these questions can be approached using samples from the posterior distribution.

#### Intervals of defined boundaries

Suppose you want to know P(proportion of water < 1/2). Well, you can just add all the P(x) for x < 1/2. This is more intuitively done by working with sample counts than with a distribution and the subsequent integral.

#### Intervals of defined mass

One of the most sought-after metrics in science is the 'confidence/credible interval', an interval of defined mass. These intervals contain a specified amount of the posterior probability, a probability mass. For example, you may want to know the boundaries of the lower 80% of the distribution.

Intervals that which assign probability mass equally to the tails of the distrubtion are very common in science - we call them **percentile intervals**; these are wanting to know the middle X%, so each tail gets (1-X)/2 mass removed. Unless the data are skewed, percentile intervals do a good job approximating the shape of the posterior distribution; this is why p-values are used to hand-wavingly conclude whether parameters are consistant with data.

However, percentile intervals can be misleading with skewed data because they can exclude the most probable values of the distribution. In these situations, a HPDI - **highest posterior density interval** - will be better; this is the *narrowest* interval containing the specified probability mass.

Generally, the two intervals are very similar. HPDI only differs and provides an advantage in skewed distributions.

The HPDI is more computationally expensive and they are more sensitive to *simulation variance*, so you should use it only when you have sampled a large number from the posterior distribution.

It would be rational to not use any interval type if there is large variation between intervals; afterall, the entire distribution is what your model provided. The intervals are only useful for summarizing that distribution.

The most common interval in the sciences is the 95% interval, which leaves a 5% chance that the parameter value is not in the interval; this is the basis of *statistical signficance*. It's not really easy to defend other than on the basis that it's standard. The number of standard deviations needed to achieve a p-value of 0.05 is 2, which makes offers some reasoning but you could always change your p-value or standard deviations of interest to a stricter or looser exclusion. 

In the non-Bayesian philosophy, the 95% confidence interval should be interpretted as "if we repeat the study and analysis a large number of times, then 95% of the computed intervals would contain the true parameter value." In Bayesian, the 95% confidence interval has a 95% chance of containing the true parameter value. It important to note that the 'true' value is not a 'true value', it is a small world value.

#### Point estimates

Its often very tempting to provide a single number - a point estimate, such as a mean, median, mode, etc... Given that Bayesian analysis provides an entire distribution, how do you narrow that down to 1 infinity of that? Well, you don't have to, and you often don't need to.

However, it can be beneficial to provide point estimates for the sake of communication. Here are some common ones:

1. MAP (*maximum a posterior*) estimator - the highest posterior probability value. You can calculate this from the distribution, or you can calculate the mode from the samples.

2. Median

3. Mean

You can use a **loss function** to decide on which estimator to use, *however* different loss functions can suggest different estimators.

Let our loss function be sum(|estimator - each value| * P(each value)), or the 'weighted average of losses' - this is the absolute loss function. This particular loss function yields the median.

There is also the quadratic loss function (estimator - each value)^2 which yields the mean.

The more 'normal' and symmetrical a distribution is, the more mean and median converge. In disaster planning, such as deciding when to evacuate, you often use unique loss functions. Your parameter is wind speed. 'costs' are huge if winds are higher than expected and kill/harm people, and they're lower if we expect harsher winds than true. Therefore the loss functions used in those settings highly penalize underestimates while going easier on overestimates. Therefore the 'optimal' posterior tends to overestimate because that's safer.

This is important to think on because it shows that addressing things that are often not addressed can lead to significant improvements - lives in the disaster modelling reference. Question every decision with the model. Modelling cannot trump thinking.


