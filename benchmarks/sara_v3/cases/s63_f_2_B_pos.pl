% Text
% In 2017, Alice was paid $33200. Alice and Bob have been married since Feb 3rd, 2017. Alice has been blind since Feb 28, 2014. In addition, Bob is allowed an exemption for Alice under section 151(b) for the year 2017.

% Question
% Section 63(f)(2)(B) applies to Bob in 2017 with Alice as the spouse. Entailment

% Facts
:- discontiguous s151_b_applies/3.
:- [statutes/prolog/init].
s151_b_applies("Bob","Alice",2017).
payment_(span("paid",19,22)).
marriage_(span("married",56,62)).
blindness_(span("blind",100,104)).
agent_(span("blind",100,104),span("Alice",85,89)).
start_(span("blind",100,104),span(20140228,112,123)).
agent_(span("married",56,62),span("Alice",32,36)).
agent_(span("married",56,62),span("Bob",42,44)).
start_(span("married",56,62),span(20170203,70,82)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).

% Test
:- s63_f_2_B("Bob","Alice",2017).
:- halt.
