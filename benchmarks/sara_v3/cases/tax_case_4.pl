% Text
% Alice has paid $3200 to Bob for domestic service done from Feb 1st, 2012 to Sep 1st, 2012, in Baltimore, Maryland, USA. Bob has paid $4500 to Alice for work done from Mar 31st, 2012 to Dec 31st, 2012. Alice takes the standard deduction in 2012.

% Question
% How much tax does Alice have to pay in 2012? $192

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("service",41,47)).
payment_(span("paid",128,131)).
service_(span("work",152,155)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",24,26)).
purpose_(span("paid",10,13),span("service",41,47)).
start_(span("paid",10,13),span(20120901,76,88)).
start_(span("paid",128,131),span(20120901,76,88)).
agent_(span("paid",128,131),span("Bob",120,122)).
amount_(span("paid",128,131),span(4500,134,137)).
patient_(span("paid",128,131),span("Alice",142,146)).
purpose_(span("paid",128,131),span("work",152,155)).
patient_(span("service",41,47),span("Alice",0,4)).
agent_(span("service",41,47),span("Bob",24,26)).
purpose_(span("service",41,47),span("domestic service",32,47)).
start_(span("service",41,47),span(20120201,59,71)).
end_(span("service",41,47),span(20120901,76,88)).
location_(span("service",41,47),span("Baltimore, Maryland, USA",94,117)).
patient_(span("work",152,155),span("Bob",120,122)).
agent_(span("work",152,155),span("Alice",142,146)).
start_(span("work",152,155),span(20120331,167,180)).
end_(span("work",152,155),span(20121231,185,198)).
country_(span("Baltimore, Maryland, USA",94,117),span("USA",115,117)).

% Test
:- tax("Alice",2012,192).
:- halt.
