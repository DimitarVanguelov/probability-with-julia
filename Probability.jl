### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ d75b95a1-0db0-4e04-9dd7-2a30dccbe633
using Combinatorics

# ╔═╡ cbba1623-087c-45ca-8e60-872d662a94c1
using StatsBase

# ╔═╡ d27d1867-e6ba-4fb1-8370-96403b786e00
using PlutoUI

# ╔═╡ d4990464-c67f-11eb-3f27-37943df614a0
md"""
# A Concrete Introduction to Probability (using Julia)

### Translator's Note

*This lesson was originally [authored by Peter Norvig for the Python programming language](https://github.com/norvig/pytudes/blob/master/ipynb/Probability.ipynb). While this notebook aims to recreate that lesson as faithfully as possible, in content and in spirit -- a lot of the text is almost verbatim one-to-one with the original as written by Dr. Norvig -- certain liberties need to be taken when translating code from one language to another. The two languages are syntactically similar enough, yet certain concepts don't translate neatly from one to the other. In any case, I hope you enjoy reading (and interacting!) with this notebook for I find probability, Pluto, and Julia all quite beautiful.*

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

This notebook will explore these concepts in a concrete way using Julia code. The code is meant to be succint and explicit, and fast enough to handle sample spaces with millions of outcomes. If you need to handle trillions, you'll want a more efficient implementation. Peter Norvig also has [another notebook](https://nbviewer.jupyter.org/url/norvig.com/ipython/ProbabilityParadox.ipynb) that covers paradoxes in Probability Theory.
"""

# ╔═╡ eabf6a27-4878-422f-a5e0-dbcb2762e0aa
md"""
## P is for Probability
The code below implements Laplace's quote directly:
> Probability is thus simply a **fraction** whose numerator is the **number of favorable cases** and whose denominator is the **number of all the cases possible**.
"""

# ╔═╡ 6e3b2736-9d20-49e2-9dcd-8662c9e2aa62
"""
The probability of an event, given a sample space.
"""
function P(event::Set, space::Set)
	
	# favorable = outcomes that are in the event and in the sample space
	favorable = intersect(event, space)
	
	# the number of cases is the length, or size, of a set
	num = length(favorable)
	den = length(space)
	
	# this returns the result as a Rational
	return num // den 
end;

# ╔═╡ e58c8e1f-6c9b-48b1-8912-6e11a5e28688
md"""
## Warm-up Problem: Die Roll

What's the probability of rolling an even number with a single six-sided fair die? Mathematicians traditionally use a single capital letter to denote a sample space; we'll use `D` for the die:
"""

# ╔═╡ 66d84a3e-2270-4370-b721-f0ce727f2069
D = Set([1, 2, 3, 4, 5, 6]);

# ╔═╡ d46d3555-db5e-4463-b960-1523f17d69b6
even = Set([2, 4, 6]);

# ╔═╡ 34215c3a-c740-4fb8-8c4c-2b09a0db17ee
P(even, D)

# ╔═╡ f030c7d6-40e2-4884-9af3-5c23e4906647
md"""
Good to confirm what we already knew. We can explore some other events:
"""

# ╔═╡ 876558b2-689f-4f68-bed4-46acb12cb9b2
prime = Set([2, 3, 5, 7, 11, 13]);

# ╔═╡ b084aa98-a3a0-4718-a1a4-711a2b193884
odd = Set([1, 3, 5, 7, 9, 11, 13]);

# ╔═╡ 0e0af04e-1c08-4571-b984-93be3250b373
P(odd, D)

# ╔═╡ 042b17b9-8a90-499e-afb6-e890db322e0b
P(even ∪ prime, D)

# ╔═╡ a696d091-a0bf-4282-9d9a-72e13abb5908
P(odd ∩ prime, D)

# ╔═╡ ccd786ef-d3a8-4eef-bc54-905b54ee8922
md"""
## Card Problems

Consider dealing a hand of five playing cards. An individual card has a rank and suit, like **J♥** for the Jack of Hearts, and a deck has 52 cards:
"""

# ╔═╡ 9179759a-5c1e-403d-a8b9-3a2235702bda
suits = "♥♠♦♣";

# ╔═╡ 047c5adc-c89c-4949-bc44-43f4aecf0658
ranks = "AKQJT98765432";

