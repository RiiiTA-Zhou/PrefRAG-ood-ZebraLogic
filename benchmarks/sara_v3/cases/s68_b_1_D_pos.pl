% Text
% In 2016, Alice's income was $567192. Alice is married for the year 2016 under section 7703. Alice does not file a joint return.

% Question
% Under section 68(b)(1)(D), Alice's applicable amount for 2016 is equal to $150000. Entailment

% Facts
:- discontiguous s7703/4.
:- [statutes/prolog/init].
s7703("Alice",_,_,2016).
income_(span("income",17,22)).
agent_(span("income",17,22),span("Alice",9,13)).
amount_(span("income",17,22),span(567192,29,34)).
start_(span("income",17,22),span(20160101,3,6)).

% Test
:- s68_b_1_D("Alice",150000,2016).
:- halt.
