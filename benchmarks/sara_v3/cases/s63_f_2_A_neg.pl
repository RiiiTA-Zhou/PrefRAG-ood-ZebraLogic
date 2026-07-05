% Text
% In 2017, Alice was paid $33200. Alice and Bob have been married since Feb 3rd, 2017. Alice and Bob file separate returns in 2017. Alice has been blind since April 19, 2015.

% Question
% Section 63(f)(2)(A) applies to Bob in 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
marriage_(span("married",56,62)).
blindness_(span("blind",145,149)).
agent_(span("blind",145,149),span("Alice",130,134)).
start_(span("blind",145,149),span(20150419,157,170)).
agent_(span("married",56,62),span("Alice",32,36)).
agent_(span("married",56,62),span("Bob",42,44)).
start_(span("married",56,62),span(20170203,70,82)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).

% Test
:- \+ s63_f_2_A("Bob",2017).
:- halt.
