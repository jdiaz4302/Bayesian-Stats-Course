## Notes from session #4
### Pages 49-52


#### Introducing posterior inference

Posterior inference is normally introduced with a medical testing example, along the lines of...
P(vampire|test positive) = (P(test positive|vampire) * P(vampire))/P(test positive)

Most people find this counterintuitive, however it is only logical. Whenever a condition of interest is very rare, having a test that finds all the true cases is still no gaurantee that a positive result carries much information; most positive results are false positives.

This isn't inherently Bayesian, because all philosophies of statistics would recommend this, this is the right thing to do. Bayesian inference is characterized by a broad view of probability, not the use of Bayes' Theorem.

Its much easier to think of these false positive testing examples using counts rather than probabilities; this is often called the 'frequency format' or 'natural frequencies'. For example, instead of thinking of P(test positive|vampire) = 0.95, P(test positive|not vampire) = 0.01, and P(vampire) = 0.001, it's much easier to think of 100,000 people in town, 100 are vampires, of those 100, 95 will test positive, of the 99,900 non-vampires, 999 of them will test positive, It's then very easy to see how testing positive doesn't imply that you're likely a vampire.

It's often helpful to go-and-forth between approaches because rephrasing problems can lead to break throughs.

This frequency format is believed to be easier because "nobody has ever seen a probability." or "PROBABILITY DOES NOT EXIST". It's thought to be a matter of human psychology.

This intuition can be exploited to take probability distributions and take samples from them to produce counts and then work with those counts. These sampled events or counts are now parameters, and the values of those parameters (and the distribution as a whole) have relatively plausibilities brought about by imperfect information. Literally, the posterior distribution defines the expected frequencies of that different parameter values will appear.

This frequency count approach simplifies things because you move from working with decimals and integrals to counts and summaries. **Therefore it is much easier to work with counts sampled from the posterior distributions than to work with posterior distributions.** This allows makes you more familiar with sampling techniques that commonly used in high-level approximations, and high-level tends towards standard as time goes on.

The goal of this chapter is to get use to sampling in order to produce summaries and simulate model output.

#### Statistics can't save bad science

Hypothesis testing can be thought of similarly to the medical testing examples, they are both **signal detection** problems.

1. There is supposedly a binary state that is hidden from us (positive/negative & null/alternate hypothesis).

2. We observe an imperfect cue of the hidden state, our test/metric/experiment.

3. We **should** use Bayes' Theorem to logically deduce the impact of our cue on our uncertainty.

The third step is hardly ever done in science. Suppose there's P(signal|hypothesis is true) = 0.95, this is called 'power'. Also, there's  P(signal|hypothesis isn't true) = 0.05, 'false-positive rate' - think of this is the standard 5% significance testing. In order to do the 3rd step, you must set a 'base rate' of P(of all hypotheses that are true) or P(hypothesis is true). History suggests this number is low. You then plug calculate P(hypothesis is true|signal) = P(signal|hypothesis is true) * P(hypothesis is true) / P(signal). Where P(signal) can be P(signal|true positive)P(true positive) + P(signal|false positive)P(false positive).

Therefore, the only way to improve P(hypothesis is true|signal) is to reduce false-positive rate and increase the conceptual correctness of the signal - aka you need good science
