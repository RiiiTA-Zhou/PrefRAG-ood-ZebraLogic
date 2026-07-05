% Text
% Alice married Bob on August 25th, 2011. Alice files a joint return with her husband for 2017. Alice's and Bob's gross income for the year 2017 is $22895 and they take the standard deduction. Alice is 67 years old in 2017.

% Question
% How much tax does Alice have to pay in 2017? $1844

% Facts
:- [statutes/prolog/init].
marriage_(span("married",6,12)).
joint_return_(span("joint return",54,65)).
income_(span("income",118,123)).
birth_(span("old",209,211)).
agent_(span("old",209,211),span("Alice",191,195)).
start_(span("old",209,211),span(19500101,200,207)).
agent_(span("income",118,123),span("Alice",94,98)).
start_(span("income",118,123),span(20170101,138,141)).
amount_(span("income",118,123),span(22895,147,151)).
agent_(span("joint return",54,65),span("Alice",40,44)).
start_(span("joint return",54,65),span(20170101,88,91)).
agent_(span("joint return",54,65),span("Bob",14,16)).
agent_(span("married",6,12),span("Alice",0,4)).
agent_(span("married",6,12),span("Bob",14,16)).
start_(span("married",6,12),span(20110825,21,37)).

% Test
:- tax("Alice",2017,1844).
:- halt.
