% Text
% Alice's gross income for the year 2017 is $22895. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $2684

% Facts
:- [statutes/prolog/init].
income_(span("income",14,19)).
agent_(span("income",14,19),span("Alice",0,4)).
start_(span("income",14,19),span(20170101,34,37)).
amount_(span("income",14,19),span(22895,43,47)).

% Test
:- tax("Alice",2017,2684).
:- halt.
