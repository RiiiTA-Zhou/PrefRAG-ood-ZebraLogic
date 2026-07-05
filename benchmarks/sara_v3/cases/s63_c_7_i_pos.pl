% Text
% In 2019, Alice was paid $33200. Alice is a head of household for 2019.

% Question
% Under section 63(c)(7)(i), Alice's basic standard deduction in 2019 is equal to $18000. Entailment

% Facts
:- discontiguous s2_b/3.
:- [statutes/prolog/init].
s2_b("Alice",_,2019).
payment_(span("paid",19,22)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).
start_(span("paid",19,22),span(20190101,3,6)).

% Test
:- s63_c_7_i(2019,18000).
:- halt.
