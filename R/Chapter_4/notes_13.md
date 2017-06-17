## Notes from session #13
### Pages 94-102


#### Priors

The 3rd, 4th, and 5th lines of the model definition defines priors for Alpha, Beta, and sigma. To restate:

3. Alpha ~ Normal(178, 100)
4. *Beta ~ Normal(0, 10)*
5. sigma ~ Uniform(0, 50)

All of these priors are very weak. The Alpha prior is normal on 178 with standard deviation 100, because the intercept can vary largely from the mean value of the outcome; this allows it plenty of room to find the optimal one. The Beta prior is normal on 0 with standard deviation 10. 10 is very weak, and the mean 0 allows us to be conservative; 50% of the distribution is on either side of 0. *This prior will pull probability mass towards 0*. The smaller the standard deviation, the stronger the pull (which the prior is inducing) will be.

In reality, the prior centered on 0 is silly because we're pretty certain that it will be > 0; however, since there's so much data, it will not matter much. *Remember that you want a prior that incorporates accurate knowledge; it exists to nudge the model in the right direction and exclude the wrong directions*.

#### Fitting the model

Its important to note that everything that depends on a parameter, including itself, has a posterior distribution. So, mu no longer has a prior because it is defined deterministically. It is determined by the parameters alpha and beta, which do have priors. Alpha and beta will have posteriors, which will preclude mu's posterior. In other words, all though mu is deterministic, it will have uncertainty, so will predictions, measures of fit, etc...

#### Interpretting the model fit

In general, there are two ways to examine a posterior, via tables and plotting. Tables are helpful in simple situations but quickly become overwhelmed. Plotting is more broadly useful.

*Posterior probabilities of parameter values describe the relative compatibility of different states of the world with the data*.

#### Tables of estimates

Again, tables aren't good outside of simple situations.

**A good practice is to discuss results in relation to the model, rather than "truth" or reality.**

A trick to help strong correlations between variables is *centering*, subtracting the mean from each value.

#### Plotting posterior inference against the data

Plotting is a really good informal way of inspecting the posterior. Specifically, you should plot posterior inference against the data; if they match poorly, then either the model fit poorly or, more usually, is badly specified.

#### Adding uncertainty around the mean

The line given when plotted is the *most plausible line*, determined from the posterior distributions. That line gives little information about uncertainty. You can plot several lines, derived from sampling posterior distribution values, in order to view the model's uncertainty.


