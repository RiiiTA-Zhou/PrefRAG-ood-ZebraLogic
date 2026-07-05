% Text
% Alice and Charlie have a son, Bob. From September 1st, 2015 to November 3rd, 2019, Alice, Bob and Charlie lived in the same home. Alice and Charlie got married on Feb 3rd, 1992. Alice is a nonresident alien. In 2018, Alice earned $643531. Charlie had no income in 2018. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2018? $243103

% Facts
:- [statutes/prolog/init].
son_(span("son",25,27)).
residence_(span("lived",106,110)).
marriage_(span("married",152,158)).
nonresident_alien_(span("nonresident alien",189,205)).
income_(span("earned",223,228)).
agent_(span("earned",223,228),span("Alice",217,221)).
amount_(span("earned",223,228),span(643531,231,236)).
start_(span("earned",223,228),span(20180101,211,214)).
agent_(span("married",152,158),span("Alice",130,134)).
agent_(span("married",152,158),span("Charlie",140,146)).
start_(span("married",152,158),span(19920203,163,175)).
agent_(span("nonresident alien",189,205),span("Alice",178,182)).
start_(span("lived",106,110),span(20150901,40,58)).
end_(span("lived",106,110),span(20191103,63,80)).
agent_(span("lived",106,110),span("Bob",90,92)).
agent_(span("lived",106,110),span("Charlie",98,104)).
patient_(span("lived",106,110),span("home",124,127)).
agent_(span("lived",106,110),span("Alice",83,87)).
patient_(span("son",25,27),span("Alice",0,4)).
patient_(span("son",25,27),span("Charlie",10,16)).
agent_(span("son",25,27),span("Bob",30,32)).

% Test
:- tax("Alice",2018,243103).
:- halt.
