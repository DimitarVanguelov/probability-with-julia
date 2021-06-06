### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ d27d1867-e6ba-4fb1-8370-96403b786e00
using PlutoUI

# ╔═╡ d4990464-c67f-11eb-3f27-37943df614a0
md"""
# A Concrete Introduction to Probability (using Julia)

###

*[Originally authored for Python by Peter Norvig](https://github.com/norvig/pytudes/blob/master/ipynb/Probability.ipynb)*

*Adapted for Julia by Dimitar Vanguelov*

...

In 1814, Pierre-Simon Laplace [wrote](https://en.wikipedia.org/wiki/Classical_definition_of_probability):

> Probability theory is nothing but common sense reduced to calculation. ... [Probability] is thus simply a fraction whose numerator is the number of favorable cases and whose denominator is the number of all the cases possible ... when nothing leads us to expect that any one of these cases should occur more than any other.
"""

# ╔═╡ ea332a56-733a-4285-98e8-97f972157570
html"""
<p align="center">
<img src="https://i.imgur.com/HWoOb2n.jpg">
</p>
"""

# ╔═╡ cf8a4c29-6bea-4e62-a27d-cde04582468d
md"""
Laplace nailed it. To untangle a probability problem, all you have to do is define exactly what the cases are, and careful count the favorable and total cases. Let's be clear on our vocabulary words:


* [Trial](https://en.wikipedia.org/wiki/Experiment_(probability_theory)): A single occurrence with an outcome that is uncertain until we observe it. *For example, rolling a single die.*

* [Outcome](https://en.wikipedia.org/wiki/Outcome_(probability)): A possible result of a trial; one particular state of the world. What Laplace calls a **case**. *For example: 4.*

* [Sample Space](https://en.wikipedia.org/wiki/Sample_space): The set of all possible outcomes for the trial. For example, {1, 2, 3, 4, 5, 6}.

* [Event](https://en.wikipedia.org/wiki/Event_(probability_theory)): A subset of outcomes that together have some property we are interested in. *For example, the event "even die roll" is the set of outcomes {2, 4, 6}.*

* [Probability](https://en.wikipedia.org/wiki/Probability_theory): As Laplace said, the probability of an event with respect to a sample space is the "number of favorable cases" (outcomes from the sample space that are in the event) divided by the "number of all the cases" in the sample space (assuming "nothing leads us to expect that any one of these cases should occur more than any other"). Since this is a proper fraction, probability will always be a number between 0 (representing an impossible event) and 1 (representing a certain event). *For example, the probability of an even die roll is 3/6 = 1/2.*

This notebook will explore these concepts in a concrete way using Python code. The code is meant to be succint and explicit, and fast enough to handle sample spaces with millions of outcomes. If you need to handle trillions, you'll want a more efficient implementation. Peter Norvig also has [another notebook](https://nbviewer.jupyter.org/url/norvig.com/ipython/ProbabilityParadox.ipynb) that covers paradoxes in Probability Theory.
"""

# ╔═╡ eabf6a27-4878-422f-a5e0-dbcb2762e0aa
md"""
## P is for Probability
The code below implements Laplace's quote directly: *Probability is thus simply a fraction whose numerator is the number of favorable cases and whose denominator is the number of all the cases possible.*
"""

# ╔═╡ 6e3b2736-9d20-49e2-9dcd-8662c9e2aa62
"""
The probability of an event, given a sample space.
"""
function P(event::Set, space::Set)
	
	# favoriable = outcomes that are in the event and in the sample space
	favorable = intersect(event, space)
	
	# the number of cases is the length, or size, of a set
	num = length(favorable)
	den = length(space)
	
	# this returns the result as a Rational
	return num // den 
end

# ╔═╡ 3e3d0221-8fcc-4f03-9de8-b9943d54c89e
md"""*Read more about Rational numbers in Julia [here](https://docs.julialang.org/en/v1/manual/complex-and-rational-numbers/#Rational-Numbers)*"""

# ╔═╡ e58c8e1f-6c9b-48b1-8912-6e11a5e28688


# ╔═╡ 06a5b841-edfb-400f-9bc8-d6a36433a1ba
html"""<style>
main {
    max-width: 1000px;
}
"""

# ╔═╡ Cell order:
# ╟─d4990464-c67f-11eb-3f27-37943df614a0
# ╟─ea332a56-733a-4285-98e8-97f972157570
# ╟─cf8a4c29-6bea-4e62-a27d-cde04582468d
# ╟─eabf6a27-4878-422f-a5e0-dbcb2762e0aa
# ╠═6e3b2736-9d20-49e2-9dcd-8662c9e2aa62
# ╟─3e3d0221-8fcc-4f03-9de8-b9943d54c89e
# ╠═e58c8e1f-6c9b-48b1-8912-6e11a5e28688
# ╟─d27d1867-e6ba-4fb1-8370-96403b786e00
# ╟─06a5b841-edfb-400f-9bc8-d6a36433a1ba
