% Text
% Alice and Bob got married on Feb 3rd, 2013. Alice died on July 9th, 2014. Alice was a nonresident alien. From 2004 to 2019, Bob furnished the costs of maintaining the home where he and his father Charlie lived during that time. Charlie had no income from 2015 to 2019. Bob's gross income in 2015 was $678323. Bob takes the standard deduction in 2015.

% Question
% How much tax does Bob have to pay in 2015? $245359

% Facts
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2004,2019,Year),
    atom_concat("furnished the costs ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,128,136)) :- bob_household_maintenance(_,Event,_,_).
agent_(span(Event,128,136),span("Bob",124,126)) :- bob_household_maintenance(_,Event,_,_).
amount_(span(Event,128,136),span(1,138,140)) :- bob_household_maintenance(_,Event,_,_).
purpose_(span(Event,128,136),span("home",167,170)) :- bob_household_maintenance(_,Event,_,_).
start_(span(Event,128,136),span(Start_day,110,113)) :- bob_household_maintenance(_,Event,Start_day,_).
end_(span(Event,128,136),span(End_day,118,121)) :- bob_household_maintenance(_,Event,_,End_day).
marriage_(span("married",18,24)).
death_(span("died",50,53)).
nonresident_alien_(span("nonresident alien",86,102)).
father_(span("father",189,194)).
residence_(span("lived",204,208)).
income_(span("income",281,286)).
agent_(span("died",50,53),span("Alice",44,48)).
start_(span("died",50,53),span(20140709,58,71)).
agent_(span("father",189,194),span("Bob",124,126)).
patient_(span("father",189,194),span("Charlie",196,202)).
agent_(span("income",281,286),span("Bob",269,271)).
start_(span("income",281,286),span(20150101,291,294)).
amount_(span("income",281,286),span(678323,301,306)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(20130203,29,41)).
agent_(span("nonresident alien",86,102),span("Alice",74,78)).
start_(span("lived",204,208),span(20040101,110,113)).
agent_(span("lived",204,208),span("Bob",124,126)).
patient_(span("lived",204,208),span("home",167,170)).
agent_(span("lived",204,208),span("Charlie",196,202)).
end_(span("lived",204,208),span(20191231,118,121)).

% Test
:- tax("Bob",2015,245359).
:- halt.
