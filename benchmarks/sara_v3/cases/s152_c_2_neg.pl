% Text
% Alice has a son, Bob, who was born January 31st, 2014.

% Question
% Alice bears a relationship to Bob under section 152(c)(2). Contradiction

% Facts
:- [statutes/prolog/init].
son_(span("son",12,14)).
patient_(span("son",12,14),span("Alice",0,4)).
agent_(span("son",12,14),span("Bob",17,19)).
start_(span("son",12,14),span(20140131,35,52)).
birth_(span("born",30,33)).
agent_(span("born",30,33),span("Bob",17,19)).
start_(span("born",30,33),span(20140131,35,52)).

% Test
:- \+ s152_c_2("Alice","Bob",_,_).
:- halt.
