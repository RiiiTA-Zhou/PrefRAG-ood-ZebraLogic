% Text
% In 2015, Alice's income was $2312. The exemption amount for Alice under section 151(d) for the year 2015 was $2000.

% Question
% Section 152(d)(1)(B) applies to Alice for the year 2015. Contradiction

% Facts
:- discontiguous s151_d/4.
:- [statutes/prolog/init].
s151_d("Alice",_,2000,2015).
income_(span("income",17,22)).
agent_(span("income",17,22),span("Alice",9,13)).
amount_(span("income",17,22),span(2312,29,32)).
start_(span("income",17,22),span(20150101,3,6)).

% Test
:- \+ s152_d_1_B("Alice",2015).
:- halt.
