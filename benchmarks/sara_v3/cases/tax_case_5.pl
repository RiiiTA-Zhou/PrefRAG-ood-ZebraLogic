% Text
% In 2017, Alice's gross income was $326332. Alice and Bob have been married since Feb 3rd, 2017, and have had the same principal place of abode since 2015. Alice was born March 2nd, 1950 and Bob was born March 3rd, 1955. Alice and Bob file separately in 2017. Bob has no gross income that year. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $116066

% Facts
:- [statutes/prolog/init].
income_(span("income",23,28)).
start_(span("income",23,28),span(20170101,3,6)).
agent_(span("income",23,28),span("Alice",9,13)).
amount_(span("income",23,28),span(326332,35,40)).
marriage_(span("married",67,73)).
agent_(span("married",67,73),span("Alice",43,47)).
agent_(span("married",67,73),span("Bob",53,55)).
start_(span("married",67,73),span(20170203,81,93)).
residence_(span("abode",137,141)).
patient_(span("abode",137,141),span("place",128,132)).
start_(span("abode",137,141),span(20150101,149,152)).
agent_(span("abode",137,141),span("Alice",43,47)).
agent_(span("abode",137,141),span("Bob",53,55)).
birth_(span("born",165,168)).
start_(span("born",165,168),span(19500302,170,184)).
agent_(span("born",165,168),span("Alice",155,159)).
birth_(span("born",198,201)).
agent_(span("born",198,201),span("Bob",190,192)).
start_(span("born",198,201),span(19550303,203,217)).

% Test
:- tax("Alice",2017,116066).
:- halt.
