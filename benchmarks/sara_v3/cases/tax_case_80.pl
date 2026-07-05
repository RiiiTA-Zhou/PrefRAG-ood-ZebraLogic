% Text
% Alice's gross income for the year 2014 is $97407. In 2014, Alice's father Bob lived at the house that Alice maintains and resides in. Alice takes the standard deduction in 2014.

% Question
% How much tax does Alice have to pay in 2014? $21452

% Facts
:- [statutes/prolog/init].
income_(span("income",14,19)).
father_(span("father",67,72)).
residence_(span("lived",78,82)).
payment_(span("maintains",108,116)).
residence_(span("resides",122,128)).
patient_(span("father",67,72),span("Alice",59,63)).
agent_(span("father",67,72),span("Bob",74,76)).
agent_(span("income",14,19),span("Alice",0,4)).
start_(span("income",14,19),span(20140101,34,37)).
amount_(span("income",14,19),span(97407,43,47)).
purpose_(span("maintains",108,116),span("house",91,95)).
agent_(span("maintains",108,116),span("Alice",102,106)).
amount_(span("maintains",108,116),span(1,108,116)).
start_(span("maintains",108,116),span(20140101,53,56)).
agent_(span("lived",78,82),span("Bob",74,76)).
patient_(span("lived",78,82),span("house",91,95)).
end_(span("lived",78,82),span(20141231,53,56)).
start_(span("lived",78,82),span(20140101,53,56)).
patient_(span("resides",122,128),span("house",91,95)).
agent_(span("resides",122,128),span("Alice",102,106)).
end_(span("resides",122,128),span(20141231,53,56)).
start_(span("resides",122,128),span(20140101,53,56)).

% Test
:- tax("Alice",2014,21452).
:- halt.
