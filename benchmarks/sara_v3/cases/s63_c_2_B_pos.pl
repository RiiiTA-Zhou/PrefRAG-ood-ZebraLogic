% Text
% In 2017, Alice was paid $33200. Alice is a head of household for 2017.

% Question
% Under section 63(c)(2)(B), Alice's basic standard deduction in 2017 is equal to $4400. Entailment

% Facts
:- discontiguous s2_b/3.
:- [statutes/prolog/init].
s2_b("Alice",_,2017).
payment_(span("paid",19,22)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).
start_(span("paid",19,22),span(20170101,3,6)).

% Test
:- s63_c_2_B("Alice",2017,4400).
:- halt.
