% Text
% In 2017, Alice was paid $33200. Alice and Bob have been married since Feb 3rd, 2017. Alice is entitled to a deduction for Bob under section 151(b). Bob had no gross income in 2017.

% Question
% Under section 63(c)(5), Bob's basic standard deduction in 2017 is equal to at most $500. Entailment

% Facts
:- discontiguous s151_b_applies/3.
:- [statutes/prolog/init].
s151_b_applies("Alice","Bob",2017).
payment_(span("paid",19,22)).
marriage_(span("married",56,62)).
agent_(span("married",56,62),span("Alice",32,36)).
agent_(span("married",56,62),span("Bob",42,44)).
start_(span("married",56,62),span(20170203,70,82)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).

% Test
:- s63_c_5("Bob",_,_,2017,500).
:- halt.
