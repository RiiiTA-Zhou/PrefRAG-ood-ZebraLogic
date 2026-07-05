% Text
% In 2016, Alice's income was $567192. Alice is not married.

% Question
% Section 68(b)(1)(D) applies to Alice in 2016. Contradiction

% Facts
:- discontiguous s2_a/3.
:- [statutes/prolog/init].
s2_a("Alice",_,2016).
income_(span("income",17,22)).
start_(span("income",17,22),span(20160101,3,6)).
agent_(span("income",17,22),span("Alice",9,13)).
amount_(span("income",17,22),span(567192,29,34)).

% Test
:- \+ s68_b_1_D("Alice",150000,2016).
:- halt.
