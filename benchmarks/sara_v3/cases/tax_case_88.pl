% Text
% Alice and Bob got married on Sep 22nd, 2005. Their son Charlie was born Jan 10th, 2002. Bob passed away at the end of 2010. In 2011, Alice paid for her and Charlie's housing, a house that they shared. In 2011, Alice's gross income was $25561 and she took the standard deduction.

% Question
% How much tax does Alice have to pay in 2011? $2334

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
son_(span("son",51,53)).
death_(span("passed away",92,102)).
payment_(span("paid",139,142)).
residence_(span("housing",166,172)).
income_(span("income",224,229)).
agent_(span("passed away",92,102),span("Bob",88,90)).
start_(span("passed away",92,102),span(20101231,111,121)).
start_(span("income",224,229),span(20110101,204,207)).
agent_(span("income",224,229),span("Alice",210,214)).
amount_(span("income",224,229),span(25561,236,240)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(20050922,29,42)).
start_(span("paid",139,142),span(20110101,127,130)).
amount_(span("paid",139,142),span(1,139,142)).
agent_(span("paid",139,142),span("Alice",133,137)).
purpose_(span("paid",139,142),span("house",177,181)).
start_(span("housing",166,172),span(20110101,127,130)).
agent_(span("housing",166,172),span("Alice",133,137)).
agent_(span("housing",166,172),span("Charlie",156,162)).
patient_(span("housing",166,172),span("house",177,181)).
end_(span("housing",166,172),span(20111231,127,130)).
patient_(span("son",51,53),span("Alice",0,4)).
agent_(span("son",51,53),span("Charlie",55,61)).
start_(span("son",51,53),span(20020110,72,85)).
patient_(span("son",51,53),span("Bob",10,12)).
birth_(span("born",67,70)).
agent_(span("born",67,70),span("Charlie",55,61)).
start_(span("born",67,70),span(20020110,72,85)).

% Test
:- tax("Alice",2011,2334).
:- halt.
