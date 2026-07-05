% Text
% In 2017, Alice's gross income was $44215. Alice and Bob have been married since Oct 10th, 2017. Alice and Bob file separately. Alice has paid $3200 in cash to Bob for agricultural labor done from Feb 1st, 2017 to Sep 2nd, 2017. Alice takes the standard deduction. Alice and Bob live separately in 2017.

% Question
% How much tax does Alice have to pay in 2017? $8582

% Facts
:- [statutes/prolog/init].
residence_(span("Alice",264,268)).
agent_(span("Alice",264,268),span("Alice",264,268)).
patient_(span("Alice",264,268),span("Alice",264,268)).
start_(span("Alice",264,268),span(20170101,297,300)).
end_(span("Alice",264,268),span(20171231,297,300)).
residence_(span("Bob",274,276)).
agent_(span("Bob",274,276),span("Bob",274,276)).
patient_(span("Bob",274,276),span("Bob",274,276)).
start_(span("Bob",274,276),span(20170101,297,300)).
end_(span("Bob",274,276),span(20171231,297,300)).
income_(span("income",23,28)).
marriage_(span("married",66,72)).
payment_(span("paid",137,140)).
service_(span("labor",180,184)).
start_(span("income",23,28),span(20170101,3,6)).
agent_(span("income",23,28),span("Alice",9,13)).
amount_(span("income",23,28),span(44215,35,39)).
agent_(span("married",66,72),span("Alice",42,46)).
agent_(span("married",66,72),span("Bob",52,54)).
start_(span("married",66,72),span(20171010,80,93)).
agent_(span("paid",137,140),span("Alice",127,131)).
amount_(span("paid",137,140),span(3200,143,146)).
means_(span("paid",137,140),span("cash",151,154)).
patient_(span("paid",137,140),span("Bob",159,161)).
purpose_(span("paid",137,140),span("labor",180,184)).
start_(span("paid",137,140),span(20170902,213,225)).
patient_(span("labor",180,184),span("Alice",127,131)).
agent_(span("labor",180,184),span("Bob",159,161)).
purpose_(span("labor",180,184),span("agricultural labor",167,184)).
start_(span("labor",180,184),span(20170201,196,208)).
end_(span("labor",180,184),span(20170902,213,225)).

% Test
:- tax("Alice",2017,8582).
:- halt.
