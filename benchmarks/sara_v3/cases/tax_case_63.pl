% Text
% Alice and Bob have been married since Feb 3rd, 2017. Alice was born March 2nd, 1950 and Bob was born March 3rd, 1955. Bob's gross income for the year 2019 is $113580. Alice and Bob file jointly in 2019, and take the standard deduction. Alice had no income in 2019.

% Question
% How much tax does Bob have to pay in 2019? $20298

% Facts
:- [statutes/prolog/init].
marriage_(span("married",24,30)).
birth_(span("born",63,66)).
birth_(span("born",96,99)).
income_(span("income",130,135)).
joint_return_(span("file jointly",181,192)).
agent_(span("born",63,66),span("Alice",53,57)).
start_(span("born",63,66),span(19500302,68,82)).
agent_(span("born",96,99),span("Bob",88,90)).
start_(span("born",96,99),span(19550303,101,115)).
agent_(span("income",130,135),span("Bob",118,120)).
start_(span("income",130,135),span(20190101,150,153)).
amount_(span("income",130,135),span(113580,159,164)).
agent_(span("file jointly",181,192),span("Alice",167,171)).
agent_(span("file jointly",181,192),span("Bob",177,179)).
start_(span("file jointly",181,192),span(20190101,197,200)).
agent_(span("married",24,30),span("Alice",0,4)).
agent_(span("married",24,30),span("Bob",10,12)).
start_(span("married",24,30),span(20170203,38,50)).

% Test
:- tax("Bob",2019,20298).
:- halt.
