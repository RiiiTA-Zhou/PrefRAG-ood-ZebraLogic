% Text
% Alice has paid $3200 in cash to Bob for agricultural labor done from Feb 1st, 2017 to Sep 2nd, 2017. Bob has paid $4200 in cash to Alice for domestic service in his home, done from Apr 1st, 2017 to Sep 1st, 2018.

% Question
% Section 3306(a)(3) applies to Bob for the year 2018. Entailment

% Facts
:- discontiguous s3306_b/8.
:- [statutes/prolog/init].
s3306_b(3200,span("paid",10,13),span("labor",53,57),"Alice","Bob","Alice","Bob",_).
s3306_b(4200,span("paid",109,112),span("service",150,156),"Bob","Alice","Bob","Alice",_).
payment_(span("paid",10,13)).
service_(span("labor",53,57)).
payment_(span("paid",109,112)).
service_(span("service",150,156)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
means_(span("paid",10,13),span("cash",24,27)).
patient_(span("paid",10,13),span("Bob",32,34)).
purpose_(span("paid",10,13),span("labor",53,57)).
start_(span("paid",10,13),span(20170902,86,98)).
agent_(span("paid",109,112),span("Bob",101,103)).
amount_(span("paid",109,112),span(4200,115,118)).
means_(span("paid",109,112),span("cash",123,126)).
patient_(span("paid",109,112),span("Alice",131,135)).
purpose_(span("paid",109,112),span("service",150,156)).
start_(span("paid",109,112),span(20180901,198,210)).
patient_(span("labor",53,57),span("Alice",0,4)).
agent_(span("labor",53,57),span("Bob",32,34)).
purpose_(span("labor",53,57),span("agricultural labor",40,57)).
start_(span("labor",53,57),span(20170201,69,81)).
end_(span("labor",53,57),span(20170902,86,98)).
patient_(span("service",150,156),span("Bob",101,103)).
agent_(span("service",150,156),span("Alice",131,135)).
purpose_(span("service",150,156),span("domestic service",141,156)).
location_(span("service",150,156),span("home",165,168)).
start_(span("service",150,156),span(20170401,181,193)).
end_(span("service",150,156),span(20180901,198,210)).

% Test
:- s3306_a_3("Bob",_,_,2018).
:- halt.
