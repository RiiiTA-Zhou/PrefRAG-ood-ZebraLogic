% Text
% In 2016, Alice's income was $567192. Alice is a head of household for the year 2016.

% Question
% Section 68(b)(1)(C) applies to Alice in 2016. Contradiction

% Facts
:- discontiguous s2_b/3.
:- [statutes/prolog/init].
s2_b("Alice",_,2016).
income_(span("income",17,22)).
agent_(span("income",17,22),span("Alice",9,13)).
amount_(span("income",17,22),span(567192,29,34)).
start_(span("income",17,22),span(20160101,3,6)).

% Test
:- \+ s68_b_1_C("Alice",_,2016).
:- halt.
