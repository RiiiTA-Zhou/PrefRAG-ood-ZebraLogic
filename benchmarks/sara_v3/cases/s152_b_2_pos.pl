% Text
% Alice and Bob got married on Jan 1st, 2015. Alice and Bob file a joint return for the year 2015.

% Question
% Section 152(b)(2) applies to Alice for the year 2015. Entailment

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
joint_return_(span("joint return",65,76)).
agent_(span("joint return",65,76),span("Alice",44,48)).
agent_(span("joint return",65,76),span("Bob",54,56)).
start_(span("joint return",65,76),span(20150101,91,94)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(20150101,29,41)).

% Test
:- s152_b_2("Alice",_,_,2015).
:- halt.
