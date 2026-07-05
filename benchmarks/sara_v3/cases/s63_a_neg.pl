% Text
% In 2017, Alice was paid $33200. She is allowed a deduction under section 63(c) of $2000 and deductions of $4000 under section 151 for the year 2017.

% Question
% Under section 63(a), Alice's taxable income in 2017 is equal to $31200. Contradiction

% Facts
:- discontiguous s151/5.
:- discontiguous s63_c/3.
:- [statutes/prolog/init].
s63_c("Alice",2017,2000).
s151("Alice",4000,_,_,2017).
payment_(span("paid",19,22)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).
start_(span("paid",19,22),span(20170101,3,6)).

% Test
:- \+ s63_a("Alice",2017,31200,_,_).
:- halt.
