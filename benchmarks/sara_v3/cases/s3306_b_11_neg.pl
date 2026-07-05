% Text
% Alice has paid $3200 to Bob for repairing her roof from Feb 1st, 2017 to Sep 2nd, 2017. Alice paid Bob with eggs, grapes and hay.

% Question
% Section 3306(b)(11) applies to the payment that Alice made to Bob for the year 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("repairing",32,40)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",24,26)).
purpose_(span("paid",10,13),span("repairing",32,40)).
start_(span("paid",10,13),span(20170902,73,85)).
means_(span("paid",10,13),span("eggs, grapes and hay",108,127)).
patient_(span("repairing",32,40),span("Alice",0,4)).
agent_(span("repairing",32,40),span("Bob",24,26)).
start_(span("repairing",32,40),span(20170201,56,68)).
end_(span("repairing",32,40),span(20170902,73,85)).

% Test
:- \+ s3306_b_11(span("paid",10,13),_,_).
:- halt.
