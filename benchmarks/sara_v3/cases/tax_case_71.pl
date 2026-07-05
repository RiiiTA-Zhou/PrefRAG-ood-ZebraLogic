% Text
% In 2017, Alice was paid $433320 in remuneration. Alice and Bob got married on Jan 1st, 2015. Bob's gross income for 2017 is $532134. Alice and Bob file a joint return for the year 2017 and take the standard deduction.

% Question
% How much tax does Alice have to pay in 356472? $356472

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
marriage_(span("married",67,73)).
income_(span("income",105,110)).
joint_return_(span("joint return",154,165)).
agent_(span("income",105,110),span("Bob",93,95)).
start_(span("income",105,110),span(20170101,116,119)).
amount_(span("income",105,110),span(532134,125,130)).
start_(span("joint return",154,165),span(20170101,180,183)).
agent_(span("joint return",154,165),span("Alice",133,137)).
agent_(span("joint return",154,165),span("Bob",143,145)).
agent_(span("married",67,73),span("Alice",49,53)).
agent_(span("married",67,73),span("Bob",59,61)).
start_(span("married",67,73),span(20150101,78,90)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(433320,25,30)).

% Test
:- tax("Alice",2017,356472).
:- halt.
