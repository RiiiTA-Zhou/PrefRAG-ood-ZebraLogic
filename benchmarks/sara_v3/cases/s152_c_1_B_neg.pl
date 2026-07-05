% Text
% Alice has a son, Bob. From September 1st, 2015 to November 3rd, 2019, Alice and Bob lived in the same home.

% Question
% Section 152(c)(1)(B) applies to Bob with Alice as the taxpayer for the year 2015. Contradiction

% Facts
:- [statutes/prolog/init].
son_(span("son",12,14)).
residence_(span("lived",84,88)).
start_(span("lived",84,88),span(20150901,27,45)).
end_(span("lived",84,88),span(20191103,50,67)).
agent_(span("lived",84,88),span("Alice",70,74)).
agent_(span("lived",84,88),span("Bob",80,82)).
patient_(span("lived",84,88),span("home",102,105)).
patient_(span("son",12,14),span("Alice",0,4)).
agent_(span("son",12,14),span("Bob",17,19)).

% Test
:- \+ s152_c_1_B("Bob",_,"Alice",_,_,2015).
:- halt.
