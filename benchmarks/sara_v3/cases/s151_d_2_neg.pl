% Text
% Alice is entitled to an exemption under section 151(d) for Bob for the year 2015.

% Question
% Under section 151(d)(2), Bob's exemption amount for the year 2015 is equal to $2000. Contradiction

% Facts
:- discontiguous s151_d/4.
:- [statutes/prolog/init].
s151_d("Alice","Bob",_,2015).

% Test
:- \+ s151_d_2("Bob",_,2000,2015).
:- halt.
