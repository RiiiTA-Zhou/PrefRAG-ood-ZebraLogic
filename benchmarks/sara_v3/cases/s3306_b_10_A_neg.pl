% Text
% Alice has employed Bob from Jan 1st, 2011 to Oct 10, 2019. On Oct 10, 2019 Bob retired because he reached age 65. Alice paid Bob $12980 as a retirement bonus.

% Question
% Section 3306(b)(10)(A) applies to the payment of $12980 that Alice made in 2019. Contradiction

% Facts
:- [statutes/prolog/init].
service_(span("employed",10,17)).
retirement_(span("retired",79,85)).
payment_(span("paid",120,123)).
termination_(span("retirement",141,150)).
start_(span("paid",120,123),span(20191010,62,73)).
agent_(span("paid",120,123),span("Alice",114,118)).
patient_(span("paid",120,123),span("Bob",125,127)).
amount_(span("paid",120,123),span(12980,130,134)).
purpose_(span("paid",120,123),span("retirement",141,150)).
start_(span("retired",79,85),span(20191010,62,73)).
agent_(span("retired",79,85),span("Bob",75,77)).
reason_(span("retired",79,85),span("reached age 65",98,111)).
patient_(span("employed",10,17),span("Alice",0,4)).
agent_(span("employed",10,17),span("Bob",19,21)).
start_(span("employed",10,17),span(20110101,28,40)).
end_(span("employed",10,17),span(20191010,45,56)).
patient_(span("retirement",141,150),span("employed",10,17)).
agent_(span("retirement",141,150),span("Alice",114,118)).

% Test
:- \+ s3306_b_10_A(span("paid",120,123),_,_,"Alice",_,_).
:- halt.
