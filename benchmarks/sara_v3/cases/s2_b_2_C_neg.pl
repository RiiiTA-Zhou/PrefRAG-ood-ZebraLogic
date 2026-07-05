% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice was a nonresident alien. Alice died on July 9th, 2014.

% Question
% Section 2(b)(2)(C) applies to Bob in 2014. Contradiction

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
nonresident_alien_(span("nonresident alien",56,72)).
death_(span("died",81,84)).
agent_(span("died",81,84),span("Alice",75,79)).
start_(span("died",81,84),span(20140709,89,102)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).
agent_(span("nonresident alien",56,72),span("Alice",44,48)).

% Test
:- \+ s2_b_2_C("Bob",_,_,2014).
:- halt.
