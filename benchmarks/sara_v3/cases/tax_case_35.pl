% Text
% Alice's gross income for the year 2017 is $22895. In 2017, Alice takes the standard deduction. Alice has a son, Bob, who has the same principal place of abode as her in 2017 and is not married.

% Question
% How much tax does Alice have to pay in 2017? $2384

% Facts
:- [statutes/prolog/init].
income_(span("income",14,19)).
son_(span("son",107,109)).
residence_(span("abode",153,157)).
agent_(span("income",14,19),span("Alice",0,4)).
start_(span("income",14,19),span(20170101,34,37)).
amount_(span("income",14,19),span(22895,43,47)).
agent_(span("abode",153,157),span("Alice",95,99)).
agent_(span("abode",153,157),span("Bob",112,114)).
patient_(span("abode",153,157),span("place",144,148)).
start_(span("abode",153,157),span(20170101,169,172)).
patient_(span("son",107,109),span("Alice",95,99)).
agent_(span("son",107,109),span("Bob",112,114)).

% Test
:- tax("Alice",2017,2384).
:- halt.
