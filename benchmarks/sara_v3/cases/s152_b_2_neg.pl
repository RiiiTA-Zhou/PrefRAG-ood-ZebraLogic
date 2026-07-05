% Text
% Alice and Bob got married on Jan 1st, 2015. Alice and Bob file separately in 2015.

% Question
% Section 152(b)(2) applies to Alice for the year 2015. Contradiction

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(20150101,29,41)).

% Test
:- \+ s152_b_2("Alice",_,_,2015).
:- halt.
