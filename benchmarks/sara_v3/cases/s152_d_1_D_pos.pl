% Text
% In 2015, Alice's income was $312. The exemption amount for Alice under section 151(d) for the year 2015 was $2000. Bob is Alice's father.

% Question
% Section 152(d)(1)(D) applies to Bob for the year 2015. Entailment

% Facts
:- discontiguous s151_d/4.
:- [statutes/prolog/init].
s151_d("Alice",_,2000,2015).
income_(span("income",17,22)).
father_(span("father",130,135)).
agent_(span("father",130,135),span("Bob",115,117)).
patient_(span("father",130,135),span("Alice",122,126)).
agent_(span("income",17,22),span("Alice",9,13)).
amount_(span("income",17,22),span(312,29,31)).
start_(span("income",17,22),span(20150101,3,6)).

% Test
:- s152_d_1_D("Bob",2015).
:- halt.
