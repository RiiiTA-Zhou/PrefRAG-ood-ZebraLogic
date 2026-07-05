% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice and Bob have a child, Charlie, born October 9th, 2000. Alice died on July 9th, 2014. From 2004 to 2019, Bob furnished 40% of the costs of maintaining the home where he and Charlie lived during that time. Charlie is not the dependent of Bob under section 152(b)(2).

% Question
% Section 2(b)(1)(A) applies to Bob in 2018. Contradiction

% Facts
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2004,2019,Year),
    atom_concat("furnished 40% of the costs of maintaining the home ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,158,166)) :- bob_household_maintenance(_,Event,_,_).
agent_(span(Event,158,166),span("Bob",154,156)) :- bob_household_maintenance(_,Event,_,_).
amount_(span(Event,158,166),span(40,168,169)) :- bob_household_maintenance(_,Event,_,_).
purpose_(span(Event,158,166),span("home",204,207)) :- bob_household_maintenance(_,Event,_,_).
start_(span(Event,158,166),span(Start_day,140,143)) :- bob_household_maintenance(_,Event,Start_day,_).
end_(span(Event,158,166),span(End_day,148,151)) :- bob_household_maintenance(_,Event,_,End_day).
someone_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2004,2019,Year),
    atom_concat("the costs of maintaining the home ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,179,183)) :- someone_household_maintenance(_,Event,_,_).
agent_(span(Event,179,183),span("someone",154,156)) :- someone_household_maintenance(_,Event,_,_).
amount_(span(Event,179,183),span(60,168,170)) :- someone_household_maintenance(_,Event,_,_).
purpose_(span(Event,179,183),span("home",204,207)) :- someone_household_maintenance(_,Event,_,_).
start_(span(Event,179,183),span(Start_day,140,143)) :- someone_household_maintenance(_,Event,Start_day,_).
end_(span(Event,179,183),span(End_day,148,151)) :- someone_household_maintenance(_,Event,_,End_day).
marriage_(span("married",18,24)).
son_(span("child",65,69)).
death_(span("died",111,114)).
residence_(span("lived",230,234)).
agent_(span("died",111,114),span("Alice",105,109)).
start_(span("died",111,114),span(20140709,119,132)).
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
:- \+ s2_b_1_A("Bob",_,_,2018).
:- halt.
