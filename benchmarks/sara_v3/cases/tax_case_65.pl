% Text
% In 2016, Alice was paid $51020 in remuneration. Alice and Bob have been married since Feb 3rd, 2016, and they file a joint return for 2016. Bob's gross income in 2016 was $42939. Alice and Bob take itemized deductions of $21137.

% Question
% How much tax does Alice have to pay in 2016? $14473

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
marriage_(span("married",72,78)).
joint_return_(span("joint return",117,128)).
income_(span("income",152,157)).
deduction_(span("deductions",207,216)).
start_(span("deductions",207,216),span(20160101,162,165)).
agent_(span("deductions",207,216),span("Alice",179,183)).
amount_(span("deductions",207,216),span(21137,222,226)).
agent_(span("income",152,157),span("Bob",140,142)).
start_(span("income",152,157),span(20160101,162,165)).
amount_(span("income",152,157),span(42939,172,176)).
start_(span("joint return",117,128),span(20160101,134,137)).
agent_(span("joint return",117,128),span("Bob",58,60)).
agent_(span("joint return",117,128),span("Alice",48,52)).
agent_(span("married",72,78),span("Alice",48,52)).
agent_(span("married",72,78),span("Bob",58,60)).
start_(span("married",72,78),span(20160203,86,98)).
start_(span("paid",19,22),span(20160101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(51020,25,29)).

% Test
:- tax("Alice",2016,14473).
:- halt.
