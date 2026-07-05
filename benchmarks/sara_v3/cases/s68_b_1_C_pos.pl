% Text
% In 2016, Alice's income was $567192. Alice is not married, is not a surviving spouse, and is not a head of household in 2016.

% Question
% Section 68(b)(1)(C) applies to Alice in 2016 with the applicable amount equal to $250000. Entailment

% Facts
:- [statutes/prolog/init].
income_(span("income",17,22)).
start_(span("income",17,22),span(20160101,3,6)).
agent_(span("income",17,22),span("Alice",9,13)).
amount_(span("income",17,22),span(567192,29,34)).

% Test
:- s68_b_1_C("Alice",250000,2016).
:- halt.
