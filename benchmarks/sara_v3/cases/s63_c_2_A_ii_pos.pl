% Text
% In 2017, Alice was paid $33200. Alice is a surviving spouse for 2017.

% Question
% Section 63(c)(2)(A)(ii) applies to Alice in 2017. Entailment

% Facts
:- discontiguous s2_a/3.
:- [statutes/prolog/init].
s2_a("Alice",_,2017).
payment_(span("paid",19,22)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).
start_(span("paid",19,22),span(20170101,3,6)).

% Test
:- s63_c_2_A_ii("Alice",2017).
:- halt.
