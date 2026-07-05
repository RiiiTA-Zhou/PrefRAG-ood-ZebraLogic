% Text
% Charlie is Alice's father since April 15th, 2014. Bob is Charlie's brother since October 12th, 1992.

% Question
% Alice bears a relationship to Bob under section 152(d)(2)(E). Entailment

% Facts
:- [statutes/prolog/init].
father_(span("father",19,24)).
brother_(span("brother",67,73)).
agent_(span("brother",67,73),span("Bob",50,52)).
patient_(span("brother",67,73),span("Charlie",57,63)).
start_(span("brother",67,73),span(19921012,81,98)).
agent_(span("father",19,24),span("Charlie",0,6)).
patient_(span("father",19,24),span("Alice",11,15)).
start_(span("father",19,24),span(20140415,32,47)).

% Test
:- s152_d_2_E("Alice","Bob",_,_,_).
:- halt.
