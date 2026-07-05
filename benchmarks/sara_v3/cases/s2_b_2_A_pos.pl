% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice and Bob were legally separated under a decree of separate maintenance on July 9th, 2014.

% Question
% Section 2(b)(2)(A) applies to Alice and Bob in 2018. Entailment

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
legal_separation_(span("separated",71,79)).
patient_(span("separated",71,79),span("married",18,24)).
agent_(span("separated",71,79),span("decree of separate maintenance",89,118)).
start_(span("separated",71,79),span(20140709,123,136)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).

% Test
:- s2_b_2_A("Alice","Bob",_,_,2018).
:- halt.
