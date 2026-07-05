% Text
% Alice and Bob got married on April 5th, 2012. Alice and Bob have a son, Charlie, who was born on September 16th, 2017. Alice and Charlie live in a home for which Alice furnished 40% of the maintenance costs, and Bob the remaining 60%, since September 16th, 2017. Alice and Bob file jointly from 2017 to 2019. Alice and Bob's gross incomes in 2018 were $36991 and $41990 respectively. Alice and Bob take the standard deduction. From 2017 to 2019, Bob lived separately.

% Question
% How much tax does Alice have to pay in 2018? $10598

% Facts
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2017,2027,Year),
    atom_concat("Bob the remaining 60% ",Year,Event),
    (
        (
            double_equal(Year, 2017),
            Start_day=20170916
        )
    ;
        (
            \+ double_equal(Year, 2017),
            first_day_year(Year,Start_day)
        )
    ),
    last_day_year(Year,End_day).
payment_(span(Event,220,228)) :- bob_household_maintenance(_,Event,_,_).
agent_(span(Event,220,228),span("Bob",212,214)) :- bob_household_maintenance(_,Event,_,_).
amount_(span(Event,220,228),span(60,230,231)) :- bob_household_maintenance(_,Event,_,_).
purpose_(span(Event,220,228),span("live",137,140)) :- bob_household_maintenance(_,Event,_,_).
start_(span(Event,220,228),span(Start_day,241,260)) :- bob_household_maintenance(_,Event,Start_day,_).
end_(span(Event,220,228),span(End_day,241,260)) :- bob_household_maintenance(_,Event,_,End_day).
alice_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2017,2027,Year),
    atom_concat("Alice furnished 40% of the maintenance costs ",Year,Event),
    (
        (
            double_equal(Year, 2017),
            Start_day=20170916
        )
    ;
        (
            \+ double_equal(Year, 2017),
            first_day_year(Year,Start_day)
        )
    ),
    last_day_year(Year,End_day).
payment_(span(Event,168,176)) :- alice_household_maintenance(_,Event,_,_).
agent_(span(Event,168,176),span("Alice",162,166)) :- alice_household_maintenance(_,Event,_,_).
amount_(span(Event,168,176),span(40,178,179)) :- alice_household_maintenance(_,Event,_,_).
purpose_(span(Event,168,176),span("live",137,140)) :- alice_household_maintenance(_,Event,_,_).
start_(span(Event,168,176),span(Start_day,241,260)) :- alice_household_maintenance(_,Event,Start_day,_).
end_(span(Event,168,176),span(End_day,241,260)) :- alice_household_maintenance(_,Event,_,End_day).
joint_return_alice_and_bob(Year,Event,Start_day,End_day) :-
    between(2017,2019,Year),
    atom_concat("file jointly ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
joint_return_(span(Event,277,288)) :- joint_return_alice_and_bob(_,Event,_,_).
agent_(span(Event,277,288),span("Alice",263,267)) :- joint_return_alice_and_bob(_,Event,_,_).
agent_(span(Event,277,288),span("Bob",273,275)) :- joint_return_alice_and_bob(_,Event,_,_).
start_(span(Event,277,288),span(Day,295,298)) :- joint_return_alice_and_bob(_,Event,Day,_).
end_(span(Event,277,288),span(Day,303,306)) :- joint_return_alice_and_bob(_,Event,_,Day).
income_(span("Alice",309,313)).
agent_(span("Alice",309,313),span("Alice",309,313)).
amount_(span("Alice",309,313),span(36991,353,357)).
start_(span("Alice",309,313),span(20180101,342,345)).
marriage_(span("married",18,24)).
son_(span("son",67,69)).
residence_(span("live",137,140)).
agent_(span("live",137,140),span("Alice",119,123)).
agent_(span("live",137,140),span("Charlie",129,135)).
patient_(span("live",137,140),span("home",147,150)).
start_(span("live",137,140),span(20170916,241,260)).
income_(span("Bob",319,321)).
residence_(span("lived",450,454)).
agent_(span("Bob",319,321),span("Bob",319,321)).
start_(span("Bob",319,321),span(20180101,342,345)).
amount_(span("Bob",319,321),span(41990,364,368)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(20120405,29,43)).
start_(span("lived",450,454),span(20170101,432,435)).
end_(span("lived",450,454),span(20191231,440,443)).
agent_(span("lived",450,454),span("Bob",446,448)).
patient_(span("lived",450,454),span("separately",456,465)).
patient_(span("son",67,69),span("Alice",46,50)).
patient_(span("son",67,69),span("Bob",56,58)).
agent_(span("son",67,69),span("Charlie",72,78)).
start_(span("son",67,69),span(20170916,97,116)).
birth_(span("born",89,92)).
agent_(span("born",89,92),span("Charlie",72,78)).
start_(span("born",89,92),span(20170916,97,116)).

% Test
:- tax("Alice",2018,10598).
:- halt.
