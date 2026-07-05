% Text
% In 2016, Alice's income was $567192. Alice is a head of household for the year 2016.

% Question
% Under section 68(b)(1)(B), Alice's applicable amount for 2016 is equal to $275000. Entailment

% Facts
:- discontiguous s2_b/3.
:- [statutes/prolog/init].
s2_b("Alice",_,2016).
income_(span("income",17,22)).
agent_(span("income",17,22),span("Alice",9,13)).
amount_(span("income",17,22),span(567192,29,34)).
start_(span("income",17,22),span(20160101,3,6)).

% Test
:- s68_b_1_B("Alice",275000,2016).
:- halt.
