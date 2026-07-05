% Text
% Bob and Alice got married on Feb 3rd, 1992. Bob and Alice have a child, Charlie, born October 9th, 2000. Bob died on July 9th, 2014. From 2004 to 2019, Alice furnished the costs of maintaining the home where she and Charlie lived during that time. Alice's gross income for the year 2017 is $25561. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $2574

% Facts
:- [statutes/prolog/init].
alice_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2004,2019,Year),
    atom_concat("furnished the costs ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,158,166)) :- alice_household_maintenance(_,Event,_,_).
agent_(span(Event,158,166),span("Alice",152,156)) :- alice_household_maintenance(_,Event,_,_).
amount_(span(Event,158,166),span(1,168,170)) :- alice_household_maintenance(_,Event,_,_).
purpose_(span(Event,158,166),span("home",197,200)) :- alice_household_maintenance(_,Event,_,_).
start_(span(Event,158,166),span(Start_day,138,141)) :- alice_household_maintenance(_,Event,Start_day,_).
end_(span(Event,158,166),span(End_day,146,149)) :- alice_household_maintenance(_,Event,_,End_day).
marriage_(span("married",18,24)).
son_(span("child",65,69)).
death_(span("died",109,112)).
residence_(span("lived",224,228)).
income_(span("income",262,267)).
agent_(span("died",109,112),span("Bob",105,107)).
start_(span("died",109,112),span(20140709,117,130)).
agent_(span("income",262,267),span("Alice",248,252)).
start_(span("income",262,267),span(20170101,282,285)).
amount_(span("income",262,267),span(25561,291,295)).
agent_(span("married",18,24),span("Bob",0,2)).
agent_(span("married",18,24),span("Alice",8,12)).
start_(span("married",18,24),span(19920203,29,41)).
start_(span("lived",224,228),span(20040101,138,141)).
end_(span("lived",224,228),span(20191231,146,149)).
agent_(span("lived",224,228),span("Alice",152,156)).
patient_(span("lived",224,228),span("home",197,200)).
agent_(span("lived",224,228),span("Charlie",216,222)).
patient_(span("child",65,69),span("Bob",44,46)).
patient_(span("child",65,69),span("Alice",52,56)).
agent_(span("child",65,69),span("Charlie",72,78)).
start_(span("child",65,69),span(20001009,86,102)).
birth_(span("born",81,84)).
agent_(span("born",81,84),span("Charlie",72,78)).
start_(span("born",81,84),span(20001009,86,102)).

% Test
:- tax("Alice",2017,2574).
:- halt.
