% Text
% Alice has paid $3200 to Bob for agricultural labor done from Feb 1st, 2017 to Sep 2nd, 2017. Alice paid Bob with eggs, grapes and hay.

% Question
% Section 3306(b)(11) applies to the payment that Alice made to Bob for the year 2017. Entailment

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("labor",45,49)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",24,26)).
purpose_(span("paid",10,13),span("labor",45,49)).
start_(span("paid",10,13),span(20170902,78,90)).
means_(span("paid",10,13),span("eggs, grapes and hay",113,132)).
patient_(span("labor",45,49),span("Alice",0,4)).
agent_(span("labor",45,49),span("Bob",24,26)).
purpose_(span("labor",45,49),span("agricultural labor",32,49)).
start_(span("labor",45,49),span(20170201,61,73)).
end_(span("labor",45,49),span(20170902,78,90)).

% Test
:- s3306_b_11(span("paid",10,13),_,_).
:- halt.