# ╔═╡ e40381c6-761e-4f8c-8b20-d9a2ed2516a2
deck = [(r*s) for r in ranks, s in suits]

# ╔═╡ 8c6b90ba-ceb7-4ca9-a05d-c67eb588f5a9
length(deck)

# ╔═╡ 9eeb67a8-a165-441d-93fc-f2668234bd2d
md"""
Now we want to define `Hands` as the sample space of all 5-card combinations from deck. The function `combinations` from the `Combinatorics.jl` package does most of the work; we than group each combination into a vector (1d array) of card tuples:
"""

# ╔═╡ 324d8993-eb02-4cbc-aef7-10a07ed3b848
function combos(items, n)
	c = combinations(items, n)
	return Set(join.(c, " "))
end;

# ╔═╡ 1053da15-abf0-45bd-9781-7eb3bd69f77c
Hands = combos(deck, 5);

# ╔═╡ 417a886c-8ce1-44c3-87bf-23c8dec406f2
# number of possible hands
length(Hands)

# ╔═╡ 06ca0904-47fc-43d6-8d0b-dd22248a3ad2
# random sample of hands
rand(Hands, 7)

# ╔═╡ 8fbdcb18-857e-457a-a326-d8328ed8b9ae
# random sample of cards from the deck
rand(deck, 7)

# ╔═╡ 16d0d2dc-ebeb-4d87-b578-447324c466dd
md"Now we can answer questions like the probability of being dealt a flush (5 cards of the same suit):"


# ╔═╡ be7f0d81-8003-4c45-96b4-021ed1527c27
flush = Set(
	hand for hand in Hands if any(count(isequal(suit), hand) == 5 for suit in suits)
			);

# ╔═╡ 63335a6c-2a3f-4ea4-9e49-0be080bc4eaa
P(flush, Hands)

# ╔═╡ 23b6d8da-56bf-4cd4-9ba5-f515d2a09204
md"""Or the probability of four of a kind:"""

# ╔═╡ a82d511a-10ed-405c-9a23-f17cc0c2391b
four_kind = Set(
	hand for hand in Hands if any(count(isequal(rank), hand) == 4 for rank in ranks)
			);

# ╔═╡ d06c3149-12a8-499e-87f9-b221a921fe71
P(four_kind, Hands)

# ╔═╡ e0239202-5657-4dd8-abd8-dfb245c9bd79
md"""
## Urn Problems

Around 1700, Jacob Bernoulli wrote about removing colored balls from an urn in his landmark treatise [Ars Conjectandi](https://en.wikipedia.org/wiki/Ars_Conjectandi), and ever since then, explanations of probability have relied on [urn problems](https://www.google.com/search?q=probability+ball+urn). (You'd think the urns would be empty by now.)
"""

# ╔═╡ be3074be-20c2-4360-867c-4f958eab0cf9
html"""
<p align="center">
<img src="https://i.imgur.com/RdJssKy.jpg">
</p>
"""

# ╔═╡ 3b182b64-c9cb-4181-b53a-5fd77f790ab4
md"""
For example, here is a three-part problem adapted from mathforum.org:

> An urn contains 6 blue, 9 red, and 8 white balls. We select six balls at random. What is the probability of each of these outcomes: 
> - All balls are red.
> - 3 are blue, and 1 is red, and 2 are white, .
> - Exactly 4 balls are white.
We'll start by defining the contents of the urn. A set can't contain multiple objects that are equal to each other, so I'll call the blue balls 'B1' through 'B6', rather than trying to have 6 balls all called 'B':
"""

# ╔═╡ 4454686e-3c50-4df5-8a3b-1fefaa8f9ec3
"""A set of n colored balls of the given color."""
balls(color, n) = [color * string(i) for i in 1:n];

# ╔═╡ 909594f2-4561-4c0b-ab34-9ffecb37c1f2
urn = balls("B", 6) ∪ balls("R", 9) ∪ balls("W", 8);

# ╔═╡ 5c399883-8b83-4e33-b095-f6c1e9cf66b7
U6 = combos(urn, 6);

# ╔═╡ 9fcb33b3-20ea-449b-b499-b405b6387438
# random sample
rand(U6, 5)

