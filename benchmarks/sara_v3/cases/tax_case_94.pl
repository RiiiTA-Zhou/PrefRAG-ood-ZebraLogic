% Text
% Alice's gross income for the year 2010 is $210204. Alice has paid $45252 to Bob for work done in the year 2010. In 2010, Alice has also paid $9832 into a retirement fund for Bob, and paid $5322 into health insurance for Charlie, who is Alice's father and has retired in 2009. Bob has no income in 2010. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2010? $63345

% Facts
:- [statutes/prolog/init].
income_(span("income",14,19)).
payment_(span("paid",61,64)).
service_(span("work",84,87)).
payment_(span("paid",136,139)).
plan_(span("retirement fund",154,168)).
payment_(span("paid",183,186)).
plan_(span("health insurance",199,214)).
father_(span("father",244,249)).
retirement_(span("retired",259,265)).
agent_(span("father",244,249),span("Charlie",220,226)).
patient_(span("father",244,249),span("Alice",236,240)).
agent_(span("income",14,19),span("Alice",0,4)).
start_(span("income",14,19),span(20100101,34,37)).
amount_(span("income",14,19),span(210204,43,48)).
amount_(span("paid",183,186),span(5322,189,192)).
patient_(span("paid",183,186),span("health insurance",199,214)).
beneficiary_(span("paid",183,186),span("Charlie",220,226)).
agent_(span("paid",183,186),span("Alice",121,125)).
start_(span("paid",183,186),span(20100101,115,118)).
purpose_(span("paid",183,186),span("make provisions for employees in case of sickness",199,214)).
start_(span("paid",136,139),span(20100101,115,118)).
agent_(span("paid",136,139),span("Alice",121,125)).
amount_(span("paid",136,139),span(9832,142,145)).
patient_(span("paid",136,139),span("retirement fund",154,168)).
beneficiary_(span("paid",136,139),span("Bob",174,176)).
purpose_(span("paid",136,139),span("make provisions for employees in case of retirement",154,168)).
agent_(span("paid",61,64),span("Alice",51,55)).
amount_(span("paid",61,64),span(45252,67,71)).
patient_(span("paid",61,64),span("Bob",76,78)).
purpose_(span("paid",61,64),span("work",84,87)).
start_(span("paid",61,64),span(20100101,106,109)).
agent_(span("retired",259,265),span("Charlie",220,226)).
start_(span("retired",259,265),span(20090101,270,273)).
patient_(span("work",84,87),span("Alice",51,55)).
agent_(span("work",84,87),span("Bob",76,78)).
end_(span("work",84,87),span(20101231,106,109)).
start_(span("work",84,87),span(20100101,106,109)).

% Test
:- tax("Alice",2010,63345).
:- halt.
