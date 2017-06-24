## Notes from session #17
### Pages 135-153


#### Masked Relationships

We've seen that using multiple predictors is useful for knocking out spurious associations. They're also useful to measure the direct influences of multiple predictors when none of those influences are obviously apparent.

Using the log measure of a predictor is completely acceptable and is essentially saying, "I expect that the *magnitude* of this predictor is related to the outcome."

Predicting the energy content of primate milk only with neocortex percent or only with female body mass (log(female body mass)) did not tend to produce good models. When we used both variables together, however, the models were *much* improved. Why is this? This is because the two predictors are positively correlated, yet they have negating correlations with outcome. So, as female body mass increases, energy content goes down, *BUT* neocortex percent goes up, so energy content goes, which results in approximately net 0 change.

The above clearly displays an analytical advantage of multivariable regression - you see the effect of one variable while the others constant; if we were not able to do this, we would think both female body mass and neocortex percent have no relation to energy content of primate milk.

The more strongly correlated two predictors are, the harder it is see masked relationships; if correlations are 1 or -1, it become impossible to tease out the associations. There may even be more variables involved that you haven't considered though.

#### When adding variables hurts

#### Multicollinear legs

Multicollinearity is a very strong association between 2 or more predictors; what this then entails is that all the predictors that are multicollinear provide the same information.

Instead of having:

1. `mu = a + b1(x1) + b2(x2)`

You actually have:

2. `mu = a + (b1 + b2)x`

And rather than working as it usually does, the model instead finds the infinitely many combinations of b1 and b2 that sum to create the effect of the association between x (the real information being conveyed by all the multicollinear variables) and the outcome.

In conclusion, it's best not to include multiple variables that are multicollinear; strange questions lead to strange answers.

#### Multicollinear milk

Multicollinear variables aren't always redudant, sometimes they do actually provide unique information. The main thing you can do about multicollinearity is be aware of it, and to be aware of the possibility that it may blow up the standard deviation of your posterior when you include the correlated predictors in the same model.

Computational "voodoo"s that can solve the problem of multicollinearity include PCA and factor analysis, however not all people approve of these. It's also popular to show that a model using only 1 of the correlated variables produces approximately the same results as using a model with all of them.

It's also important to note that wide PI/HPDI's on a parameter do not necessarily mean multicollinear problems; the data could also be a poor representation of some other variable - you didn't get a good range of measurements on height, for example. so the model can be certain in its coefficient.

#### Post-treatment bias

Often people worry about the effect of excluding important predictors, however the last few sections have shown that you should worry about including predictors too. Another good reason to worry about inclusion is *post-treatment bias*; this specifically applies to treatment studies. It is the result of you measuring something your treatment is intended to influence.

If you want to see survival rate of patients that use a cancer medicine, only include the treatment. If the medicine reduces tumor amount or size, don't include that, because that is post-treatment bias and will reduce the reported impact of the treatment because knowing treatment will be redudant after knowing what the treatment brings about.

#### Categorical Variables

Everybody knows you can include categories into statistical models, whether the categories be sex, region, stage, etc... Most people don't know how this is done though, and understanding how removes difficulties in interpretation.


