% Text
% Alice and Bob got married on April 5th, 2012. Alice and Bob have a son, Charlie, who was born on September 16th, 2017. Alice and Charlie live in a home for which Alice furnished 40% of the maintenance costs, since September 16th, 2017. Alice is entitled to a deduction for Charlie under section 151(c) for the years 2017 to 2019.

% Question
% Section 7703(b)(2) applies to Alice maintaining her home for the year 2018. Contradiction

% Facts
:- discontiguous s151_c_applies/3.
:- [statutes/prolog/init].
someone_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2017,2027,Year),
    atom_concat("maintenance costs ",Year,Event),
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
payment_(span(Event,189,199)) :- someone_household_maintenance(_,Event,_,_).
agent_(span(Event,189,199),span("someone",162,166)) :- someone_household_maintenance(_,Event,_,_).
amount_(span(Event,189,199),span(60,178,180)) :- someone_household_maintenance(_,Event,_,_).
purpose_(span(Event,189,199),span("home",147,150)) :- someone_household_maintenance(_,Event,_,_).
start_(span(Event,189,199),span(Start_day,214,233)) :- someone_household_maintenance(_,Event,Start_day,_).
alice_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2017,2027,Year),
    atom_concat("furnished ",Year,Event),
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
purpose_(span(Event,168,176),span("home",147,150)) :- alice_household_maintenance(_,Event,_,_).
start_(span(Event,168,176),span(Start_day,214,233)) :- alice_household_maintenance(_,Event,Start_day,_).
s151_c_applies("Alice","Charlie",Year) :- between(2017,2019,Year).
marriage_(span("married",18,24)).
son_(span("son",67,69)).
residence_(span("live",137,140)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(20120405,29,43)).
agent_(span("live",137,140),span("Alice",119,123)).
agent_(span("live",137,140),span("Charlie",129,135)).
patient_(span("live",137,140),span("home",147,150)).
start_(span("live",137,140),span(20170916,214,233)).
patient_(span("son",67,69),span("Alice",46,50)).
patient_(span("son",67,69),span("Bob",56,58)).
agent_(span("son",67,69),span("Charlie",72,78)).
start_(span("son",67,69),span(20170916,97,116)).
birth_(span("born",89,92)).
agent_(span("born",89,92),span("Charlie",72,78)).
start_(span("born",89,92),span(20170916,97,116)).

% Test
:- \+ s7703_b_2("Alice","home",_,2018).
:- halt.
