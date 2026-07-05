% Text
% Alice has a brother, Bob, who was born January 31st, 2014.

% Question
% Bob bears a relationship to Alice under section 152(c)(2)(B). Entailment

% Facts
:- [statutes/prolog/init].
brother_(span("brother",12,18)).
patient_(span("brother",12,18),span("Alice",0,4)).
agent_(span("brother",12,18),span("Bob",21,23)).
start_(span("brother",12,18),span(20140131,39,56)).
birth_(span("born",34,37)).
agent_(span("born",34,37),span("Bob",21,23)).
start_(span("born",34,37),span(20140131,39,56)).

% Test
:- s152_c_2_B("Bob","Alice",_,_,_).
:- halt.
