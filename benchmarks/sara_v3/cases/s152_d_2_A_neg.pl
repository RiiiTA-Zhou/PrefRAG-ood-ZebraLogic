% Text
% Bob is Alice's brother since April 15th, 2014.

% Question
% Alice bears a relationship to Bob under section 152(d)(2)(A). Contradiction

% Facts
:- [statutes/prolog/init].
brother_(span("brother",15,21)).
agent_(span("brother",15,21),span("Bob",0,2)).
patient_(span("brother",15,21),span("Alice",7,11)).
start_(span("brother",15,21),span(20140415,29,44)).

% Test
:- \+ s152_d_2_A("Alice","Bob",_,_).
:- halt.
