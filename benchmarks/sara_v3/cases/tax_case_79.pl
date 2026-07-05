% Text
% Alice and Bob have been married since Feb 3rd, 2017. Alice files a joint return with her spouse for 2020. Alice's gross income for the year 2020 is $103272. Bob earned $10 in 2020. Alice and Bob take the standard deduction.

% Question
% How much tax does Bob have to pay in 2020? $17402

% Facts
:- [statutes/prolog/init].
marriage_(span("married",24,30)).
joint_return_(span("joint return",67,78)).
income_(span("income",120,125)).
payment_(span("earned",161,166)).
agent_(span("income",120,125),span("Alice",106,110)).
start_(span("income",120,125),span(20200101,140,143)).
amount_(span("income",120,125),span(103272,149,154)).
agent_(span("joint return",67,78),span("Alice",53,57)).
start_(span("joint return",67,78),span(20200101,100,103)).
agent_(span("joint return",67,78),span("Bob",10,12)).
agent_(span("married",24,30),span("Alice",0,4)).
agent_(span("married",24,30),span("Bob",10,12)).
start_(span("married",24,30),span(20170203,38,50)).
patient_(span("earned",161,166),span("Bob",157,159)).
amount_(span("earned",161,166),span(10,169,170)).
start_(span("earned",161,166),span(20200101,175,178)).

% Test
:- tax("Bob",2020,17402).
:- halt.
