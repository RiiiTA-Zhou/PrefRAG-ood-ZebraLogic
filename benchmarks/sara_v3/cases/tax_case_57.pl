% Text
% Alice got married on Feb 29, 2000. Alice files a joint return with her spouse for 2017. Alice's gross income for the year 2017 is $22895, and her spouse's income is $14257. They take the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $4073

% Facts
:- [statutes/prolog/init].
marriage_(span("married",10,16)).
joint_return_(span("joint return",49,60)).
income_(span("income",102,107)).
income_(span("income",155,160)).
agent_(span("income",102,107),span("Alice",88,92)).
start_(span("income",102,107),span(20170101,122,125)).
amount_(span("income",102,107),span(22895,131,135)).
start_(span("income",155,160),span(20170101,122,125)).
agent_(span("income",155,160),span("spouse",146,151)).
amount_(span("income",155,160),span(14257,166,170)).
agent_(span("joint return",49,60),span("Alice",35,39)).
agent_(span("joint return",49,60),span("spouse",71,76)).
start_(span("joint return",49,60),span(20170101,82,85)).
agent_(span("married",10,16),span("Alice",0,4)).
start_(span("married",10,16),span(20000229,21,32)).
agent_(span("married",10,16),span("spouse",71,76)).

% Test
:- tax("Alice",2017,4073).
:- halt.
