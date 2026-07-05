% Text
% Alice and Bob got married on April 5th, 2012. Bob died September 16th, 2017.

% Question
% Section 7703(a)(1) applies to Alice for the year 2012. Entailment

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
death_(span("died",50,53)).
agent_(span("died",50,53),span("Bob",46,48)).
start_(span("died",50,53),span(20170916,55,74)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(20120405,29,43)).

% Test
:- s7703_a_1("Alice",_,_,_,2012).
:- halt.
