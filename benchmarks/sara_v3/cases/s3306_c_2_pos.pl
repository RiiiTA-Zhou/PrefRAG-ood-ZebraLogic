% Text
% Alice has paid wages of $300 to Bob for domestic service in her private home from Feb 1st, 2017 to Sep 2nd, 2017.

% Question
% Section 3306(c)(2) applies to Alice employing Bob for the year 2017. Entailment

% Facts
:- discontiguous s3306_b/8.
:- [statutes/prolog/init].
s3306_b(300,span("paid",10,13),span("service",49,55),"Alice","Bob","Alice","Bob",_).
payment_(span("paid",10,13)).
service_(span("service",49,55)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(300,25,27)).
patient_(span("paid",10,13),span("Bob",32,34)).
purpose_(span("paid",10,13),span("service",49,55)).
start_(span("paid",10,13),span(20170902,99,111)).
patient_(span("service",49,55),span("Alice",0,4)).
agent_(span("service",49,55),span("Bob",32,34)).
purpose_(span("service",49,55),span("domestic service",40,55)).
location_(span("service",49,55),span("private home",64,75)).
start_(span("service",49,55),span(20170201,82,94)).
end_(span("service",49,55),span(20170902,99,111)).

% Test
:- s3306_c_2(span("service",49,55),_,2017).
:- halt.
