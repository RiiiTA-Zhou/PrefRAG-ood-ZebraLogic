% Text
% Alice has a son, Bob, who satisfies section 152(c)(1) for the year 2015.

% Question
% Under section 152(a), Bob is a dependent of Alice for the year 2015. Entailment

% Facts
:- discontiguous s152_c_1/3.
:- [statutes/prolog/init].
s152_c_1("Bob","Alice",2015).
son_(span("son", 12, 14)).
agent_(span("son", 12, 14), span("Bob", 17, 19)).
patient_(span("son", 12, 14), span("Alice", 0, 4)).

% Test
:- s152_a("Bob","Alice",2015,_,_).
:- halt.
