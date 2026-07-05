% Text
% In 2016, Alice's income was $277192. Alice is a head of household for the year 2016. Alice is allowed itemized deductions of $60000 under section 63.

% Question
% Section 68(a)(2) prescribes a reduction of Alice's itemized deductions for the year 2016 by $48000. Entailment

% Facts
:- discontiguous s63_d/4.
:- discontiguous s2_b/3.
:- [statutes/prolog/init].
s63_d("Alice",_,60000,2016).
s2_b("Alice",_,2016).
income_(span("income",17,22)).
agent_(span("income",17,22),span("Alice",9,13)).
amount_(span("income",17,22),span(277192,29,34)).
start_(span("income",17,22),span(20160101,3,6)).

% Test
:- s68_a_2("Alice",_,48000,2016).
:- halt.
