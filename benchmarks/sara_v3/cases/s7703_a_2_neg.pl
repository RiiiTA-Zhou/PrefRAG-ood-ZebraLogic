% Text
% Alice and Bob got married on April 5th, 2012. Alice and Bob were legally separated under a decree of divorce on September 16th, 2017.

% Question
% Section 7703(a)(2) applies to Alice for the year 2012. Contradiction

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
legal_separation_(span("separated",73,81)).
patient_(span("separated",73,81),span("married",18,24)).
agent_(span("separated",73,81),span("decree of divorce",91,107)).
start_(span("separated",73,81),span(20170916,112,131)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(20120405,29,43)).

% Test
:- \+ s7703_a_2("Alice",_,_,_,2012).
:- halt.
