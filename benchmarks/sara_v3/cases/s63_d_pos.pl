% Text
% In 2017, Alice was paid $33200. She is allowed a deduction of $1200 for the year 2017 for donating cash to charity.

% Question
% Alice's deduction for 2017 falls under section 63(d). Entailment

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
deduction_(span("deduction",49,57)).
agent_(span("deduction",49,57),span("Alice",9,13)).
amount_(span("deduction",49,57),span(1200,63,66)).
start_(span("deduction",49,57),span(20170101,81,84)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).
start_(span("paid",19,22),span(20170101,3,6)).

% Test
:- s63_d("Alice",_,_,2017).
:- halt.
