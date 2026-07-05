% Text
% Bob is Alice's son since April 15th, 2014.

% Question
% Alice bears a relationship to Bob under section 152(d)(2)(B) for the year 2015. Contradiction

% Facts
:- [statutes/prolog/init].
son_(span("son",15,17)).
agent_(span("son",15,17),span("Bob",0,2)).
patient_(span("son",15,17),span("Alice",7,11)).
start_(span("son",15,17),span(20140415,25,40)).

% Test
:- \+ s152_d_2_B("Alice","Bob",_,_).
:- halt.
