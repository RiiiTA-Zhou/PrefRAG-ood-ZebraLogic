% Text
% Alice has paid wages of $53200 to Bob for domestic service done from Feb 1st, 2017 to Sep 2nd, 2017. Alice's gross income in 2017 was $921324. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $344848

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("service",51,57)).
income_(span("income",115,120)).
agent_(span("income",115,120),span("Alice",101,105)).
start_(span("income",115,120),span(20170101,125,128)).
amount_(span("income",115,120),span(921324,135,140)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(53200,25,29)).
patient_(span("paid",10,13),span("Bob",34,36)).
purpose_(span("paid",10,13),span("service",51,57)).
start_(span("paid",10,13),span(20170902,86,98)).
patient_(span("service",51,57),span("Alice",0,4)).
agent_(span("service",51,57),span("Bob",34,36)).
purpose_(span("service",51,57),span("domestic service",42,57)).
start_(span("service",51,57),span(20170201,69,81)).
end_(span("service",51,57),span(20170902,86,98)).

% Test
:- tax("Alice",2017,344848).
:- halt.
