% Text
% Charlie is Bob's father since April 15th, 1995. Dorothy is Bob's mother. Alice married Charlie on August 8th, 2018.

% Question
% Alice bears a relationship to Bob under section 152(d)(2)(C). Contradiction

% Facts
:- [statutes/prolog/init].
father_(span("father",17,22)).
mother_(span("mother",65,70)).
marriage_(span("married",79,85)).
agent_(span("father",17,22),span("Charlie",0,6)).
patient_(span("father",17,22),span("Bob",11,13)).
start_(span("father",17,22),span(19950415,30,45)).
agent_(span("married",79,85),span("Alice",73,77)).
agent_(span("married",79,85),span("Charlie",87,93)).
start_(span("married",79,85),span(20180808,98,113)).
start_(span("mother",65,70),span(19950415,30,45)).
agent_(span("mother",65,70),span("Dorothy",48,54)).
patient_(span("mother",65,70),span("Bob",59,61)).

% Test
:- \+ s152_d_2_C("Alice","Bob",_,_).
:- halt.
