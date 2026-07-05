% Text
% Alice has a brother, Bob. Bob is a qualifying child of Charlie for the year 2014 under section 152(c)(1).

% Question
% Under section 152(a), Bob is a dependent of Alice for the year 2014. Contradiction

% Facts
:- discontiguous s152_c_1/3.
:- [statutes/prolog/init].
s152_c_1("Bob","Charlie",2014).
brother_(span("brother",12,18)).
agent_(span("brother",12,18), span("Bob",21,23)).
patient_(span("brother",12,18), span("Alice",0,4)).

% Test
:- \+ s152_a("Bob","Alice",2014,_,_).
:- halt.
