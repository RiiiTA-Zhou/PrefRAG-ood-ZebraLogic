% Text
% Alice got married on October 9th, 2016. Alice files a joint return with her spouse for 2017. Alice's and her spouse's gross income for the year 2017 is $42876. They take the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $4931

% Facts
:- [statutes/prolog/init].
marriage_(span("married",10,16)).
joint_return_(span("joint return",54,65)).
income_(span("income",124,129)).
agent_(span("income",124,129),span("Alice",93,97)).
start_(span("income",124,129),span(20170101,144,147)).
amount_(span("income",124,129),span(42876,153,157)).
agent_(span("joint return",54,65),span("Alice",40,44)).
agent_(span("joint return",54,65),span("spouse",76,81)).
start_(span("joint return",54,65),span(20170101,87,90)).
agent_(span("married",10,16),span("Alice",0,4)).
start_(span("married",10,16),span(20161009,21,37)).
agent_(span("married",10,16),span("spouse",76,81)).

% Test
:- tax("Alice",2017,4931).
:- halt.
