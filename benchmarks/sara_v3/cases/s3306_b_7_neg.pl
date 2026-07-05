% Text
% Alice has been running a typewriter factory since February 1st, 2016. Bob is an employee at the typewriter factory. On October 2nd 2017, Alice has paid Bob $323 in cash for painting her house.

% Question
% Section 3306(b)(7) applies to the payment Alice made to Bob. Contradiction

% Facts
:- [statutes/prolog/init].
business_(span("running",15,21)).
payment_(span("paid",147,150)).
service_(span("painting",173,180)).
agent_(span("running",15,21),span("Alice",0,4)).
type_(span("running",15,21),span("typewriter factory",25,42)).
start_(span("running",15,21),span(20160201,50,67)).
start_(span("paid",147,150),span(20171002,119,134)).
agent_(span("paid",147,150),span("Alice",137,141)).
patient_(span("paid",147,150),span("Bob",152,154)).
amount_(span("paid",147,150),span(323,157,159)).
means_(span("paid",147,150),span("cash",164,167)).
purpose_(span("paid",147,150),span("painting",173,180)).
patient_(span("painting",173,180),span("Alice",137,141)).
agent_(span("painting",173,180),span("Bob",152,154)).
type_(span("painting",173,180),span("painting",173,180)).

% Test
:- \+ s3306_b_7(span("paid",147,150),_,"Alice","Bob",_,_).
:- halt.
