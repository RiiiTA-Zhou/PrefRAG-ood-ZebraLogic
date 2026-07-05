% Text
% Alice's gross income for the year 2017 is $6662, Bob's gross income is $17896. Alice and Bob got married on Feb 3rd, 1992. From 2004 to 2019, Bob furnished the costs of maintaining the home where he and Alice lived during that time. In 2017, Alice and Bob file separate returns, and they both take the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $249

% Facts
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2015,2019,Year),
    atom_concat("furnished ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,146,154)) :-
    bob_household_maintenance(_,Event,_,_).
agent_(span(Event,146,154),span("Bob",142,144)) :-
    bob_household_maintenance(_,Event,_,_).
amount_(span(Event,146,154),span(1,156,158)) :-
    bob_household_maintenance(_,Event,_,_).
purpose_(span(Event,146,154),span("home",185,188)) :-
    bob_household_maintenance(_,Event,_,_).
start_(span(Event,146,154),span(Start_day,128,131)) :-
    bob_household_maintenance(_,Event,Start_day,_).
end_(span(Event,146,154),span(End_day,136,139)) :-
    bob_household_maintenance(_,Event,_,End_day).
income_(span("income",14,19)).
income_(span("income",61,66)).
marriage_(span("married",97,103)).
residence_(span("lived",209,213)).
agent_(span("income",14,19),span("Alice",0,4)).
start_(span("income",14,19),span(20170101,34,37)).
amount_(span("income",14,19),span(6662,43,46)).
start_(span("income",61,66),span(20170101,34,37)).
agent_(span("income",61,66),span("Bob",49,51)).
amount_(span("income",61,66),span(17896,72,76)).
agent_(span("married",97,103),span("Alice",79,83)).
agent_(span("married",97,103),span("Bob",89,91)).
start_(span("married",97,103),span(19920203,108,120)).
start_(span("lived",209,213),span(20040101,128,131)).
end_(span("lived",209,213),span(20191231,136,139)).
agent_(span("lived",209,213),span("Bob",142,144)).
patient_(span("lived",209,213),span("home",185,188)).
agent_(span("lived",209,213),span("Alice",203,207)).

% Test
:- tax("Alice",2017,249).
:- halt.
