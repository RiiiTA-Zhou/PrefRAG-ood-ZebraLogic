% Text
% Alice's income for the year 2003 is $54313. Alice and Bob have been married since Feb 3rd, 1985. Bob had no income in 2003. Bob and Alice file a joint return for 2003 and take the standard deduction.

% Question
% How much tax does Alice have to pay in 2003? $7611

% Facts
:- [statutes/prolog/init].
income_(span("income",8,13)).
marriage_(span("married",68,74)).
joint_return_(span("joint return",145,156)).
agent_(span("income",8,13),span("Alice",0,4)).
start_(span("income",8,13),span(20030101,28,31)).
amount_(span("income",8,13),span(54313,37,41)).
agent_(span("joint return",145,156),span("Bob",124,126)).
agent_(span("joint return",145,156),span("Alice",132,136)).
start_(span("joint return",145,156),span(20030101,162,165)).
agent_(span("married",68,74),span("Alice",44,48)).
agent_(span("married",68,74),span("Bob",54,56)).
start_(span("married",68,74),span(19850203,82,94)).

% Test
:- tax("Alice",2003,7611).
:- halt.
