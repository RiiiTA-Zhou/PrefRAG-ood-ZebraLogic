% Text
% In 2017, Alice was paid $33200. For the year 2017, Alice is allowed a basic standard deduction under section 63(c)(2) of $2000 and an additional standard deduction of $3000 under section 63(c)(3) for the year 2017.

% Question
% Under section 63(c)(1), Alice's standard deduction in 2017 is equal to $5000. Entailment

% Facts
:- discontiguous s63_c_2/3.
:- discontiguous s63_c_3/3.
:- [statutes/prolog/init].
s63_c_2("Alice",2017,2000).
s63_c_3("Alice",3000,2017).
payment_(span("paid",19,22)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).
start_(span("paid",19,22),span(20170101,3,6)).

% Test
:- s63_c_1("Alice",2017,5000).
:- halt.
