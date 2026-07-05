% Text
% Alice has a son, Bob, who satisfies section 152(c)(1) for the year 2015. Bob has a son, Charlie, who satisfies section 152(c)(1) for the year 2015. Alice's income in 2015 was $504598. Bob had no income in 2015.

% Question
% Section 152(b)(1) applies to Alice for the year 2015. Contradiction

% Facts
:- discontiguous s152_c_1/3.
:- [statutes/prolog/init].
s152_c_1("Bob","Alice",2015).
s152_c_1("Charlie","Bob",2015).
son_(span("son",12,14)).
agent_(span("son",12,14),span("Bob",17,19)).
patient_(span("son",12,14),span("Alice",0,4)).
son_(span("son",83,85)).
patient_(span("son",83,85),span("Bob",73,75)).
agent_(span("son",83,85),span("Charlie",88,94)).
income_(span("income",156,161)).
agent_(span("income",156,161),span("Alice",148,152)).
start_(span("income",156,161),span(20150101,166,169)).
amount_(span("income",156,161),span(504598,176,181)).

% Test
:- \+ s152_b_1("Alice",_,2015).
:- halt.
