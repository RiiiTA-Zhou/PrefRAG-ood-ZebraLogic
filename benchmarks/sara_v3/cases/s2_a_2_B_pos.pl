% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice died on July 9th, 2014.

% Question
% Section 2(a)(2)(B) applies to Bob in 2014. Entailment

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
death_(span("died",50,53)).
agent_(span("died",50,53),span("Alice",44,48)).
start_(span("died",50,53),span(20140709,58,71)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).

% Test
:- s2_a_2_B("Bob",_,2014).
:- halt.
