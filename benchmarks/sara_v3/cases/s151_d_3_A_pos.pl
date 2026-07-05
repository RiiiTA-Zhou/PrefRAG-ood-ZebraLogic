% Text
% Alice's income in 2015 was $260932. For 2015, Alice received one exemption of $2000 under section 151(c). Alice's applicable percentage under section 151(d)(3)(B) is equal to 10%.

% Question
% Under section 151(d)(3)(A), Alice's exemption amount is reduced to $1800. Entailment

% Facts
:- discontiguous s151_c/4.
:- [statutes/prolog/init].
s151_c("Alice",_,2000,2015).
income_(span("income",8,13)).
agent_(span("income",8,13),span("Alice",0,4)).
start_(span("income",8,13),span(20150101,18,21)).
amount_(span("income",8,13),span(260932,28,33)).

% Test
:- s151_d_3_A("Alice",_,_,_,2000,1800,2015).
:- halt.
