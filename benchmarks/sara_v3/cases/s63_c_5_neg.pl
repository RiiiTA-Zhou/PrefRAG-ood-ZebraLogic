% Text
% In 2017, Alice was paid $33200. Alice and Bob have been married since Feb 3rd, 2017. Bob earned $10 in 2017. Alice and Bob file separate returns. Alice is not entitled to a deduction for Bob under section 151.

% Question
% Section 63(c)(5) applies to Bob's basic standard deduction in 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
marriage_(span("married",56,62)).
payment_(span("earned",89,94)).
agent_(span("married",56,62),span("Alice",32,36)).
agent_(span("married",56,62),span("Bob",42,44)).
start_(span("married",56,62),span(20170203,70,82)).
patient_(span("earned",89,94),span("Bob",85,87)).
amount_(span("earned",89,94),span(10,97,98)).
start_(span("earned",89,94),span(20170101,103,106)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).

% Test
:- \+ s63_c_5("Bob",_,_,2017,_).
:- halt.
