% Text
% Alice employed Bob from Jan 1st, 2011 to Oct 10, 2019, paying him $1513 in 2019. On Oct 10, 2019 Bob was diagnosed as disabled and retired. Alice paid Bob $298 because she had to terminate their contract due to Bob's disability. In 2019, Alice's gross income was $567192. In 2019, Alice lived together with Charlie, her father, in a house that she maintains. Charlie had no income in 2019. Alice takes the standard deduction in 2019.

% Question
% How much tax does Alice have to pay in 2019? $196056

% Facts
:- [statutes/prolog/init].
service_(span("employed",6,13)).
patient_(span("employed",6,13),span("Alice",0,4)).
agent_(span("employed",6,13),span("Bob",15,17)).
start_(span("employed",6,13),span(20110101,24,36)).
end_(span("employed",6,13),span(20191010,41,52)).
payment_(span("paying",55,60)).
purpose_(span("paying",55,60),span("employed",6,13)).
amount_(span("paying",55,60),span(1513,67,70)).
start_(span("paying",55,60),span(20190101,75,78)).
patient_(span("paying",55,60),span("Bob",15,17)).
agent_(span("paying",55,60),span("Alice",140,144)).
disability_(span("disabled",118,125)).
start_(span("disabled",118,125),span(20191010,84,95)).
agent_(span("disabled",118,125),span("Bob",97,99)).
retirement_(span("retired",131,137)).
start_(span("retired",131,137),span(20191010,84,95)).
agent_(span("retired",131,137),span("Bob",97,99)).
reason_(span("retired",131,137),span("disability",217,226)).
payment_(span("paid",146,149)).
start_(span("paid",146,149),span(20191010,84,95)).
agent_(span("paid",146,149),span("Alice",140,144)).
patient_(span("paid",146,149),span("Bob",151,153)).
amount_(span("paid",146,149),span(298,156,158)).
purpose_(span("paid",146,149),span("terminate",179,187)).
termination_(span("terminate",179,187)).
patient_(span("terminate",179,187),span("employed",6,13)).
agent_(span("terminate",179,187),span("Alice",140,144)).
reason_(span("terminate",179,187),span("disability",217,226)).
income_(span("income",252,257)).
agent_(span("income",252,257),span("Alice",238,242)).
amount_(span("income",252,257),span(567192,264,269)).
start_(span("income",252,257),span(20190101,232,235)).
residence_(span("lived",287,291)).
start_(span("lived",287,291),span(20190101,275,278)).
end_(span("lived",287,291),span(20191231,275,278)).
agent_(span("lived",287,291),span("Alice",281,285)).
agent_(span("lived",287,291),span("Charlie",307,313)).
patient_(span("lived",287,291),span("house",333,337)).
father_(span("father",320,325)).
patient_(span("father",320,325),span("Alice",281,285)).
agent_(span("father",320,325),span("Charlie",307,313)).
payment_(span("maintains",348,356)).
start_(span("maintains",348,356),span(20190101,275,278)).
purpose_(span("maintains",348,356),span("house",333,337)).
amount_(span("maintains",348,356),span(1,348,356)).
agent_(span("maintains",348,356),span("Alice",281,285)).

% Test
:- tax("Alice",2019,196056).
:- halt.
