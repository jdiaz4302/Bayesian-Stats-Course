## Notes from session #9
### Pages 71-76


#### Linear Models

Ptolemy is often mocked for being accredited with the geocentric model of the Earth, but the model was actually very accurate in determining astronomical paths, such as those of the sun and other planets - it would however be very bad at predicting space travel time and distance. His model was an epiepicycle, circles (body of interest) on circles ('incorrect' orbit) on circles (Earth).

It turns out that the geocentric epicycle model is actually the result of a generalized system of approximation, *Fourier series*, which decompose periodic functions, such as a planetary orbit, into a series of sine and cosine functions.

So, no matter the true arrangement and movement of planets, you can build a geocentric model that accurately describes their paths against the night sky, just as Ptolemy did.

*Linear regression* is the geocentric model of statistics. It can be used to describe to a massive variety different process models by attempting to learn about the mean and variance of some measurement, using the additive combination of other measurements of interest.

This chapter introduces linear regression as a Bayesian procedure. Under this probability interpretation, linear regression uses a Gaussian/normal distribution to decribe our uncertainty about the measurement of interest. Linear regression is simple and foundational; the knowledge it provides also allows us to easily transition into non-normal regressions.

#### Why normal distributions are normal

Let's say 1000 people line up in the middle of a field. Each person tosses a coin 16 times, heads = move left and tails = move right. We don't know who will end up where, but we can say with strong confidence that the distribution of placements will be approximately normal; because the underlying binomial process will approach normal.

#### Normal by addition

This can be proven through simulation with R. 

**Any process that add together random values from the same distribution converges to a normal distribution* - binomial adds together Bernoulli. It doesn't matter what the underlying distribution is, the covergence might be slow, but it will be inevitable.

#### Normal by multiplication

Suppose there are several variables interacting with each other. This means that their effects multiply, rather than add.

When this occurs you can also converge to a normal distribution (particularly when effects are small), because multiplication is shorthand for addition. This works better when effects are small because deviations more easily compensate for opposite deviations.

#### Normal by log-multiplication

Large deviates that are multiplied together don't produce Gaussian distributions, **but** they do tend to produce Gaussian distributions on the log scale. This is because the log scale views counting differently, from 1 to 2 is a scale of e (or 10), rather than an addition of 1; this views the multiplication as a form of addition, and we've seen that addition tends towards Gaussian.

#### Using Guassian distributions

There are two justifications for this course's continued emphasis on the Gaussian distribution.

1. Ontological justification

*Gaussian distributions exist everywhere as approximations, from measurements errors to variations in growth to velocities of molecules. This is so because because at their heart, these processes add together random fluctuations, which when summed, shed all information about the underlying process aside from mean and variation*.

This is good and bad. This is why models based on Gaussian distributions cannot reliably identify micro-processes; they cannot distinguish between two hypotheses that yield similar quantitative expectations.

*The Gaussian distribution is member of the family of fundamental natural distributions known as the 'Exponential Family', which are universally abundant and important for working science; others include the exponential, gamma, and Poisson distributions.*

2. Epistemological justification

Another reason is because the Gaussian distribution represents a particular state of ignorance - one of assuming we only know the mean and the variance. If we are only comfortable saying that we know the mean and variance, then the Gaussian distribution is most consistant with our assumptions. It represents an advantage in that it assumes very little more than those two things; it is the assumption that will yield least surprises and information. If you're confident saying more, then you likely shouldn't use the Gaussian.

#### Gaussian Distribution

Bayesian analysis tends to use a different-looking PDF for the normal distribution, but it is equivalent.

In the Gaussian distribution, the main part that gives it the "bell shape" is the (y - mean(y))^2; everything else just sums the integral to 1.


