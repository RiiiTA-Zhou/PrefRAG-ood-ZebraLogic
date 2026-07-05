% Text
% Charlie is Bob's father since April 15th, 2014, and Bob has lived at Charlie's place since then. Alice is Charlie's sister since October 12th, 1992. Charlie's gross income in 2015 was $52650. In 2015, Alice's gross income was $2312. Alice takes the standard deduction in 2015.

% Question
% How much tax does Alice have to pay in 2015? $0

% Facts
:- [statutes/prolog/init].
father_(span("father",17,22)).
residence_(span("lived",60,64)).
residence_(span("place",79,83)).
sister_(span("sister",116,121)).
income_(span("income",165,170)).
income_(span("income",215,220)).
agent_(span("father",17,22),span("Charlie",0,6)).
patient_(span("father",17,22),span("Bob",11,13)).
start_(span("father",17,22),span(20140415,30,45)).
agent_(span("income",215,220),span("Alice",201,205)).
amount_(span("income",215,220),span(2312,227,230)).
start_(span("income",215,220),span(20150101,195,198)).
agent_(span("income",165,170),span("Charlie",149,155)).
start_(span("income",165,170),span(20150101,175,178)).
amount_(span("income",165,170),span(52650,185,189)).
agent_(span("place",79,83),span("Charlie",69,75)).
patient_(span("place",79,83),span("place",79,83)).
start_(span("lived",60,64),span(20140415,30,45)).
agent_(span("lived",60,64),span("Bob",52,54)).
patient_(span("lived",60,64),span("place",79,83)).
agent_(span("sister",116,121),span("Alice",97,101)).
patient_(span("sister",116,121),span("Charlie",106,112)).
start_(span("sister",116,121),span(19921012,129,146)).

% Test
:- tax("Alice",2015,0).
:- halt.
