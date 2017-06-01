## Notes from session #3
### Pages 19-


#### Intro

Every model is a 'small world' trying to emulate the 'large/real world'. A model is not reality, and if we fail to recognize this distinction, we may believe that we've arrived in India, when, in reality, we're in the Bahamas.

Small worlds are self-contained and logical, there are no 'pure' surprises - everything should follow from the framework and parameters. There may be events in the large world that were not imagined when creating the small world. The small world is always incomplete, and so it will make mistakes, maybe even ones it 'shouldn't' have.

Bayesian analysis is not fast nor is it cheap; it can be more complicated and a waste of time if the situation is simple or routine enough. When you can do Bayesian analysis, it is not always the only thing or the best thing to do.

#### The garden of forking data

A key idea in Bayesian inference is "in order to make good inference about what actually happened, it helps to consider everything that could have happened." You then prune the alternatives paths (see conditional probability), and what remains is logically consistant.

Suppose there's a bag with 4 marbles that can be either white or blue, we don't know yet. You draw 4 marbles while replacing the one you previously drew. Assume after drawing 3, you have (blue, white, blue). We know the bag has to consist of 4 white marbles, 4 blue marbles, 1 white & 3 blue, 2 white & 2 blue, or 3 white & 1 blue.

The respective number of ways to get (blue, white, blue) from those options is 0, 0, 9, 8, and 3. By comparing these we have a method to determine the plausiblity of each bag composition.

We know have prior information about the plausibilities of each bag composition. Prior information can arise in different ways, such as knowledge of how the data were generated/gathered or previous data.

Suppose now you draw the 4th marble and get blue. You could redo the whole process of determining plausibility (the whole forking diagrams again), or you could update the previous plausibilities in light of the new observation. As long as the new observation is independent of the previous ones, both approaches are logically identical.

So, now the number of ways to get (blue, white, blue) from the options is 0, 0, 27, 16, and 3. This stems from the fact that there are 'A' ways to get the prior data 'M', and 'B' ways to get the new data 'N'; then, the ways to account for both are 'A*B'.

The prior data and the new data do not have to be 'of the same type'. Above, they are both counts of marbles, but they can be relative proportions of each bag combination; that is, for every (blue, blue, blue, white) bag there are 2 (blue, blue, white, white) and 3 (blue, white, white, white). Also, there is always more than 1 color. If we update our current data with this new data, you get the new plausibility counts of 0, 0, 27, 32, and 9.

Is there a way to determine when a plausibility is sufficiently larger than the others? Stay tuned.

What if you have no prior information? "The principle of indifference: When there is no reason to say that one conjecture is more plausible than another, weigh all of the conjectures equally." When you do this during Bayesian inference you approach non-Bayesian inference. It is also not always easy to justify ignorance.

The plausibility of a conjecture after given new data is proportional to the ways that the conjecture can produce the new data times the prior plausibility of the conjecture.

We need a better way to deal with plausibilities because counts are arbitrary, need a way to standardize them. We standardize them by making them a probability; that is, the sum of them will be 1, and they will be nonnegative.

As for the mathematical vocabulary:

1. The conjectured proportion, p, of blue marbles is a parameter value.

2. The relative number of ways that p can produce the data is a likelihood.

3. The prior plausibility of any p is the prior probability.

4. The updated plausibility of any p, in light of new data, is the posterior probability.



