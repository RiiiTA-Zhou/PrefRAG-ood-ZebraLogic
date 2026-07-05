% Text
% Bob is Alice's father. Alice's gross income in 2015 is $311510. Bob has no income in 2015. Alice takes the standard deduction in 2015.

% Question
% How much tax does Alice have to pay in 2015? $102150

% Facts
:- [statutes/prolog/init].
father_(span("father",15,20)).
income_(span("income",37,42)).
agent_(span("father",15,20),span("Bob",0,2)).
patient_(span("father",15,20),span("Alice",7,11)).
agent_(span("income",37,42),span("Alice",23,27)).
start_(span("income",37,42),span(20150101,47,50)).
amount_(span("income",37,42),span(311510,56,61)).

% Test
:- tax("Alice",2015,102150).
:- halt.
