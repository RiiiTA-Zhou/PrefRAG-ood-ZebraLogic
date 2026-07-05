% Text
% In 2014, Alice's income was $310192. Alice is a surviving spouse for the year 2014. Alice is allowed itemized deductions of $600 under section 63.

% Question
% Section 68(f) applies to Alice for the year 2014. Contradiction

% Facts
:- discontiguous s2_a/3.
:- [statutes/prolog/init].
s2_a("Alice",_,2014).
income_(span("income",17,22)).
agent_(span("income",17,22),span("Alice",9,13)).
amount_(span("income",17,22),span(310192,29,34)).
start_(span("income",17,22),span(20140101,3,6)).

% Test
:- \+ s68_f(2014).
:- halt.
