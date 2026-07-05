% Text
% In 2017, Alice was paid $33200. She is allowed a deduction of $2000 for herself for the year 2017 under section 151(b).

% Question
% Alice's deduction for 2017 falls under section 63(d). Contradiction

% Facts
:- discontiguous s151_b/3.
:- [statutes/prolog/init].
s151_b("Alice",2000,2017).
payment_(span("paid",19,22)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).
start_(span("paid",19,22),span(20170101,3,6)).

% Test
:- \+ s63_d("Alice",_,_,2017).
:- halt.
