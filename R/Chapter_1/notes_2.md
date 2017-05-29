## Notes from session #3
### Pages 13-17


##### Multilevel models

Turns out neural networks are multilevel models. A multilevel model is where you have a model of parameters which are the results of models. There are then multiple levels of uncertainty.

These types of models are also known as: hierarchical, random effects, varying effects, or mixed effects models. Additionally, they are becoming increasingly common.

An interesting result of these models is that they model variance explicitly due to be multilevel. They also allow for greater complexity and ease the difficulties introduced by repeated sampling of the same sample space; they are more prepared to expect variance from clusters (due to greater complexity). They provide a unique perspective and have a broad range of applications.

Their ability to expect variance makes them deserving to be the standard. "Papers that do not use multilevel models should have to justify not using (them)". Of course, however, this approach is more difficult.

##### Model comparison and information criteria

Information criteria are a family of metrics used to compare structurally different models. The comparisons are based on future predictive accuracy. Information criteria particularly help with two problems:

1. Overfitting. "Fitting is easy, predicting is hard. Future data will not be exactly like past data, and so any model that is unaware of this fact tends to make worse predictions than it could."

2. They allow for the comparison of multiple non-null models. This is valuable because we can see how well models do in comparison to reality and each other, rather than seeing if they can be falsified in one aspect or another. Model comparison > model falsification.