# ╔═╡ 2defc7e6-e5b1-4623-bbfe-fa8034e2c884
md"""Define select such that `select("R", 6)` is the event of picking 6 red balls from the urn:"""

# ╔═╡ 89dc84b4-dbfb-49c2-aa99-d795ac8dea3e
"""The subset of the sample space with exactly `n` balls of given `color`."""
select(color, n, space=U6) = Set(s for s in space if count(color, s) == n);

# ╔═╡ 98979cfc-37e7-4faf-b5e7-e32079041827
P(select("R", 6), U6)

# ╔═╡ 87fc6af2-bef8-4c5b-aa9b-4ec2e2c46e7e
P(select("B", 3) ∩ select("R", 1) ∩ select("W", 2), U6)

# ╔═╡ e4f75f67-9b95-4d44-b1c0-21766b44f98b
P(select("W", 4), U6)

# ╔═╡ 7b02289b-3c9a-4dc4-9d0f-0fbc669505f1
md"""
### Urn problems via arithmetic

Let's verify these calculations using basic arithmetic, rather than exhaustive counting. First, how many ways can one choose 6 out of 9 red balls? It could be any of the 9 for the first ball, any of 8 remaining for the second, and so on down to any of the remaining 4 for the sixth and final ball. But we don't care about the order of the six balls, so divide that product by the number of permutations of 6 things, which is 6!, giving us 9 × 8 × 7 × 6 × 5 × 4 / 6! = 84. In general, the number of ways of choosing c out of n items is (n choose c) = n! / ((n - c)! × c!). We can translate that to code:
"""

# ╔═╡ 319741df-f342-4a2c-ae61-6aac666bebc5
choose(n, c) = factorial(n) ÷ (factorial(n - c) * factorial(c));

# ╔═╡ f6d3fcae-cd67-4020-a274-511f98d5b2e4
choose(9, 6)

# ╔═╡ 872d8851-3b4a-4918-a298-ff5131576296
md"""
Now we can verify the answers to the three problems. (Since P computes a ratio and choose computes a count, we multiply the left-hand-side by N, the length of the sample space, to make both sides be counts.)
"""

# ╔═╡ 650d376f-adf9-4183-81e8-d200a238b64f
N = length(U6)

# ╔═╡ dd3e62e8-2c16-47a8-b2c6-2dc4055a9a9b
N * P(select("R", 6), U6) == choose(9, 6)

# ╔═╡ 3d06951d-7352-4fc3-9ee8-089dadd613ba
N * P(select("B", 3) ∩ select("W", 2) ∩ select("R", 1), U6) == choose(6, 3) * choose(8, 2) * choose(9, 1)

# ╔═╡ 46723fe6-fb52-4393-bb52-cd132ea5f001
N * P(select("W", 4), U6) == choose(8, 4) * choose(6 + 9, 2) # (6 + 9 non-white balls)

# ╔═╡ cc3f3f5a-36fb-4a3c-9086-ec1998468f1e
md"""
We can solve all these problems just by counting; all you ever needed to know about probability problems you learned from Sesame Street:
"""

# ╔═╡ 1d079b25-46c4-47a1-916d-99be46cc383d
html"""
<p align="center">
<img src="https://i.imgur.com/BEcnDNP.gif">
</p>
"""

# ╔═╡ 1577a943-8c3a-4bf9-9b5b-47a872ee1565
md"""
## Non-Equiprobable Outcomes

So far, we have accepted Laplace's assumption that *nothing leads us to expect that any one of these cases should occur more than any other*. In real life, we often get outcomes that are not equiprobable--for example, a loaded die favors one side over the others. We will introduce three more vocabulary items:

* [Frequency](https://en.wikipedia.org/wiki/Frequency_(statistics)): a non-negative number describing how often an outcome occurs. Can be a count like 5, or a ratio like 1/6.

* [Distribution](https://mathworld.wolfram.com/StatisticalDistribution.html): A mapping from outcome to frequency of that outcome. We will allow sample spaces to be distributions.

* [Probability Distribution](https://en.wikipedia.org/wiki/Probability_distribution): A probability distribution is a distribution whose frequencies sum to 1.

We will implement distributions with `Dist = countmap` using the `countmap` function from `StatsBase`.

"""

