% Text
% Alice's income in 2015 is $100000. She gets one exemption of $2000 for the year 2015 under section 151(c). Alice is not married.

% Question
% Alice's total exemption for 2015 under section 151(a) is equal to $6000. Contradiction

% Facts
:- discontiguous s151_c/4.
:- [statutes/prolog/init].
s151_c("Alice",_,2000,2015).
income_(span("income",8,13)).
agent_(span("income",8,13),span("Alice",0,4)).
start_(span("income",8,13),span(20150101,18,21)).
amount_(span("income",8,13),span(100000,27,32)).

% Test
:- \+ s151_a("Alice",6000,2015).
:- halt.
