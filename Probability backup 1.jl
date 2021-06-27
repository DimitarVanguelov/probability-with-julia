### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ d75b95a1-0db0-4e04-9dd7-2a30dccbe633
using Combinatorics

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
P(union(even, prime), D)

# ╔═╡ a696d091-a0bf-4282-9d9a-72e13abb5908
P(intersect(odd, prime), D)

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

# ╔═╡ a3381527-72b8-4640-a13f-db3358bf8172
md"Note that each card in `deck` is a *tuple* consisting of a rank and suit. We deviate from the Python version here since working with tuples is faster in Julia than with strings."

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
Hands = combos(deck, 5)

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


# ╔═╡ 56ac4f28-1568-4c69-8a6f-5a9001e92274


# ╔═╡ 23b6d8da-56bf-4cd4-9ba5-f515d2a09204
md"""Or the probability of four of a kind:"""

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
html"""<style>
main {
    max-width: 1000px;
}
"""

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
# ╟─a3381527-72b8-4640-a13f-db3358bf8172
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
# ╠═cd0574cd-84bf-4dbe-9236-e7756bc85fe2
# ╠═56ac4f28-1568-4c69-8a6f-5a9001e92274
# ╟─23b6d8da-56bf-4cd4-9ba5-f515d2a09204
# ╟─d27d1867-e6ba-4fb1-8370-96403b786e00
# ╟─7316770c-f7da-47b5-b3d0-b7873c3eafa4
# ╟─06a5b841-edfb-400f-9bc8-d6a36433a1ba
# ╟─426e59da-f826-4102-83e4-f8bd99fd8665
