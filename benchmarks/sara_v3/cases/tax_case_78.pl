% Text
% Alice and Bob got married on April 5th, 2012. Alice and Bob have a son, Charlie, who was born on September 16th, 2017. Alice and Charlie live in a home maintained by Alice since September 16th, 2017. Alice's gross income in 2019 is $73124. Alice and Bob file separate returns. Alice takes the standard deduction. In 2019, Bob has a different principal place of abode than Alice and Charlie.

% Question
% How much tax does Alice have to pay in 2019? $14470

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(20120405,29,43)).
son_(span("son",67,69)).
patient_(span("son",67,69),span("Alice",46,50)).
patient_(span("son",67,69),span("Bob",56,58)).
agent_(span("son",67,69),span("Charlie",72,78)).
start_(span("son",67,69),span(20170916,97,116)).
residence_(span("live",137,140)).
agent_(span("live",137,140),span("Alice",119,123)).
agent_(span("live",137,140),span("Charlie",129,135)).
patient_(span("live",137,140),span("home",147,150)).
start_(span("live",137,140),span(20170916,178,197)).
alice_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2017,2027,Year),
    atom_concat("maintained ",Year,Event),
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
payment_(span(Event,152,161)) :- alice_household_maintenance(_,Event,_,_).
agent_(span(Event,152,161),span("Alice",166,170)) :- alice_household_maintenance(_,Event,_,_).
amount_(span(Event,152,161),span(1,152,161)) :- alice_household_maintenance(_,Event,_,_).
purpose_(span(Event,152,161),span("home",147,150)) :- alice_household_maintenance(_,Event,_,_).
start_(span(Event,152,161),span(Start_day,178,197)) :- alice_household_maintenance(_,Event,Start_day,_).
end_(span(Event,152,161),span(End_day,178,197)) :- alice_household_maintenance(_,Event,_,End_day).
income_(span("income",214,219)).
agent_(span("income",214,219),span("Alice",200,204)).
start_(span("income",214,219),span(20190101,224,227)).
amount_(span("income",214,219),span(73124,233,237)).
residence_(span("abode",361,365)).
end_(span("abode",361,365),span(20191231,316,319)).
start_(span("abode",361,365),span(20190101,316,319)).
agent_(span("abode",361,365),span("Bob",322,324)).
patient_(span("abode",361,365),span("place",352,356)).
birth_(span("born",89,92)).
agent_(span("born",89,92),span("Charlie",72,78)).
start_(span("born",89,92),span(20170916,97,116)).

% Test
:- tax("Alice",2019,14470).
:- halt.
