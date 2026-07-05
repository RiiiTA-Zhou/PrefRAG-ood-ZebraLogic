% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice died on July 9th, 2014. From 2015 to 2019, Bob furnished the costs of maintaining the home where he and his friend Charlie lived during that time, while Charlie had no income and was not the qualifying child of any taxpayer. Bob earned $304598 every year from 2015 to 2019.

% Question
% How much tax does Bob have to pay in 2018? $96641

% Facts
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2015,2019,Year),
    atom_concat("furnished the costs ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,97,105)) :- bob_household_maintenance(_,Event,_,_).
agent_(span(Event,97,105),span("Bob",93,95)) :- bob_household_maintenance(_,Event,_,_).
amount_(span(Event,97,105),span(1,107,109)) :- bob_household_maintenance(_,Event,_,_).
purpose_(span(Event,97,105),span("home",136,139)) :- bob_household_maintenance(_,Event,_,_).
start_(span(Event,97,105),span(Start_day,79,82)) :- bob_household_maintenance(_,Event,Start_day,_).
end_(span(Event,97,105),span(End_day,87,90)) :- bob_household_maintenance(_,Event,_,End_day).
bob_income(Year,Event,Day) :-
    between(2015,2019,Year),
    atom_concat("bob_income_",Year,Event),
    last_day_year(Year,Day).
income_(span(Event,279,284)) :- bob_income(_,Event,_).
agent_(span(Event,279,284),span("Bob",275,277)) :- bob_income(_,Event,_).
amount_(span(Event,279,284),span(304598,287,292)) :- bob_income(_,Event,_).
start_(span(Event,279,284),span(Day,310,313)) :- bob_income(_,Event,Day).
marriage_(span("married",18,24)).
death_(span("died",50,53)).
residence_(span("lived",173,177)).
agent_(span("died",50,53),span("Alice",44,48)).
start_(span("died",50,53),span(20140709,58,71)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).
start_(span("lived",173,177),span(20150101,79,82)).
end_(span("lived",173,177),span(20191231,87,90)).
agent_(span("lived",173,177),span("Bob",93,95)).
patient_(span("lived",173,177),span("home",136,139)).
agent_(span("lived",173,177),span("Charlie",165,171)).

% Test
:- tax("Bob",2018,96641).
:- halt.
