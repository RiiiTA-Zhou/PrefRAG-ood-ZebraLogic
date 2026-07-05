% Text
% Alice and Bob started living together on April 15th, 2014. Alice and Bob are not related, nor do they have relatives married to one another.

% Question
% Alice bears a relationship to Bob under section 152(d)(2)(G) for the year 2018. Contradiction

% Facts
:- [statutes/prolog/init].
residence_(span("living",22,27)).
agent_(span("living",22,27),span("Alice",0,4)).
agent_(span("living",22,27),span("Bob",10,12)).
patient_(span("living",22,27),span("living",22,27)).
start_(span("living",22,27),span(20140415,41,56)).

% Test
:- \+ s152_d_2_G("Alice","Bob",_,_).
:- halt.
