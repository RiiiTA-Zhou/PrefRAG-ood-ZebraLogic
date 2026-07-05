% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice and Bob have a child, Charlie, born October 9th, 2000. Alice died on July 9th, 2014. From 2004 to 2019, Bob furnished 40% of the costs of maintaining the home where he and Charlie lived during that time. In 2013, Alice and Bob filed jointly, and took the standard deduction. In 2013, Alice earned $65400 and Bob earned $56400.

% Question
% How much tax does Alice have to pay in 2013? $26567

% Facts
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2004,2019,Year),
    atom_concat("furnished 40% of the costs ",Year,Event_name),
    Event = span(Event_name,158,166),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(Event) :- bob_household_maintenance(_,Event,_,_).
agent_(Event,span("Bob",154,157)) :- bob_household_maintenance(_,Event,_,_).
amount_(Event,span(40,168,169)) :- bob_household_maintenance(_,Event,_,_).
purpose_(Event,span("home",204,207)) :- bob_household_maintenance(_,Event,_,_).
start_(Event,span(Start_day,140,143)) :- bob_household_maintenance(_,Event,Start_day,_).
end_(Event,span(End_day,148,151)) :- bob_household_maintenance(_,Event,_,End_day).
someone_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2004,2019,Year),
    atom_concat("maintaining the home ",Year,Event_name),
    Event = span(Event_name,158,166),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(Event) :- someone_household_maintenance(_,Event,_,_).
agent_(Event,span("someone",154,157)) :- someone_household_maintenance(_,Event,_,_).
amount_(Event,span(60,168,169)) :- someone_household_maintenance(_,Event,_,_).
purpose_(Event,span("home",204,207)) :- someone_household_maintenance(_,Event,_,_).
start_(Event,span(Start_day,140,143)) :- someone_household_maintenance(_,Event,Start_day,_).
end_(Event,span(End_day,148,151)) :- someone_household_maintenance(_,Event,_,End_day).
marriage_(span("married",18,24)).
son_(span("child",65,69)).
death_(span("died",111,114)).
residence_(span("lived",230,234)).
joint_return_(span("jointly",283,289)).
income_(span("earned",340,345)).
income_(span("earned",362,367)).
agent_(span("died",111,114),span("Alice",105,109)).
start_(span("died",111,114),span(20140709,119,132)).
start_(span("earned",340,345),span(20130101,328,331)).
agent_(span("earned",340,345),span("Alice",334,338)).
amount_(span("earned",340,345),span(65400,348,352)).
start_(span("earned",362,367),span(20130101,328,331)).
agent_(span("earned",362,367),span("Bob",358,360)).
amount_(span("earned",362,367),span(56400,370,374)).
start_(span("jointly",283,289),span(20130101,257,260)).
agent_(span("jointly",283,289),span("Alice",263,267)).
agent_(span("jointly",283,289),span("Bob",273,275)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).
start_(span("lived",230,234),span(20040101,140,143)).
end_(span("lived",230,234),span(20191231,148,151)).
agent_(span("lived",230,234),span("Bob",154,156)).
patient_(span("lived",230,234),span("home",204,207)).
agent_(span("lived",230,234),span("Charlie",222,228)).
patient_(span("child",65,69),span("Alice",44,48)).
patient_(span("child",65,69),span("Bob",54,56)).
agent_(span("child",65,69),span("Charlie",72,78)).
start_(span("child",65,69),span(20001009,86,102)).
birth_(span("born",81,84)).
agent_(span("born",81,84),span("Charlie",72,78)).
start_(span("born",81,84),span(20001009,86,102)).

% Test
:- tax("Alice",2013,26567).
:- halt.