# ╔═╡ 1cb5828b-2662-49b8-9d7d-17e2af592917
Dist = countmap;

# ╔═╡ d6809ead-6fe3-4dc4-97fc-b05f73c458a1
md"We can initialize a `Dist` in any of the following ways"

# ╔═╡ 84dd4fda-1168-4211-8ee8-4b246096ca38
# A set of equiprobably outcomes (e.g. die rolls)
Dist(D)

# ╔═╡ 8b8aad37-a05a-41c2-9db4-a338a3e38ac4
# A collection of outcomes, with repetition indicating frequency:
Dist("THHHTTHHT")

# ╔═╡ 3b0a1cfc-688a-40e4-9f71-229db43a630f
md"""
Now we will modify the code to handle distributions:

* Sample spaces and events can both be specified as either a `Set` or a `Dist`.
* The sample space can be a non-probability distribution like Dist(H=50, T=50); the results will be the same as if the sample space had been a true probability distribution like Dist(H=1/2, T=1/2).
* The function cases now sums the frequencies in a distribution (it previously counted the length).
* The function favorable now returns a Dist of favorable outcomes and their frequencies (not a set).
* I will redefine Fraction to use "/", not fractions.Fraction, because frequencies might be floats.
* P is unchanged.
"""

# ╔═╡ 7316770c-f7da-47b5-b3d0-b7873c3eafa4
note(text) = Markdown.MD(Markdown.Admonition("note", "Note", [text]));

# ╔═╡ 3e3d0221-8fcc-4f03-9de8-b9943d54c89e
note(md"*Read more about Rational numbers in Julia [here](https://docs.julialang.org/en/v1/manual/complex-and-rational-numbers/#Rational-Numbers)*")

# ╔═╡ fffddca0-bd3b-470c-ba59-7b50f6d6f6cb
note(md"""
*Read more about Sets in Julia [here](https://en.wikibooks.org/wiki/Introducing_Julia/Dictionaries_and_sets#Sets), and in general [here](https://en.wikipedia.org/wiki/Set_(mathematics)). And then there are [Julia Sets](https://en.wikipedia.org/wiki/Julia_set), but that's a different thing....*
""")

# ╔═╡ a4b79e42-87bc-4bb9-b990-517fd220d6cc
note(md"*As a way of learning about arrays in Julia, experiment a bit in the cell above -- see what happens if you change the comma to a `for` in the array comprehension, or see what happens when you execute `deck[:]`, or wrap it in `Set()`, etc.*")

