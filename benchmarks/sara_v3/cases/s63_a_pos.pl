% Text
% In 2017, Alice was paid $33200. She is allowed deductions under section 151 of $2000 for the year 2017. She is allowed an itemized deduction of $4252 in 2017.

% Question
% Under section 63(a), Alice's taxable income in 2017 is equal to $26948. Entailment

% Facts
:- discontiguous s151/5.
:- [statutes/prolog/init].
s151("Alice",2000,_,_,2017).
payment_(span("paid",19,22)).
deduction_(span("deduction",131,139)).
agent_(span("deduction",131,139),span("Alice",9,13)).
amount_(span("deduction",131,139),span(4252,145,148)).
start_(span("deduction",131,139),span(20170101,153,156)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).
start_(span("paid",19,22),span(20170101,3,6)).

% Test
:- s63_a("Alice",2017,26948,_,_).
:- halt.
