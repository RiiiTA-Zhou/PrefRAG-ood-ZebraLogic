% Text
% Alice's income in 2015 is $395276. The applicable amount according to section 68(b) is $250000.
%
% Question
% Under section 151(d)(3)(B), the applicable percentage for Alice for 2015 is equal to 118. Contradiction

% Facts
:- discontiguous s68_b/3.
:- [statutes/prolog/init].
s68_b("Alice",250000,2015).
income_(span("income",8,13)).
agent_(span("income",8,13),span("Alice",0,4)).
start_(span("income",8,13),span(20150101,18,21)).
amount_(span("income",8,13),span(395276,27,32)).

% Test
:- \+ s151_d_3_B(118,"Alice",_,2015,_).
:- halt.
