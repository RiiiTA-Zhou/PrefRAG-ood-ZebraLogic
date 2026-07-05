% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice and Bob have a child, Charlie, born October 9th, 2000. Alice died on July 9th, 2014. From 2004 to 2018, Bob furnished the costs of maintaining the home where he and Charlie lived during that time. Charlie married Dan on Feb 14th, 2018, and they file a joint return that same year. Bob's gross income in 2018 was $132268. Bob takes the standard deduction.

% Question
% How much tax does Bob have to pay in 2018? $33068

% Facts
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2004,2018,Year),
    atom_concat("furnished the costs ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,181,191)) :- bob_household_maintenance(_,Event,_,_).
agent_(span(Event,181,191),span("Bob",154,156)) :- bob_household_maintenance(_,Event,_,_).
amount_(span(Event,181,191),span(1,181,191)) :- bob_household_maintenance(_,Event,_,_).
purpose_(span(Event,181,191),span("home",197,200)) :- bob_household_maintenance(_,Event,_,_).
start_(span(Event,181,191),span(Start_day,140,143)) :- bob_household_maintenance(_,Event,Start_day,_).
end_(span(Event,181,191),span(End_day,148,151)) :- bob_household_maintenance(_,Event,_,End_day).
marriage_(span("married",18,24)).
son_(span("child",65,69)).
death_(span("died",111,114)).
residence_(span("lived",223,227)).
marriage_(span("married",255,261)).
joint_return_(span("joint return",302,313)).
income_(span("income",343,348)).
agent_(span("died",111,114),span("Alice",105,109)).
start_(span("died",111,114),span(20140709,119,132)).
agent_(span("income",343,348),span("Bob",331,333)).
start_(span("income",343,348),span(20180101,353,356)).
amount_(span("income",343,348),span(132268,363,368)).
agent_(span("joint return",302,313),span("Charlie",247,253)).
agent_(span("joint return",302,313),span("Dan",263,265)).
start_(span("joint return",302,313),span(20180101,280,283)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).
agent_(span("married",255,261),span("Charlie",247,253)).
agent_(span("married",255,261),span("Dan",263,265)).
start_(span("married",255,261),span(20180214,270,283)).
start_(span("lived",223,227),span(20040101,140,143)).
end_(span("lived",223,227),span(20181231,148,151)).
agent_(span("lived",223,227),span("Bob",154,156)).
patient_(span("lived",223,227),span("home",197,200)).
agent_(span("lived",223,227),span("Charlie",215,221)).
patient_(span("child",65,69),span("Alice",44,48)).
patient_(span("child",65,69),span("Bob",54,56)).
agent_(span("child",65,69),span("Charlie",72,78)).
start_(span("child",65,69),span(20001009,86,102)).
birth_(span("born",81,84)).
agent_(span("born",81,84),span("Charlie",72,78)).
start_(span("born",81,84),span(20001009,86,102)).

% Test
:- tax("Bob",2018,33068).
:- halt.
