% Text
% Alice's father, Bob, was paid $53249 in remuneration in 2017 for services performed for Johns Hopkins University. Alice was enrolled at Johns Hopkins University and attending classes from August 29, 2015 to May 30th, 2019. While attending classes at Johns Hopkins University, Alice lived at Bob's house, for which Bob furnished all costs. In 2017, Bob takes the standard deduction.

% Question
% How much tax does Bob have to pay in 2017? $8710

% Facts
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2015,2019,Year),
    atom_concat("furnished ",Year,Event),
    (
        (
            double_equal(Year, 2015),
            Start_day=20150829
        )
    ;
        (
            \+ double_equal(Year, 2015),
            first_day_year(Year,Start_day)
        )
    ),
    (
        (
            double_equal(Year, 2019),
            End_day=20190530
        )
    ;
        (
            \+ double_equal(Year, 2019),
            last_day_year(Year,End_day)
        )
    ).
payment_(span(Event,318,326)) :- bob_household_maintenance(_,Event,_,_).
agent_(span(Event,318,326),span("Bob",314,317)) :- bob_household_maintenance(_,Event,_,_).
amount_(span(Event,318,326),span(1,328,330)) :- bob_household_maintenance(_,Event,_,_).
purpose_(span(Event,318,326),span("lived",282,286)) :- bob_household_maintenance(_,Event,_,_).
start_(span(Event,318,326),span(Start_day,188,202)) :- bob_household_maintenance(_,Event,Start_day,_).
end_(span(Event,318,326),span(End_day,207,220)) :- bob_household_maintenance(_,Event,_,End_day).
father_(span("father",8,13)).
payment_(span("paid",25,28)).
service_(span("services",65,72)).
educational_institution_(span("University",102,111)).
enrollment_(span("enrolled",124,131)).
attending_classes_(span("attending",165,173)).
residence_(span("lived",282,286)).
residence_(span("lived",282,286)).
agent_(span("attending",165,173),span("Alice",114,118)).
location_(span("attending",165,173),span("Johns Hopkins University",136,159)).
start_(span("attending",165,173),span(20150829,188,202)).
end_(span("attending",165,173),span(20190530,207,220)).
agent_(span("University",102,111),span("Johns Hopkins University",88,111)).
agent_(span("enrolled",124,131),span("Alice",114,118)).
patient_(span("enrolled",124,131),span("Johns Hopkins University",136,159)).
start_(span("enrolled",124,131),span(20150829,188,202)).
end_(span("enrolled",124,131),span(20190530,207,220)).
patient_(span("father",8,13),span("Alice",0,4)).
agent_(span("father",8,13),span("Bob",16,18)).
patient_(span("paid",25,28),span("Bob",16,18)).
amount_(span("paid",25,28),span(53249,31,35)).
start_(span("paid",25,28),span(20170101,56,59)).
purpose_(span("paid",25,28),span("services",65,72)).
agent_(span("paid",25,28),span("Johns Hopkins University",88,111)).
agent_(span("lived",282,286),span("Bob",291,293)).
patient_(span("lived",282,286),span("lived",282,286)).
start_(span("lived",282,286),span(20150829,188,202)).
end_(span("lived",282,286),span(20190530,207,220)).
agent_(span("lived",282,286),span("Alice",276,280)).
patient_(span("lived",282,286),span("lived",282,286)).
agent_(span("services",65,72),span("Bob",16,18)).
end_(span("services",65,72),span(20171231,56,59)).
start_(span("services",65,72),span(20170101,56,59)).
patient_(span("services",65,72),span("Johns Hopkins University",88,111)).

% Test
:- tax("Bob",2017,8710).
:- halt.
