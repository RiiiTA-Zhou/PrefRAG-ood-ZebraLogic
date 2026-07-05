% Text
% Alice and Bob got married on Feb 3rd, 1992. Bob has a brother, Charlie, born October 9th, 2000. Alice died on July 9th, 2014. From 2004 to 2019, Bob furnished the costs of maintaining the home where he and Charlie lived during that time. In 2017, Charlie earned $312489. In 2017, Charlie filed a joint return with his spouse whom he married on Dec 1st, 2016.

% Question
% Section 2(b)(1)(A)(ii) applies to Charlie as the dependent in 2017. Contradiction

% Facts
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2004,2019,Year),
    atom_concat("furnished the costs of maintaining the home ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,149,157)) :- bob_household_maintenance(_,Event,_,_).
agent_(span(Event,149,157),span("Bob",145,147)) :- bob_household_maintenance(_,Event,_,_).
amount_(span(Event,149,157),span(1,159,161)) :- bob_household_maintenance(_,Event,_,_).
purpose_(span(Event,149,157),span("home",188,191)) :- bob_household_maintenance(_,Event,_,_).
start_(span(Event,149,157),span(Start_day,131,134)) :- bob_household_maintenance(_,Event,Start_day,_).
end_(span(Event,149,157),span(End_day,139,142)) :- bob_household_maintenance(_,Event,_,End_day).
marriage_(span("married",18,24)).
brother_(span("brother",54,60)).
death_(span("died",102,105)).
residence_(span("lived",214,218)).
income_(span("earned",255,260)).
joint_return_(span("joint return",296,307)).
marriage_(span("married",333,339)).
agent_(span("died",102,105),span("Alice",96,100)).
start_(span("died",102,105),span(20140709,110,123)).
agent_(span("earned",255,260),span("Charlie",247,253)).
amount_(span("earned",255,260),span(312489,263,268)).
start_(span("earned",255,260),span(20170101,241,244)).
start_(span("joint return",296,307),span(20170101,274,277)).
agent_(span("joint return",296,307),span("Charlie",280,286)).
agent_(span("joint return",296,307),span("spouse",318,323)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).
agent_(span("married",333,339),span("Charlie",280,286)).
agent_(span("married",333,339),span("spouse",318,323)).
start_(span("married",333,339),span(20161201,344,356)).
start_(span("lived",214,218),span(20040101,131,134)).
end_(span("lived",214,218),span(20191231,139,142)).
agent_(span("lived",214,218),span("Bob",145,147)).
patient_(span("lived",214,218),span("home",188,191)).
agent_(span("lived",214,218),span("Charlie",206,212)).
patient_(span("brother",54,60),span("Bob",44,46)).
agent_(span("brother",54,60),span("Charlie",63,69)).
start_(span("brother",54,60),span(20001009,77,93)).
birth_(span("born",72,75)).
agent_(span("born",72,75),span("Charlie",63,69)).
start_(span("born",72,75),span(20001009,77,93)).

% Test
:- \+ s2_b_1_A_ii(_,"Charlie",2017).
:- halt.
