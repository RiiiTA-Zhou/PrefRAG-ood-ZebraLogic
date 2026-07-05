% Text
% In 2017, Alice was paid $75845. Alice has a son, Bob. From September 1st, 2015 to November 3rd, 2019, Alice and Bob lived in the same home, which Alice maintained. In 2017, Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $15037

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
son_(span("son",44,46)).
residence_(span("lived",116,120)).
payment_(span("maintained",152,161)).
start_(span("maintained",152,161),span(20150901,59,77)).
start_(span("maintained",152,161),span(20160101,59,77)).
start_(span("maintained",152,161),span(20170101,59,77)).
start_(span("maintained",152,161),span(20180101,59,77)).
start_(span("maintained",152,161),span(20190101,96,99)).
purpose_(span("maintained",152,161),span("home",134,137)).
agent_(span("maintained",152,161),span("Alice",146,150)).
amount_(span("maintained",152,161),span(1,152,161)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(75845,25,29)).
start_(span("lived",116,120),span(20150901,59,77)).
end_(span("lived",116,120),span(20191103,82,99)).
agent_(span("lived",116,120),span("Alice",102,106)).
agent_(span("lived",116,120),span("Bob",112,114)).
patient_(span("lived",116,120),span("home",134,137)).
patient_(span("son",44,46),span("Alice",32,36)).
agent_(span("son",44,46),span("Bob",49,51)).

% Test
:- tax("Alice",2017,15037).
:- halt.
