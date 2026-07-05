% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice and Bob have a child, Charlie, born October 9th, 2000. From 2004 to 2019, Bob furnished the costs of maintaining the home where Alice, Bob and Charlie lived during that time. Charlie married Dan on Feb 14th, 2018 and they file separate tax returns in 2018. Dan's principal place of abode for 2018 is different from Charlie's. Alice's gross income in 2018 was $54232, and Bob's gross income was $43245. Alice and Bob file a joint return in 2018 and take the standard deduction.

% Question
% How much tax does Alice have to pay in 2018? $15777

% Facts
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2004,2019,Year),
    atom_concat("furnished the costs ",Year,Event_name),
    Event = span(Event_name,128,136),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(Event) :- bob_household_maintenance(_,Event,_,_).
agent_(Event,span("Bob",124,126)) :- bob_household_maintenance(_,Event,_,_).
amount_(Event,span(1,138,140)) :- bob_household_maintenance(_,Event,_,_).
purpose_(Event,span("home",167,170)) :- bob_household_maintenance(_,Event,_,_).
start_(Event,span(Start_day,110,113)) :- bob_household_maintenance(_,Event,Start_day,_).
marriage_(span("married",18,24)).
son_(span("child",65,69)).
residence_(span("lived",201,205)).
marriage_(span("married",233,239)).
residence_(span("abode",332,336)).
residence_(span("Charlie's",365,373)).
income_(span("income",390,395)).
income_(span("income",433,438)).
joint_return_(span("joint return",473,484)).
agent_(span("income",390,395),span("Alice",376,380)).
start_(span("income",390,395),span(20180101,400,403)).
amount_(span("income",390,395),span(54232,410,414)).
agent_(span("income",433,438),span("Bob",421,423)).
amount_(span("income",433,438),span(43245,445,449)).
start_(span("income",433,438),span(20180101,400,403)).
agent_(span("joint return",473,484),span("Alice",452,456)).
agent_(span("joint return",473,484),span("Bob",462,464)).
start_(span("joint return",473,484),span(20180101,489,492)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).
agent_(span("married",233,239),span("Charlie",225,231)).
agent_(span("married",233,239),span("Dan",241,243)).
start_(span("married",233,239),span(20180214,248,261)).
end_(span("Charlie's",365,373),span(20181231,342,345)).
start_(span("Charlie's",365,373),span(20180101,342,345)).
agent_(span("Charlie's",365,373),span("Charlie",365,371)).
patient_(span("Charlie's",365,373),span("Charlie's",365,373)).
agent_(span("abode",332,336),span("Dan",307,309)).
patient_(span("abode",332,336),span("abode",323,327)).
end_(span("abode",332,336),span(20181231,342,345)).
start_(span("abode",332,336),span(20180101,342,345)).
start_(span("lived",201,205),span(20040101,110,113)).
end_(span("lived",201,205),span(20191231,118,121)).
patient_(span("lived",201,205),span("home",167,170)).
agent_(span("lived",201,205),span("Bob",185,187)).
agent_(span("lived",201,205),span("Charlie",193,199)).
agent_(span("lived",201,205),span("Alice",178,182)).
patient_(span("child",65,69),span("Alice",44,48)).
patient_(span("child",65,69),span("Bob",54,56)).
agent_(span("child",65,69),span("Charlie",72,78)).
start_(span("child",65,69),span(20001009,86,102)).
birth_(span("born",81,84)).
agent_(span("born",81,84),span("Charlie",72,78)).
start_(span("born",81,84),span(20001009,86,102)).

% Test
:- tax("Alice",2018,15777).
:- halt.
