% Text
% Alice has paid $3200 to Bob for domestic service done from Feb 1st, 2017 to Sep 2nd, 2017. Bob has paid $4500 to Alice for work done from Apr 1st, 2017 to Sep 1st, 2018.

% Question
% Alice is an employer under section 3306(a)(1) for the year 2018. Contradiction

% Facts
:- discontiguous s3306_b/8.
:- [statutes/prolog/init].
s3306_b(3200,span("paid",10,13),span("service",41,47),"Alice","Bob","Alice","Bob",_).
s3306_b(4500,span("paid",99,102),span("work",123,126),"Bob","Alice","Bob","Alice",_).
payment_(span("paid",10,13)).
service_(span("service",41,47)).
payment_(span("paid",99,102)).
service_(span("work",123,126)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",24,26)).
purpose_(span("paid",10,13),span("service",41,47)).
start_(span("paid",10,13),span(20170902,76,88)).
agent_(span("paid",99,102),span("Bob",91,93)).
amount_(span("paid",99,102),span(4500,105,108)).
patient_(span("paid",99,102),span("Alice",113,117)).
purpose_(span("paid",99,102),span("work",123,126)).
start_(span("paid",99,102),span(20180901,155,167)).
patient_(span("service",41,47),span("Alice",0,4)).
agent_(span("service",41,47),span("Bob",24,26)).
purpose_(span("service",41,47),span("domestic service",32,47)).
start_(span("service",41,47),span(20170201,59,71)).
end_(span("service",41,47),span(20170902,76,88)).
start_(span("work",123,126),span(20170401,138,150)).
end_(span("work",123,126),span(20180901,155,167)).
patient_(span("work",123,126),span("Bob",91,93)).
agent_(span("work",123,126),span("Alice",113,117)).

% Test
:- \+ s3306_a_1("Alice",2018).
:- halt.
