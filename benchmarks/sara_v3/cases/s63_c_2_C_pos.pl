% Text
% In 2017, Alice was paid $33200. Alice and Bob have been married since Feb 3rd, 2017. Alice and Bob file separate returns.

% Question
% Under section 63(c)(2)(C), Alice's basic standard deduction in 2017 is equal to $3000. Entailment

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
marriage_(span("married",56,62)).
agent_(span("married",56,62),span("Alice",32,36)).
agent_(span("married",56,62),span("Bob",42,44)).
start_(span("married",56,62),span(20170203,70,82)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).

% Test
:- s63_c_2_C(2017,3000).
:- halt.
