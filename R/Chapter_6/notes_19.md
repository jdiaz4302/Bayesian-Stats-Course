## Notes from session 19
### Pages 165-177


#### Overfitting, Regularization, and Information Criteria

Copernicus' heliocentric model of the solar system is often praised as a win for science over ideology and superstition, however his model wasn't correct either, it was still an epicycle - used circles, not ellipses. The new heliocentric model was still a Fourier series, a means of approximating periodic functions, but it made less assumptions - therefore it was more "harmonious". 

Often *when two models produce the same results, the model with less assumptions is preferred* - Ockham's Razor.

But models usually differ in accuracy and complexity, so we often must examine a trade-off between accuracy and simplicity.

*Overfitting* yields poor predictions by learning too much from the data, and *underfitting* yields poor predictions by learning too little from the data.

A *regularizing prior* or *penalized likelihood* is a way to avoid overfitting.

*Information criteria* are methods of scoring a model with a particular purpose in mind.

Regularization and information criteria are both important and both regularly used.

*Stargazing* is mock-name for selecting models based solely off finding a lot of statistically significant coefficients, which are designated with stars (asterisks) in R. Don't do this; it's not good for structurally different models and statistical significance does not prove or disprove a variable's usefulness in prediction.

*A beauty of statistics is that procedures and formulas can be derived from varying, often incompatible perspectives.*

#### The problem with parameters

R-squared or "variance explained" is computed as 1 - ((var(residuals)) / var(outcome)); with this being so simple, it is often used to measure a model's fit. BUT it almost always goes up with more predictors.

Complex models are more prone to overfitting, and simple models are more prone to underfitting.

#### More parameters always improves fit

A model has regular and irregular features, *regular features* are the features that generalize well when predicting, and *irregular features* do not, so they may mislead predictions.

A model with enough parameters can assign each outcome observation its own observation, this is how exact overfitting occurs.

**Model fitting can be though of as "DATA COMPRESSION"; that is, you compress the outcome variables into parameters that map predictors to the outcomes. This compresses the information to a simpler form, with some loss. You can decompress the information by producing outcomes from the parameters and predictors. So, when you have the same amount of outcome observations and parameters, there is no compression and therefore no information loss. You are simply encoding the raw outcomes in a new form.**

#### Too few parameters hurts too

Overfit models describe the training data really well, but do not perform well on new data. Underfit models perform poorly on both new data AND the training data.

Another way to look at this is that underfit models are very insensitive to the training data, while overfit models are highly sensitive. If you removed any point, the underfit model would barely change while the overfit model could dramatically change.

The phrase "overfitting" is often replaced with "variance" and "underfiting" with "bias".

#### Firing the weatherperson

There should always be a target that you want your model to do well at. When defining a target, there are two major dimensions to worry about:

1. *Cost-benefit analysis*. How much does it cost when we're wrong? How much do we win when we're right?

2. *Accuracy in context*. We need to judge "accuracy" in a way that accounts for how much a model could improve prediction.

To see why it's important to think about these, consider the following:

Current weatherperson predicts that it will rain 100% for the next 3 days, and that it will rain 60% for the subsequent 7. In reality, it rains the first 3 days, and doesn't the subsequent 7. A newcomer claims they can do better; they predict that it will never rain.

Well, the first person's accuracy can be computed as 1.0(3) + (0.4)(7). Where 3 are the rain days, where he was 100% right, and 7 are the sunny days, where he was 40% right. Meanwhile, the new person's accuracy would be 0(3) + 1(7). Therefore, the new guy "predicted better".

Clearly there's something wrong with that; that's just accuracy.

#### Costs and benefits

Let's say you loss 5 points of happiness if you unexpectedly get wet, but you also lose 1 point of hapiness if you carry an umbrella. Suppose your chance of carry an umbrella is equal to the chance of rain. Now, maximize happiness.

Now the earlier scores are -1(3) + -0.6(7) and -5(3) + 0(7); that's -7.2 compared to -15. The current weatherperson wins this way.

#### Measuring accuracy

Defining accuracy is not clear cut either. For example, you could measure the accuracy of the getting the sequence of days right, rather than just each day independently. So, the (1^3)(0.4^7) is still better than (0^3)(1^7). This is similar to average probability (each day) versus joint probability (the sequence).

Some targets are harder to hit too; the more classifications, the less like you are to be correct. With continuous variables, it's literally impossible, by laws of probability, to ever be right about a particularly estimate, rather than a range. There should be a way to account for this.

There more ways there are to be wrong, the more ways there are to improve and be impressive.

#### What is a true model?

True probabilities aren't really a thing, probabilities come about from our model, which is a representation of our state of ignorance. If the model could acount for everything, there would be no probabilities; things would be deterministic. The only thing that causes probability is ignorance.


