% Text
% Alice's and Bob's gross incomes for the year 2013 are $71879 and $11213 respectively. Alice and Bob got married on Feb 3rd, 1992. Alice and Bob have a child, Charlie, born October 9th, 2000. From 2004 to 2019, Bob furnished 40% of the costs of maintaining the home where he and Charlie lived during that time, and Alice furnished the remaining costs. In 2013, Alice and Bob file jointly and take the standard deduction.

% Question
% How much tax does Alice have to pay in 2013? $15109

% Facts
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2004,2019,Year),
    atom_concat("furnished 40% of the costs ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,214,222)) :- bob_household_maintenance(_,Event,_,_).
agent_(span(Event,214,222),span("Bob",210,212)) :- bob_household_maintenance(_,Event,_,_).
amount_(span(Event,214,222),span(40,224,225)) :- bob_household_maintenance(_,Event,_,_).
purpose_(span(Event,214,222),span("home",260,263)) :- bob_household_maintenance(_,Event,_,_).
start_(span(Event,214,222),span(Start_day,196,199)) :- bob_household_maintenance(_,Event,Start_day,_).
end_(span(Event,214,222),span(End_day,204,207)) :- bob_household_maintenance(_,Event,_,End_day).
alice_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2004,2019,Year),
    atom_concat("furnished the remaining costs ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,320,328)) :- alice_household_maintenance(_,Event,_,_).
agent_(span(Event,320,328),span("Alice",314,318)) :- alice_household_maintenance(_,Event,_,_).
amount_(span(Event,320,328),span(60,334,342)) :- alice_household_maintenance(_,Event,_,_).
purpose_(span(Event,320,328),span("home",260,263)) :- alice_household_maintenance(_,Event,_,_).
start_(span(Event,320,328),span(Start_day,196,199)) :- alice_household_maintenance(_,Event,Start_day,_).
end_(span(Event,320,328),span(End_day,204,207)) :- alice_household_maintenance(_,Event,_,End_day).
income_(span("Alice's",0,6)).
agent_(span("Alice's",0,6),span("Alice",0,4)).
amount_(span("Alice's",0,6),span(71879,55,59)).
start_(span("Alice's",0,6),span(20130101,45,48)).
income_(span("Bob's",12,16)).
marriage_(span("married",104,110)).
son_(span("child",151,155)).
residence_(span("lived",286,290)).
joint_return_(span("file jointly",374,385)).
agent_(span("Bob's",12,16),span("Bob",12,14)).
start_(span("Bob's",12,16),span(20130101,45,48)).
amount_(span("Bob's",12,16),span(11213,66,70)).
start_(span("file jointly",374,385),span(20130101,354,357)).
agent_(span("file jointly",374,385),span("Alice",360,364)).
agent_(span("file jointly",374,385),span("Bob",370,372)).
agent_(span("married",104,110),span("Alice",86,90)).
agent_(span("married",104,110),span("Bob",96,98)).
start_(span("married",104,110),span(19920203,115,127)).
start_(span("lived",286,290),span(20040101,196,199)).
end_(span("lived",286,290),span(20191231,204,207)).
agent_(span("lived",286,290),span("Bob",210,212)).
patient_(span("lived",286,290),span("home",260,263)).
agent_(span("lived",286,290),span("Charlie",278,284)).
patient_(span("child",151,155),span("Alice",130,134)).
patient_(span("child",151,155),span("Bob",140,142)).
agent_(span("child",151,155),span("Charlie",158,164)).
start_(span("child",151,155),span(20001009,172,188)).
birth_(span("born",167,170)).
agent_(span("born",167,170),span("Charlie",158,164)).
start_(span("born",167,170),span(20001009,172,188)).

% Test
:- tax("Alice",2013,15109).
:- halt.
