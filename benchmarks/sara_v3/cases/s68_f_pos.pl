% Text
% In 2018, Alice's income was $310192. Alice is a surviving spouse for the year 2018. Alice is allowed itemized deductions of $600 under section 63.

% Question
% Section 68(f) applies to Alice for the year 2018. Entailment

% Facts
:- discontiguous s2_a/3.
:- [statutes/prolog/init].
s2_a("Alice",_,2018).
income_(span("income",17,22)).
agent_(span("income",17,22),span("Alice",9,13)).
amount_(span("income",17,22),span(310192,29,34)).
start_(span("income",17,22),span(20180101,3,6)).

% Test
:- s68_f(2018).
:- halt.
