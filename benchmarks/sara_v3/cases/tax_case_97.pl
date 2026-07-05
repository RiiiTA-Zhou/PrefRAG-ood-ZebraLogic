% Text
% Alice has paid $4512 to Bob for work done from Feb 1st, 2005 to Sep 2nd, 2005. In 2005, Alice was paid $133200. Alice is allowed itemized deductions of $2939 and $8744.

% Question
% How much tax does Alice have to pay in 2005? $33069

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("work",32,35)).
payment_(span("paid",98,101)).
deduction_(span("$2939",152,156)).
deduction_(span("$8744",162,166)).
start_(span("$2939",152,156),span(20050101,82,85)).
agent_(span("$2939",152,156),span("Alice",112,116)).
amount_(span("$2939",152,156),span(2939,153,156)).
start_(span("$8744",162,166),span(20050101,82,85)).
agent_(span("$8744",162,166),span("Alice",112,116)).
amount_(span("$8744",162,166),span(8744,163,166)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(4512,16,19)).
patient_(span("paid",10,13),span("Bob",24,26)).
purpose_(span("paid",10,13),span("work",32,35)).
start_(span("paid",10,13),span(20050902,64,76)).
start_(span("paid",98,101),span(20050101,82,85)).
patient_(span("paid",98,101),span("Alice",88,92)).
amount_(span("paid",98,101),span(133200,104,109)).
patient_(span("work",32,35),span("Alice",0,4)).
agent_(span("work",32,35),span("Bob",24,26)).
start_(span("work",32,35),span(20050201,47,59)).
end_(span("work",32,35),span(20050902,64,76)).

% Test
:- tax("Alice",2005,33069).
:- halt.
