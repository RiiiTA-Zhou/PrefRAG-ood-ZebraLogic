% Text
% Alice's gross income for the year 2006 is $97407. Bob's gross income for the year 2006 is $136370. Alice and Bob have been married since Feb 3rd, 2006. Bob and Alice file a joint return for 2006 and take the standard deduction.

% Question
% How much tax does Bob have to pay in 2006? $66088

% Facts
:- [statutes/prolog/init].
income_(span("income",14,19)).
income_(span("income",62,67)).
marriage_(span("married",123,129)).
joint_return_(span("joint return",173,184)).
agent_(span("income",14,19),span("Alice",0,4)).
start_(span("income",14,19),span(20060101,34,37)).
amount_(span("income",14,19),span(97407,43,47)).
agent_(span("income",62,67),span("Bob",50,52)).
start_(span("income",62,67),span(20060101,82,85)).
amount_(span("income",62,67),span(136370,91,96)).
agent_(span("joint return",173,184),span("Bob",152,154)).
agent_(span("joint return",173,184),span("Alice",160,164)).
start_(span("joint return",173,184),span(20060101,190,193)).
agent_(span("married",123,129),span("Alice",99,103)).
agent_(span("married",123,129),span("Bob",109,111)).
start_(span("married",123,129),span(20060203,137,149)).

% Test
:- tax("Alice",2006,66088).
:- halt.
