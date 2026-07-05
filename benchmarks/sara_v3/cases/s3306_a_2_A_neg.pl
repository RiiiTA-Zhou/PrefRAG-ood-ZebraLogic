% Text
% Alice has paid wages of $3200 to Bob for agricultural labor done from Feb 1st, 2017 to Sep 2nd, 2017. Bob has paid wages of $4520 to Alice for work done from Apr 1st, 2017 to Sep 1st, 2018.

% Question
% Under section 3306(a)(2)(A), Alice is an employer for the year 2017. Contradiction

% Facts
:- discontiguous s3306_b/8.
:- [statutes/prolog/init].
s3306_b(3200,span("paid",10,13),span("labor",54,58),"Alice","Bob","Alice","Bob",_).
s3306_b(4520,span("paid",110,113),span("work",143,146),"Bob","Alice","Bob","Alice",_).
payment_(span("paid",10,13)).
service_(span("labor",54,58)).
payment_(span("paid",110,113)).
service_(span("work",143,146)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,25,28)).
patient_(span("paid",10,13),span("Bob",33,35)).
purpose_(span("paid",10,13),span("labor",54,58)).
start_(span("paid",10,13),span(20170902,87,99)).
agent_(span("paid",110,113),span("Bob",102,104)).
amount_(span("paid",110,113),span(4520,125,128)).
patient_(span("paid",110,113),span("Alice",133,137)).
purpose_(span("paid",110,113),span("work",143,146)).
start_(span("paid",110,113),span(20180901,175,187)).
patient_(span("labor",54,58),span("Alice",0,4)).
agent_(span("labor",54,58),span("Bob",33,35)).
purpose_(span("labor",54,58),span("agricultural labor",41,58)).
start_(span("labor",54,58),span(20170201,70,82)).
end_(span("labor",54,58),span(20170902,87,99)).
patient_(span("work",143,146),span("Bob",102,104)).
agent_(span("work",143,146),span("Alice",133,137)).
start_(span("work",143,146),span(20170401,158,170)).
end_(span("work",143,146),span(20180901,175,187)).

% Test
:- \+ s3306_a_2_A("Alice",2017,_,_).
:- halt.
