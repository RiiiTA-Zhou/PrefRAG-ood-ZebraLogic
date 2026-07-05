% Text
% Charlie is Bob's father since April 15th, 2014. Alice married Charlie on October 12th, 1992.

% Question
% Alice bears a relationship to Bob under section 152(d)(2)(F). Contradiction

% Facts
:- [statutes/prolog/init].
father_(span("father",17,22)).
marriage_(span("married",54,60)).
agent_(span("father",17,22),span("Charlie",0,6)).
patient_(span("father",17,22),span("Bob",11,13)).
start_(span("father",17,22),span(20140415,30,45)).
agent_(span("married",54,60),span("Alice",48,52)).
agent_(span("married",54,60),span("Charlie",62,68)).
start_(span("married",54,60),span(19921012,73,90)).

% Test
:- \+ s152_d_2_F("Alice","Bob",_,_,_).
:- halt.
