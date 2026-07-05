% Text
% Alice's gross income in 2015 is $395276. Alice is allowed itemized deductions of $4571, $1973 and $15271.

% Question
% How much tax does Alice have to pay in 2015? $130388

% Facts
:- [statutes/prolog/init].
income_(span("income",14,19)).
deduction_(span("$4571",81,85)).
deduction_(span("$1973",88,92)).
deduction_(span("$15271",98,103)).
start_(span("$15271",98,103),span(20150101,24,27)).
agent_(span("$15271",98,103),span("Alice",41,45)).
amount_(span("$15271",98,103),span(15271,99,103)).
start_(span("$1973",88,92),span(20150101,24,27)).
agent_(span("$1973",88,92),span("Alice",41,45)).
amount_(span("$1973",88,92),span(1973,89,92)).
start_(span("$4571",81,85),span(20150101,24,27)).
agent_(span("$4571",81,85),span("Alice",41,45)).
amount_(span("$4571",81,85),span(4571,82,85)).
agent_(span("income",14,19),span("Alice",0,4)).
start_(span("income",14,19),span(20150101,24,27)).
amount_(span("income",14,19),span(395276,33,38)).

% Test
:- tax("Alice",2015,130388).
:- halt.
