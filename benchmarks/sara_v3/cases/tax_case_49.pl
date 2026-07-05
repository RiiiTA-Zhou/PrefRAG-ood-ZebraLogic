% Text
% Bob is Alice and Charlie's father. Bob had no income in 2015. Alice's gross income in 2015 is $264215. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2015? $82819

% Facts
:- [statutes/prolog/init].
father_(span("father",27,32)).
income_(span("income",76,81)).
agent_(span("father",27,32),span("Bob",0,2)).
patient_(span("father",27,32),span("Alice",7,11)).
patient_(span("father",27,32),span("Charlie",17,23)).
agent_(span("income",76,81),span("Alice",62,66)).
start_(span("income",76,81),span(20150101,86,89)).
amount_(span("income",76,81),span(264215,95,100)).

% Test
:- tax("Alice",2015,82819).
:- halt.
