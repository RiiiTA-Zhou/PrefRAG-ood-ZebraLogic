% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice died on July 9th, 2014. From 2004 to 2019, Bob furnished the costs of maintaining the home where he and his father Charlie lived during that time. Bob is entitled to a deduction for Charlie under section 151(c) for the years 2015 to 2019. Bob was a nonresident alien until Feb 12, 2018.

% Question
% Section 2(b)(3)(A) applies to Bob in 2018. Entailment

% Facts
:- discontiguous s151_c_applies/3.
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2004,2019,Year),
    atom_concat("furnished the costs of maintaining the home ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,97,105)) :- bob_household_maintenance(_,Event,_,_).
agent_(span(Event,97,105),span("Bob",93,95)) :- bob_household_maintenance(_,Event,_,_).
amount_(span(Event,97,105),span(1,107,109)) :- bob_household_maintenance(_,Event,_,_).
purpose_(span(Event,97,105),span("home",136,139)) :- bob_household_maintenance(_,Event,_,_).
start_(span(Event,97,105),span(Start_day,79,82)) :- bob_household_maintenance(_,Event,Start_day,_).
end_(span(Event,97,105),span(End_day,87,90)) :- bob_household_maintenance(_,Event,_,End_day).
s151_c_applies("Bob","Charlie",Year) :- between(2015,2019,Year).
marriage_(span("married",18,24)).
death_(span("died",50,53)).
father_(span("father",158,163)).
residence_(span("lived",173,177)).
nonresident_alien_(span("nonresident alien",299,315)).
agent_(span("died",50,53),span("Alice",44,48)).
start_(span("died",50,53),span(20140709,58,71)).
patient_(span("father",158,163),span("Bob",93,95)).
agent_(span("father",158,163),span("Charlie",165,171)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).
agent_(span("nonresident alien",299,315),span("Bob",289,291)).
end_(span("nonresident alien",299,315),span(20180212,323,334)).
start_(span("lived",173,177),span(20040101,79,82)).
agent_(span("lived",173,177),span("Bob",93,95)).
patient_(span("lived",173,177),span("home",136,139)).
agent_(span("lived",173,177),span("Charlie",165,171)).
end_(span("lived",173,177),span(20191231,87,90)).

% Test
:- s2_b_3_A("Bob",2018,_).
:- halt.
