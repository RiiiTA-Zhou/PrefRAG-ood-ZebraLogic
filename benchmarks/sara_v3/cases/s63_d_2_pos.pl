% Text
% In 2017, Alice was paid $33200 in remuneration. She is allowed a deduction for herself under section 151 of $2000 for the year 2017.

% Question
% Alice's deduction for 2017 falls under section 63(d)(2). Entailment

% Facts
:- discontiguous s151/5.
:- [statutes/prolog/init].
s151("Alice",2000,["Alice"],_,2017).
payment_(span("paid",19,22)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).
start_(span("paid",19,22),span(20170101,3,6)).

% Test
:- s63_d_2("Alice",[2000],2017).
:- halt.
