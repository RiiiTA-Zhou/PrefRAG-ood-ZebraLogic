% Text
% Bob is Alice's father. Alice has paid $45252 to Bob for work done in the year 2017.

% Question
% How much tax does Alice have to pay in 2017? $0

% Facts
:- [statutes/prolog/init].
father_(span("father",15,20)).
payment_(span("paid",33,36)).
service_(span("work",56,59)).
agent_(span("father",15,20),span("Bob",0,2)).
patient_(span("father",15,20),span("Alice",7,11)).
agent_(span("paid",33,36),span("Alice",23,27)).
amount_(span("paid",33,36),span(45252,39,43)).
patient_(span("paid",33,36),span("Bob",48,50)).
purpose_(span("paid",33,36),span("work",56,59)).
start_(span("paid",33,36),span(20170101,78,81)).
patient_(span("work",56,59),span("Alice",23,27)).
agent_(span("work",56,59),span("Bob",48,50)).
end_(span("work",56,59),span(20171231,78,81)).
start_(span("work",56,59),span(20170101,78,81)).

% Test
:- tax("Alice",2017,0).
:- halt.
