% Text
% Alice and Bob were married from Feb 3rd, 1997 to Oct 30th, 2001. Alice's gross income for the year 2014 is $718791 and she takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2014? $264225

% Facts
:- [statutes/prolog/init].
marriage_(span("married",19,25)).
income_(span("income",79,84)).
agent_(span("income",79,84),span("Alice",65,69)).
start_(span("income",79,84),span(20140101,99,102)).
amount_(span("income",79,84),span(718791,108,113)).
agent_(span("married",19,25),span("Alice",0,4)).
agent_(span("married",19,25),span("Bob",10,12)).
start_(span("married",19,25),span(19970203,32,44)).
end_(span("married",19,25),span(20011030,49,62)).

% Test
:- tax("Alice",2014,264225).
:- halt.
