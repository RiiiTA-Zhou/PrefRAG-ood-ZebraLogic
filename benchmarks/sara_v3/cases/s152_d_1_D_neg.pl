% Text
% In 2015, Alice's income was $312. The exemption amount for Alice under section 151(d) for the year 2015 was $2000. Alice is Bob's mother, and Bob is a dependent of Alice under 152(c) for the year 2015.

% Question
% Section 152(d)(1)(D) applies to Bob for the year 2015. Contradiction

% Facts
:- discontiguous s152_c/3.
:- discontiguous s151_d/4.
:- [statutes/prolog/init].
s152_c("Bob","Alice",2015).
s151_d("Alice",_,2000,2015).
income_(span("income",17,22)).
mother_(span("mother",130,135)).
agent_(span("income",17,22),span("Alice",9,13)).
amount_(span("income",17,22),span(312,29,31)).
start_(span("income",17,22),span(20150101,3,6)).
agent_(span("mother",130,135),span("Alice",115,119)).
patient_(span("mother",130,135),span("Bob",124,126)).

% Test
:- \+ s152_d_1_D("Bob",2015).
:- halt.
