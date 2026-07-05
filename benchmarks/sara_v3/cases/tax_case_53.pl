% Text
% Alice has a brother, Bob, who was born January 31st, 2014. Alice's gross income in 2020 was $604312. Alice married Charlie on October 12th, 1992. Charlie had no income in 2020. Alice and Charlie file jointly and take the standard deduction.

% Question
% How much tax does Alice have to pay in 2020? $206332

% Facts
:- [statutes/prolog/init].
brother_(span("brother",12,18)).
patient_(span("brother",12,18),span("Alice",0,4)).
agent_(span("brother",12,18),span("Bob",21,23)).
start_(span("brother",12,18),span(20140131,39,56)).
income_(span("income",73,78)).
agent_(span("income",73,78),span("Alice",59,63)).
start_(span("income",73,78),span(20200101,83,86)).
amount_(span("income",73,78),span(604312,93,98)).
marriage_(span("married",107,113)).
agent_(span("married",107,113),span("Alice",101,105)).
agent_(span("married",107,113),span("Charlie",115,121)).
start_(span("married",107,113),span(19921012,126,143)).
joint_return_(span("file jointly",195,206)).
start_(span("file jointly",195,206),span(20200101,171,174)).
agent_(span("file jointly",195,206),span("Alice",177,181)).
agent_(span("file jointly",195,206),span("Charlie",187,193)).
birth_(span("born",34,37)).
agent_(span("born",34,37),span("Bob",21,23)).
start_(span("born",34,37),span(20140131,39,56)).

% Test
:- tax("Alice",2020,206332).
:- halt.
