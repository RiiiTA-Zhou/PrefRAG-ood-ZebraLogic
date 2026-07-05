% Text
% Alice got married on Dec 10th, 2009. Alice's gross income for the year 2016 is $554313. Alice files separately and takes the standard deduction. Her husband's gross income in 2016 is $56298 and he takes itemized deductions of $4421.

% Question
% How much tax does Alice have to pay in 2016? $207772

% Facts
:- [statutes/prolog/init].
marriage_(span("married",10,16)).
income_(span("income",51,56)).
income_(span("income",165,170)).
deduction_(span("deductions",212,221)).
agent_(span("deductions",212,221),span("husband",149,155)).
start_(span("deductions",212,221),span(20160101,175,178)).
amount_(span("deductions",212,221),span(4421,227,230)).
agent_(span("income",51,56),span("Alice",37,41)).
start_(span("income",51,56),span(20160101,71,74)).
amount_(span("income",51,56),span(554313,80,85)).
agent_(span("income",165,170),span("husband",149,155)).
start_(span("income",165,170),span(20160101,175,178)).
amount_(span("income",165,170),span(56298,184,188)).
agent_(span("married",10,16),span("Alice",0,4)).
start_(span("married",10,16),span(20091210,21,34)).
agent_(span("married",10,16),span("husband",149,155)).

% Test
:- tax("Alice",2016,207772).
:- halt.
