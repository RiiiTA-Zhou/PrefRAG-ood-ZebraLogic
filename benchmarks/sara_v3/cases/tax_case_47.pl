% Text
% In 2017, Alice earned $133200. Bob's income in 2017 was $44311. Alice and Bob have been married since Feb 3rd, 2017. Alice has been blind since Feb 28, 2014. Alice has paid $4525 to Charlie for work done in the year 2017. In 2017, Alice has also paid $983 into a retirement fund for Charlie, and paid $5322 into health insurance for Charlie, both under a plan. Alice and Bob file jointly and take the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $45946

% Facts
:- [statutes/prolog/init].
income_(span("earned",15,20)).
agent_(span("earned",15,20),span("Alice",9,13)).
amount_(span("earned",15,20),span(133200,23,28)).
start_(span("earned",15,20),span(20170101,3,6)).
income_(span("income",37,42)).
agent_(span("income",37,42),span("Bob",31,33)).
start_(span("income",37,42),span(20170101,47,50)).
amount_(span("income",37,42),span(44311,57,61)).
marriage_(span("married",88,94)).
agent_(span("married",88,94),span("Alice",64,68)).
agent_(span("married",88,94),span("Bob",74,76)).
start_(span("married",88,94),span(20170203,102,114)).
blindness_(span("blind",132,136)).
agent_(span("blind",132,136),span("Alice",117,121)).
start_(span("blind",132,136),span(20140228,144,155)).
service_(span("work",194,197)).
patient_(span("work",194,197),span("Alice",158,162)).
agent_(span("work",194,197),span("Charlie",182,188)).
end_(span("work",194,197),span(20171231,216,219)).
start_(span("work",194,197),span(20170101,216,219)).
payment_(span("paid",168,171)).
agent_(span("paid",168,171),span("Alice",158,162)).
amount_(span("paid",168,171),span(4525,174,177)).
patient_(span("paid",168,171),span("Charlie",182,188)).
purpose_(span("paid",168,171),span("work",194,197)).
start_(span("paid",168,171),span(20170101,216,219)).
payment_(span("paid",246,249)).
purpose_(span("paid",246,249),span("work",194,197)).
start_(span("paid",246,249),span(20170101,225,228)).
agent_(span("paid",246,249),span("Alice",231,235)).
amount_(span("paid",246,249),span(983,252,254)).
patient_(span("paid",246,249),span("retirement fund",263,277)).
plan_(span("retirement fund",263,277)).
beneficiary_(span("retirement fund",263,277),span("Charlie",283,289)).
purpose_(span("retirement fund",263,277),span("make provisions for employees in case of retirement",263,277)).
payment_(span("paid",296,299)).
purpose_(span("paid",296,299),span("work",194,197)).
start_(span("paid",296,299),span(20170101,225,228)).
agent_(span("paid",296,299),span("Alice",231,235)).
amount_(span("paid",296,299),span(5322,302,305)).
patient_(span("paid",296,299),span("health insurance",312,327)).
plan_(span("health insurance",312,327)).
beneficiary_(span("health insurance",312,327),span("Charlie",333,339)).
purpose_(span("health insurance",312,327),span("make provisions for employees in case of sickness",312,327)).
joint_return_(span("file jointly",375,386)).
start_(span("file jointly",375,386),span(20170101,225,228)).
agent_(span("file jointly",375,386),span("Alice",361,365)).
agent_(span("file jointly",375,386),span("Bob",371,373)).

% Test
:- tax("Alice",2017,45946).
:- halt.
