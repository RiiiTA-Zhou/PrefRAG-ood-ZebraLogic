% Text
% In 2017, Alice was paid $33200. She is allowed a deduction under section 63(c)(1) of $2000 for the year 2017, and no deduction under section 151. Alice takes the standard deduction.

% Question
% Under section 63(b), Alice's taxable income in 2017 is equal to $31400. Contradiction

% Facts
:- discontiguous s63_c_1/3.
:- discontiguous s151/5.
:- [statutes/prolog/init].
s63_c_1("Alice",2017,2000).
s151("Alice",0,_,_,2017).
payment_(span("paid",19,22)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).
start_(span("paid",19,22),span(20170101,3,6)).

% Test
:- \+ s63_b("Alice",2017,31400,_).
:- halt.
