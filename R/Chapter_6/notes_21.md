## Notes from session 21
### Pages 188-191


#### Information criteria

*Akaike information criteria* (AIC) provides a simple way to estimate non-training-set deviance. Out-of-sample deviance will be approximately... (training set deviance) + 2(number of model parameters). This is reliable when:

1. The priors are flat or there is a sufficient data to make them irrelevent

2. The posterior is approximately a multivariate Gaussian

3. Sample size >> number of model parameters

Flat priors are hardly ever ideal, so we'll instead focus on two more common and general criteria

#### 1) *Deviance Information Criteria* (DIC)

This information makes assumptions 2 & 3 without making 1; that is, it allows informative priors.

DIC requires a multivariate Gaussian posterior, so any important parameter that is substantially skewed will mess it up.

Deviance is calculated from stochastic parameters, therefore deviance is stochastic and has a posterior distribution; so far we've only discussed it at MAP value.

To calculate DIC, first we take samples from the posterior and compute the deviance for each sample. DIC is then... (the average of those deviances) + ((the average of those deviances) - (the deviance computed using the mean of each parameter))

With flat priors, the difference is approximated to the number of parameters, and, therefore, DIC is approximated to AIC; AIC can be thought of as one general instance of DIC.