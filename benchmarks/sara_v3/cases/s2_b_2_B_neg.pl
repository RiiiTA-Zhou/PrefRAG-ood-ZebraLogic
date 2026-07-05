% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice was a nonresident alien until July 9th, 2014.

% Question
% Section 2(b)(2)(B) applies to Bob in 2015. Contradiction

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
nonresident_alien_(span("nonresident alien",56,72)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).
agent_(span("nonresident alien",56,72),span("Alice",44,48)).
end_(span("nonresident alien",56,72),span(20140709,80,93)).

% Test
:- \+ s2_b_2_B("Bob",_,2015).
:- halt.
