% Text
% Alice and Harold got married on Sep 3rd, 1992. Harold and Alice have a son, born Jan 25th, 2000. Harold died on Feb 28th, 2016. They had been living in the same house since 1993, maintained by Alice. Alice and her son continued doing so after Harold's death. Alice's gross income for the year 2017 was $236422. Alice has employed Bob, Cameron, Dan, Emily, Fred and George for agricultural labor from Sep 9th to Sep 30th 2017, and paid them $5012 each. Alice takes the standard deduction in 2017.

% Question
% How much tax does Alice have to pay in 2017? $68844

% Facts
:- [statutes/prolog/init].
start_(span("maintained",179,188),span(Day,173,176)) :- between(1993,2023,Year), first_day_year(Year,Day).
alice_employer(Employee,Service_event,Payment_event) :-
    member(Employee,[span("Bob",330,332),span("Cameron",335,341),span("Dan",344,346),span("Emily",349,353),span("Fred",356,359),span("George",365,370)]),
    span(Employee_name, _, _) = Employee,
    atom_concat("employed ",Employee_name,Service_event_name),
    atom_concat("paid ",Employee_name,Payment_event_name),
    Service_event = span(Service_event_name,321,328),
    Payment_event = span(Payment_event_name,430,433).
service_(Service_event) :- alice_employer(_,Service_event,_).
agent_(Service_event,Employee) :- alice_employer(Employee,Service_event,_).
patient_(Service_event,span("Alice",311,315)) :- alice_employer(_,Service_event,_).
start_(Service_event,span(20170909,400,406)) :- alice_employer(_,Service_event,_).
end_(Service_event,span(20170930,411,423)) :- alice_employer(_,Service_event,_).
payment_(Payment_event) :- alice_employer(_,_,Payment_event).
patient_(Payment_event,Employee) :- alice_employer(Employee,_,Payment_event).
agent_(Payment_event,span("Alice",311,315)) :- alice_employer(_,_,Payment_event).
start_(Payment_event,span(20170930,411,423)) :- alice_employer(_,_,Payment_event).
amount_(Payment_event,span(5012,441,444)) :- alice_employer(_,_,Payment_event).
purpose_(Payment_event,Service_event) :- alice_employer(_,Service_event,Payment_event).
purpose_(Service_event,span("agricultural labor",376,393)) :- alice_employer(_,Service_event,_).
marriage_(span("married",21,27)).
son_(span("son",71,73)).
death_(span("died",104,107)).
residence_(span("living",142,147)).
payment_(span("maintained",179,188)).
residence_(span("continued",218,226)).
income_(span("income",273,278)).
agent_(span("died",104,107),span("Harold",97,102)).
start_(span("died",104,107),span(20160228,112,125)).
agent_(span("income",273,278),span("Alice",259,263)).
start_(span("income",273,278),span(20170101,293,296)).
amount_(span("income",273,278),span(236422,303,308)).
agent_(span("married",21,27),span("Alice",0,4)).
agent_(span("married",21,27),span("Harold",10,15)).
start_(span("married",21,27),span(19920903,32,44)).
purpose_(span("maintained",179,188),span("house",161,165)).
amount_(span("maintained",179,188),span(1993,173,176)).
agent_(span("maintained",179,188),span("Alice",193,197)).
start_(span("continued",218,226),span(20160228,112,125)).
patient_(span("continued",218,226),span("house",161,165)).
agent_(span("continued",218,226),span("Alice",200,204)).
agent_(span("continued",218,226),span("son",214,216)).
end_(span("living",142,147),span(20160228,112,125)).
patient_(span("living",142,147),span("house",161,165)).
start_(span("living",142,147),span(19930101,173,176)).
agent_(span("living",142,147),span("Harold",97,102)).
patient_(span("son",71,73),span("Harold",47,52)).
patient_(span("son",71,73),span("Alice",58,62)).
agent_(span("son",71,73),span("son",71,73)).
start_(span("son",71,73),span(20000125,81,94)).
birth_(span("born",76,79)).
agent_(span("born",76,79),span("son",71,73)).
start_(span("born",76,79),span(20000125,81,94)).

% Test
:- tax("Alice",2017,68844).
:- halt.