# ╔═╡ 06a5b841-edfb-400f-9bc8-d6a36433a1ba
#= html"""<style>
main {
    max-width: 1000px;
}
""" =#

# ╔═╡ 426e59da-f826-4102-83e4-f8bd99fd8665
TableOfContents()

# ╔═╡ Cell order:
# ╟─d4990464-c67f-11eb-3f27-37943df614a0
# ╟─ea332a56-733a-4285-98e8-97f972157570
# ╟─cf8a4c29-6bea-4e62-a27d-cde04582468d
# ╟─eabf6a27-4878-422f-a5e0-dbcb2762e0aa
# ╠═6e3b2736-9d20-49e2-9dcd-8662c9e2aa62
# ╟─3e3d0221-8fcc-4f03-9de8-b9943d54c89e
# ╟─e58c8e1f-6c9b-48b1-8912-6e11a5e28688
# ╠═66d84a3e-2270-4370-b721-f0ce727f2069
# ╠═d46d3555-db5e-4463-b960-1523f17d69b6
# ╠═34215c3a-c740-4fb8-8c4c-2b09a0db17ee
# ╟─f030c7d6-40e2-4884-9af3-5c23e4906647
# ╠═876558b2-689f-4f68-bed4-46acb12cb9b2
# ╠═b084aa98-a3a0-4718-a1a4-711a2b193884
# ╠═0e0af04e-1c08-4571-b984-93be3250b373
# ╠═042b17b9-8a90-499e-afb6-e890db322e0b
# ╠═a696d091-a0bf-4282-9d9a-72e13abb5908
# ╟─fffddca0-bd3b-470c-ba59-7b50f6d6f6cb
# ╟─ccd786ef-d3a8-4eef-bc54-905b54ee8922
# ╠═9179759a-5c1e-403d-a8b9-3a2235702bda
# ╠═047c5adc-c89c-4949-bc44-43f4aecf0658
# ╠═e40381c6-761e-4f8c-8b20-d9a2ed2516a2
# ╟─a4b79e42-87bc-4bb9-b990-517fd220d6cc
# ╠═8c6b90ba-ceb7-4ca9-a05d-c67eb588f5a9
# ╟─9eeb67a8-a165-441d-93fc-f2668234bd2d
# ╠═d75b95a1-0db0-4e04-9dd7-2a30dccbe633
# ╠═324d8993-eb02-4cbc-aef7-10a07ed3b848
# ╠═1053da15-abf0-45bd-9781-7eb3bd69f77c
# ╠═417a886c-8ce1-44c3-87bf-23c8dec406f2
# ╠═06ca0904-47fc-43d6-8d0b-dd22248a3ad2
# ╠═8fbdcb18-857e-457a-a326-d8328ed8b9ae
# ╟─16d0d2dc-ebeb-4d87-b578-447324c466dd
# ╠═be7f0d81-8003-4c45-96b4-021ed1527c27
# ╠═63335a6c-2a3f-4ea4-9e49-0be080bc4eaa
# ╟─23b6d8da-56bf-4cd4-9ba5-f515d2a09204
# ╠═a82d511a-10ed-405c-9a23-f17cc0c2391b
# ╠═d06c3149-12a8-499e-87f9-b221a921fe71
# ╟─e0239202-5657-4dd8-abd8-dfb245c9bd79
# ╟─be3074be-20c2-4360-867c-4f958eab0cf9
# ╟─3b182b64-c9cb-4181-b53a-5fd77f790ab4
# ╠═4454686e-3c50-4df5-8a3b-1fefaa8f9ec3
# ╠═909594f2-4561-4c0b-ab34-9ffecb37c1f2
# ╠═5c399883-8b83-4e33-b095-f6c1e9cf66b7
# ╠═9fcb33b3-20ea-449b-b499-b405b6387438
# ╟─2defc7e6-e5b1-4623-bbfe-fa8034e2c884
# ╠═89dc84b4-dbfb-49c2-aa99-d795ac8dea3e
# ╠═98979cfc-37e7-4faf-b5e7-e32079041827
# ╠═87fc6af2-bef8-4c5b-aa9b-4ec2e2c46e7e
# ╠═e4f75f67-9b95-4d44-b1c0-21766b44f98b
# ╟─7b02289b-3c9a-4dc4-9d0f-0fbc669505f1
# ╠═319741df-f342-4a2c-ae61-6aac666bebc5
# ╠═f6d3fcae-cd67-4020-a274-511f98d5b2e4
# ╟─872d8851-3b4a-4918-a298-ff5131576296
# ╠═650d376f-adf9-4183-81e8-d200a238b64f
# ╠═dd3e62e8-2c16-47a8-b2c6-2dc4055a9a9b
# ╠═3d06951d-7352-4fc3-9ee8-089dadd613ba
# ╠═46723fe6-fb52-4393-bb52-cd132ea5f001
# ╟─cc3f3f5a-36fb-4a3c-9086-ec1998468f1e
# ╟─1d079b25-46c4-47a1-916d-99be46cc383d
# ╟─1577a943-8c3a-4bf9-9b5b-47a872ee1565
# ╠═cbba1623-087c-45ca-8e60-872d662a94c1
# ╠═1cb5828b-2662-49b8-9d7d-17e2af592917
# ╟─d6809ead-6fe3-4dc4-97fc-b05f73c458a1
# ╠═84dd4fda-1168-4211-8ee8-4b246096ca38
# ╠═8b8aad37-a05a-41c2-9db4-a338a3e38ac4
# ╠═3b0a1cfc-688a-40e4-9f71-229db43a630f
# ╟─d27d1867-e6ba-4fb1-8370-96403b786e00
# ╟─7316770c-f7da-47b5-b3d0-b7873c3eafa4
# ╟─06a5b841-edfb-400f-9bc8-d6a36433a1ba
# ╠═426e59da-f826-4102-83e4-f8bd99fd8665
