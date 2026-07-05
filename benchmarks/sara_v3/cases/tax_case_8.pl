% Text
% Alice and Bob got married on Sep 12th, 1998. Their son Charlie was born October 1st, 2013. Bob passed away March 2nd, 2015. In 2017, Alice and Charlie live in a house maintained by Alice. Alice's gross income for the year 2017 was $70117. Alice takes the standard deduction in 2017.

% Question
% How much tax does Alice have to pay in 2017? $12036

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
son_(span("son",51,53)).
death_(span("passed away",95,105)).
residence_(span("live",151,154)).
payment_(span("maintained",167,176)).
income_(span("income",202,207)).
agent_(span("passed away",95,105),span("Bob",91,93)).
start_(span("passed away",95,105),span(20150302,107,121)).
agent_(span("income",202,207),span("Alice",188,192)).
start_(span("income",202,207),span(20170101,222,225)).
amount_(span("income",202,207),span(70117,232,236)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19980912,29,42)).
purpose_(span("maintained",167,176),span("house",161,165)).
agent_(span("maintained",167,176),span("Alice",181,185)).
amount_(span("maintained",167,176),span(1,167,176)).
start_(span("maintained",167,176),span(20170101,127,130)).
agent_(span("live",151,154),span("Alice",133,137)).
agent_(span("live",151,154),span("Charlie",143,149)).
patient_(span("live",151,154),span("house",161,165)).
end_(span("live",151,154),span(20171231,127,130)).
start_(span("live",151,154),span(20170101,127,130)).
patient_(span("son",51,53),span("Alice",0,4)).
agent_(span("son",51,53),span("Charlie",55,61)).
start_(span("son",51,53),span(20131001,72,88)).
patient_(span("son",51,53),span("Bob",10,12)).
birth_(span("born",67,70)).
agent_(span("born",67,70),span("Charlie",55,61)).
start_(span("born",67,70),span(20131001,72,88)).

% Test
:- tax("Alice",2017,12036).
:- halt.
