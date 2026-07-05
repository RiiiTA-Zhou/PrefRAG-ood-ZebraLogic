% Text
% In 2017, Alice was paid $33200. Alice and Bob have been married since Feb 3rd, 2017. Alice has been blind since October 4, 2013. In addition, Alice is allowed an exemption for Bob under section 151(b) for the year 2017.

% Question
% Section 63(f)(2)(B) applies to Alice in 2017 with Bob as the spouse. Contradiction

% Facts
:- discontiguous s151_b_applies/3.
:- [statutes/prolog/init].
s151_b_applies("Alice","Bob",2017).
payment_(span("paid",19,22)).
marriage_(span("married",56,62)).
blindness_(span("blind",100,104)).
agent_(span("blind",100,104),span("Alice",85,89)).
start_(span("blind",100,104),span(20131004,112,126)).
agent_(span("married",56,62),span("Alice",32,36)).
agent_(span("married",56,62),span("Bob",42,44)).
start_(span("married",56,62),span(20170203,70,82)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).

% Test
:- \+ s63_f_2_B("Alice","Bob",2017).
:- halt.
