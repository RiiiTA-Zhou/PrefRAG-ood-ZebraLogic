% Text
% In 2017, Alice was paid $33200. Alice and Bob have been married since Feb 3rd, 2017. Alice is entitled to an additional standard deduction of $600 each for herself and for Bob, under section 63(f)(1)(A) and 63(f)(1)(B), respectively.

% Question
% Under section 63(c)(3), Alice's additional standard deduction in 2017 is equal to $300. Contradiction

% Facts
:- discontiguous s63_f_1_B/3.
:- discontiguous s63_f_1_A/2.
:- [statutes/prolog/init].
s63_f_1_A("Alice",2017).
s63_f_1_B("Alice","Bob",2017).
payment_(span("paid",19,22)).
marriage_(span("married",56,62)).
agent_(span("married",56,62),span("Alice",32,36)).
agent_(span("married",56,62),span("Bob",42,44)).
start_(span("married",56,62),span(20170203,70,82)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).

% Test
:- \+ s63_c_3("Alice",300,2017).
:- halt.
