% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice died on July 9th, 2014. From 2015 to 2019, Bob furnished the costs of maintaining the home where he and his friend Charlie lived during that time. Charlie is a dependent of Bob under section 152(d)(2)(H) for the years 2015 to 2019. Bob earned $300000 every year from 2015 to 2019.

% Question
% Section 2(b)(3)(B) applies to Bob as the taxpayer and Charlie as the individual in 2018. Entailment

% Facts
:- discontiguous s152_d_2_H/6.
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2015,2019,Year),
    atom_concat("furnished the costs of maintaining the home ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,97,105)) :- bob_household_maintenance(_,Event,_,_).
agent_(span(Event,97,105),span("Bob",93,95)) :- bob_household_maintenance(_,Event,_,_).
amount_(span(Event,97,105),span(1,107,109)) :- bob_household_maintenance(_,Event,_,_).
purpose_(span(Event,97,105),span("home",136,139)) :- bob_household_maintenance(_,Event,_,_).
start_(span(Event,97,105),span(Start_day,79,82)) :- bob_household_maintenance(_,Event,Start_day,_).
end_(span(Event,97,105),span(End_day,87,90)) :- bob_household_maintenance(_,Event,_,End_day).
s152_d_2_H("Charlie","Bob",Year,_,Start_day,End_day) :-
    between(2015,2019,Year),first_day_year(Year,Start_day),last_day_year(Year,End_day).
bob_income(Year,Event,Start_day,End_day) :-
    between(2015,2019,Year),
    atom_concat("earned ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
income_(span(Event,286,291)) :- bob_income(_,Event,_,_).
agent_(span(Event,286,291),span("Bob",282,284)) :- bob_income(_,Event,_,_).
amount_(span(Event,286,291),span(300000,294,299)) :- bob_income(_,Event,_,_).
start_(span(Event,286,291),span(Start_day,317,320)) :- bob_income(_,Event,Start_day,_).
marriage_(span("married",18,24)).
death_(span("died",50,53)).
residence_(span("lived",173,177)).
agent_(span("died",50,53),span("Alice",44,48)).
start_(span("died",50,53),span(20140709,58,71)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).
agent_(span("lived",173,177),span("Bob",93,95)).
patient_(span("lived",173,177),span("home",136,139)).
agent_(span("lived",173,177),span("Charlie",165,171)).
start_(span("lived",173,177),span(20150101,79,82)).
end_(span("lived",173,177),span(20191231,87,90)).

% Test
:- s2_b_3_B("Bob","Charlie",2018).
:- halt.
