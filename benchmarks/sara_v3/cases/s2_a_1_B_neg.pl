% Text
% Alice and Bob were married from Feb 3rd, 1992 to Jan 14th, 2020. Alice has a child, Charlie, born October 9th, 2000. Alice died on July 9th, 2021. From 2011 to 2024, Bob furnished the costs of maintaining the home where he and Charlie lived during that time. In 2020, Charlie filed a joint return with his spouse whom he married on Dec 1st, 2020. Charlie earned $312489 in 2020.

% Question
% Section 2(a)(1)(B) applies to Bob in 2020. Contradiction

% Facts
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2011,2024,Year),
    atom_concat("furnished the costs of maintaining the home ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,170,178)) :- bob_household_maintenance(_,Event,_,_).
agent_(span(Event,170,178),span("Bob",166,168)) :- bob_household_maintenance(_,Event,_,_).
amount_(span(Event,170,178),span(1,180,182)) :- bob_household_maintenance(_,Event,_,_).
purpose_(span(Event,170,178),span("home",209,212)) :- bob_household_maintenance(_,Event,_,_).
start_(span(Event,170,178),span(Start_day,152,155)) :- bob_household_maintenance(_,Event,Start_day,_).
end_(span(Event,170,178),span(End_day,160,163)) :- bob_household_maintenance(_,Event,_,End_day).
marriage_(span("married",19,25)).
son_(span("child",77,81)).
death_(span("died",123,126)).
residence_(span("lived",235,239)).
joint_return_(span("joint return",284,295)).
marriage_(span("married",321,327)).
income_(span("earned",355,360)).
agent_(span("died",123,126),span("Alice",117,121)).
start_(span("died",123,126),span(20210709,131,144)).
agent_(span("earned",355,360),span("Charlie",347,353)).
amount_(span("earned",355,360),span(312489,363,368)).
start_(span("earned",355,360),span(20200101,373,376)).
start_(span("joint return",284,295),span(20200101,262,265)).
agent_(span("joint return",284,295),span("Charlie",268,274)).
agent_(span("joint return",284,295),span("spouse",306,311)).
agent_(span("married",19,25),span("Alice",0,4)).
agent_(span("married",19,25),span("Bob",10,12)).
start_(span("married",19,25),span(19920203,32,44)).
end_(span("married",19,25),span(20200114,49,62)).
agent_(span("married",321,327),span("Charlie",268,274)).
agent_(span("married",321,327),span("spouse",306,311)).
start_(span("married",321,327),span(20201201,332,344)).
start_(span("lived",235,239),span(20110101,152,155)).
end_(span("lived",235,239),span(20241231,160,163)).
agent_(span("lived",235,239),span("Bob",166,168)).
patient_(span("lived",235,239),span("home",209,212)).
agent_(span("lived",235,239),span("Charlie",227,233)).
patient_(span("child",77,81),span("Alice",65,69)).
agent_(span("child",77,81),span("Charlie",84,90)).
start_(span("child",77,81),span(20001009,98,114)).
birth_(span("born",93,96)).
agent_(span("born",93,96),span("Charlie",84,90)).
start_(span("born",93,96),span(20001009,98,114)).

% Test
:- \+ s2_a_1_B("Bob",_,_,2020).
:- halt.
