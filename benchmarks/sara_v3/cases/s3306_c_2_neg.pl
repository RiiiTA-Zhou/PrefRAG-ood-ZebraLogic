% Text
% Alice has paid wages of $3200 to Bob for domestic service done in her home from Feb 1st, 2017 to Sep 2nd, 2017, in Baltimore, Maryland, USA.

% Question
% Section 3306(c)(2) applies to Alice employing Bob for the year 2017. Contradiction

% Facts
:- discontiguous s3306_b/8.
:- [statutes/prolog/init].
s3306_b(3200,span("paid",10,13),span("service",50,56),"Alice","Bob","Alice","Bob",_).
payment_(span("paid",10,13)).
service_(span("service",50,56)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,25,28)).
patient_(span("paid",10,13),span("Bob",33,35)).
purpose_(span("paid",10,13),span("service",50,56)).
start_(span("paid",10,13),span(20170902,97,109)).
patient_(span("service",50,56),span("Alice",0,4)).
agent_(span("service",50,56),span("Bob",33,35)).
purpose_(span("service",50,56),span("domestic service",41,56)).
location_(span("service",50,56),span("home",70,73)).
start_(span("service",50,56),span(20170201,80,92)).
end_(span("service",50,56),span(20170902,97,109)).
location_(span("service",50,56),span("Baltimore",115,123)).
location_(span("service",50,56),span("Maryland",126,133)).
location_(span("service",50,56),span("USA",136,138)).

% Test
:- \+ s3306_c_2(span("service",50,56),_,2017).
:- halt.
