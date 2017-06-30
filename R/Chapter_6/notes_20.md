## Notes from session 20
### Pages 177-188


#### Information and uncertainty

If we want to measure uncertainty, we should want that:

1. The measure of uncertainty be continuous

2. The measure of uncertainty should increase as the number of possible events/outcomes increases

3. The measure of uncertainty should be additive; the uncertainty over all outcomes should be the sum of the separate outcomes

The above were used to derive the **information entropy** function. Which states, when there are n different possible outcomes, the uncertainty contained is equal to the negative sum from 1 to n of each probability times the log of that probability; that is, *the uncertainty is equal to the average log probability of an event*.

Prove that this equation is useful with a simple exercise:

1. Imagine you live somewhere that has 30% chance of rain on any given day (no rain implies sunny day), then the information entropy is... -(0.30(log(0.30)) + 0.70(log(0.70)))... 0.61. So, "The information entropy (uncertainty) is equal to 0.61"

2. By comparison, imagine you live in the desert, which has 1% chance of rain on any given day, then the information entropy is... -(0.01(log(0.01)) + 0.99(log(0.99)))... 0.06. So, "The information entropy is equal to 0.06"

This demonstrates that, at least anecdotally, the information entropy function provides an intuitive answer; there is less "uncertainty" when there is one possible outcome that is almost always guaranteed.

Now let's show that more possible outcomes yield higher uncertainty:

3. Imagine 15% rain, 15% snow, and 70% sunny. Then information entropy is... 0.82; higher, as we'd want

If a possible outcome has probability zero, then it will mess up the calculation... BUT it's not really a "possible" outcome, so you can remove it.

#### From entropy to accuracy

**Kullback-Leible divergence** quantifies the additional uncertainty induced by using probabilities from one distribution, our model, to model another distribution, reality. Mathematically, it is the average difference (target - model) in log probability between target and model. If target and model are identical, this is zero.

As the model becomes less similar than the target, divergence grows.

Divergence is derived by using the information entropy equation. Remember, it is the "additional uncertainty by using probabilities from one distribution to model another".

1. Using 1 distribution to model another: (target probability)(log(model probability))

2. Additional: - target(probability)(log(target probabiltiy))

3. Together: The negative sum from i = 1 to n of target(probability)(log(model probability) - log(target probability))

Divergence is "directional", so it's important to enter into the equation in the correct order.

#### From divergence to deviance

So divergence gives us a way to measure the distance from our model to the target - now we need a way to estimate it in real statistical modelling.

So far we've acted as if we can know the target, but that is almost never the case; if it were the case, modelling would be silly.

Generally, you're not going to get a "true" model; more likely, you have a set of models that you want to compare. So, all we have to do is know which one of our models is the best.

One way to compare models would be to use **deviance**, an approximation of K-L divergence, which is defined as -2(sum from i = 1 to n, of log(qi)). Where i indicates each observation, and qi is the model-determined-likelihood of that observation.

Deviance is based on a model based on uncertain parameters, therefore it too has a posterior distribution.

#### From deviance to out-of-sample

Deviance and R-squared both produce more appealing values as model complexity grows, it's out-of-sample deviance and R-squared values that we can about. More generally, it doesn't matter how your model performs on the training data, so much as it matters how your model performs on new data.

There are very few guarantees in statistical modelling, these do not include that your training, cv, and test samples are representative of reality. Also, obviously, sample size matters.

Models that better represent the science are not gauranteed to produce better results, and, similarly, models that poorly represent the science are not gauranteed to produce worse results.

#### Regularization

Using a regularizing prior is one way to prevent overfitting, especially at small sample sizes. This requires using a much narrower prior distribution for the coefficients of predictors. The more narrow the prior, the worse it will fit the training data, but the more easily it'll generalize to new data. This narrowness sits to limit learning strong effects from the training data by making them less plausible from the start.

Deciding how narrow to make a reguarlizing prior can be difficult; it's helpful to have a 2nd, intermediate, set of new data to test the effects of different degrees of narrowness.

It becomes increasingly difficult to examine out-of-sample performance, however, when you have very little data.


