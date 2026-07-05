% Text
% Alice has been running a typewriter factory since February 1st, 2016. Bob is an employee at the typewriter factory. On October 2nd 2017, Alice has given a typewriter of value $323 to Bob in exchange for Bob painting Alice's house.

% Question
% Section 3306(b)(7) applies to the payment Alice made to Bob. Entailment

% Facts
:- [statutes/prolog/init].
business_(span("running",15,21)).
payment_(span("given",147,151)).
service_(span("painting",207,214)).
agent_(span("running",15,21),span("Alice",0,4)).
type_(span("running",15,21),span("typewriter factory",25,42)).
start_(span("running",15,21),span(20160201,50,67)).
start_(span("given",147,151),span(20171002,119,134)).
agent_(span("given",147,151),span("Alice",137,141)).
means_(span("given",147,151),span("a typewriter of value $323",153,178)).
amount_(span("given",147,151),span(323,176,178)).
patient_(span("given",147,151),span("Bob",183,185)).
purpose_(span("given",147,151),span("painting",207,214)).
agent_(span("painting",207,214),span("Bob",203,205)).
type_(span("painting",207,214),span("painting",207,214)).
patient_(span("painting",207,214),span("Alice",216,220)).

% Test
:- s3306_b_7(span("given",147,151),_,"Alice","Bob",_,_).
:- halt.
