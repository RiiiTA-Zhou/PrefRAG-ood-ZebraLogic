% Text
% Charlie is Bob's father since April 15th, 2014. Alice is Charlie's sister since October 12th, 1992.

% Question
% Alice bears a relationship to Bob under section 152(d)(2)(E). Contradiction

% Facts
:- [statutes/prolog/init].
father_(span("father",17,22)).
sister_(span("sister",67,72)).
agent_(span("father",17,22),span("Charlie",0,6)).
patient_(span("father",17,22),span("Bob",11,13)).
start_(span("father",17,22),span(20140415,30,45)).
agent_(span("sister",67,72),span("Alice",48,52)).
patient_(span("sister",67,72),span("Charlie",57,63)).
start_(span("sister",67,72),span(19921012,80,97)).

% Test
:- \+ s152_d_2_E("Alice","Bob",_,_,_).
:- halt.
