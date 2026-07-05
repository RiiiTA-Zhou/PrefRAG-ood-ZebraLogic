% Text
% Alice has paid $3200 to Bob for domestic service done from Feb 1st, 2017 to Sep 2nd, 2017. In 2018, Bob has paid $4500 to Alice for work done from Apr 1st, 2017 to Sep 1st, 2018. Alice was otherwise paid $113209 in 2018.

% Question
% How much tax does Alice have to pay in 2018? $28292

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("service",41,47)).
payment_(span("paid",108,111)).
service_(span("work",132,135)).
payment_(span("paid",199,202)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",24,26)).
purpose_(span("paid",10,13),span("service",41,47)).
start_(span("paid",10,13),span(20170902,76,88)).
patient_(span("paid",199,202),span("Alice",179,183)).
amount_(span("paid",199,202),span(113209,205,210)).
start_(span("paid",199,202),span(20180101,215,218)).
agent_(span("paid",108,111),span("Bob",100,102)).
amount_(span("paid",108,111),span(4500,114,117)).
patient_(span("paid",108,111),span("Alice",122,126)).
purpose_(span("paid",108,111),span("work",132,135)).
start_(span("paid",108,111),span(20180101,94,97)).
patient_(span("service",41,47),span("Alice",0,4)).
agent_(span("service",41,47),span("Bob",24,26)).
purpose_(span("service",41,47),span("domestic service",32,47)).
start_(span("service",41,47),span(20170201,59,71)).
end_(span("service",41,47),span(20170902,76,88)).
start_(span("work",132,135),span(20170401,147,159)).
end_(span("work",132,135),span(20180901,164,176)).
patient_(span("work",132,135),span("Bob",100,102)).
agent_(span("work",132,135),span("Alice",122,126)).

% Test
:- tax("Alice",2018,28292).
:- halt.
