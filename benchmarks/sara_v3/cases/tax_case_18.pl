% Text
% Charlie is Alice's father since April 15th, 1994. Bob is Charlie's brother since October 12th, 1992. Alice's gross income in 2015 is $87319. Both Charlie and Bob have no income in 2015, and are not qualifying children to any taxpayer.

% Question
% How much tax does Alice have to pay in 2015? $19801

% Facts
:- [statutes/prolog/init].
father_(span("father",19,24)).
brother_(span("brother",67,73)).
income_(span("income",115,120)).
agent_(span("brother",67,73),span("Bob",50,52)).
patient_(span("brother",67,73),span("Charlie",57,63)).
start_(span("brother",67,73),span(19921012,81,98)).
patient_(span("father",19,24),span("Alice",11,15)).
start_(span("father",19,24),span(19940415,32,47)).
agent_(span("father",19,24),span("Charlie",0,6)).
agent_(span("income",115,120),span("Alice",101,105)).
start_(span("income",115,120),span(20150101,125,128)).
amount_(span("income",115,120),span(87319,134,138)).

% Test
:- tax("Alice",2015,19801).
:- halt.
