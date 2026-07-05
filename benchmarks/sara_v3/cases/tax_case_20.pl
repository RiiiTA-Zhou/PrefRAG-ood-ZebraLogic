% Text
% In 2017, Alice's gross income was $310192. Since 2014, Alice maintains a house where she and her daughter live. Alice was married since Jan 14th, 2010 until her husband died on Nov 23rd, 2016. In 2017, Alice is allowed itemized deductions of $17890. Alice has paid $45252 to Bob for work done in the year 2017. In 2017, Alice has also paid $9832 into a retirement fund for Bob, and paid $5322 into health insurance for Charlie, who is Alice's father and has retired in 2016. Charlie had no income in 2017.

% Question
% How much tax does Alice have to pay in 2017? $90683

% Facts
:- [statutes/prolog/init].
start_(span("maintains",61,69),span(Day,43,52)) :- between(2014,2024,Year), first_day_year(Year,Day).
purpose_(span("paid",335,338),span("make provisions for employees in case of retirement",353,367)).
income_(span("income",23,28)).
payment_(span("maintains",61,69)).
daughter_(span("daughter",97,104)).
residence_(span("live",106,109)).
marriage_(span("married",122,128)).
death_(span("died",169,172)).
deduction_(span("deductions",228,237)).
payment_(span("paid",260,263)).
service_(span("work",283,286)).
payment_(span("paid",335,338)).
plan_(span("retirement fund",353,367)).
payment_(span("paid",382,385)).
plan_(span("health insurance",398,413)).
father_(span("father",443,448)).
retirement_(span("retired",458,464)).
patient_(span("daughter",97,104),span("Alice",55,59)).
agent_(span("daughter",97,104),span("daughter",97,104)).
agent_(span("died",169,172),span("husband",161,167)).
start_(span("died",169,172),span(20161123,177,190)).
agent_(span("deductions",228,237),span("Alice",202,206)).
amount_(span("deductions",228,237),span(17890,243,247)).
start_(span("deductions",228,237),span(20170101,196,199)).
patient_(span("father",443,448),span("Alice",435,439)).
agent_(span("father",443,448),span("Charlie",419,425)).
start_(span("income",23,28),span(20170101,3,6)).
agent_(span("income",23,28),span("Alice",9,13)).
amount_(span("income",23,28),span(310192,35,40)).
agent_(span("married",122,128),span("Alice",112,116)).
start_(span("married",122,128),span(20100114,136,149)).
agent_(span("married",122,128),span("husband",161,167)).
start_(span("paid",382,385),span(20170101,314,317)).
amount_(span("paid",382,385),span(5322,388,391)).
purpose_(span("paid",382,385),span("make provisions for employees in case of sickness",398,413)).
patient_(span("paid",382,385),span("health insurance",398,413)).
beneficiary_(span("paid",382,385),span("Charlie",419,425)).
agent_(span("paid",382,385),span("Alice",320,324)).
start_(span("paid",335,338),span(20170101,314,317)).
agent_(span("paid",335,338),span("Alice",320,324)).
amount_(span("paid",335,338),span(9832,341,344)).
patient_(span("paid",335,338),span("retirement fund",353,367)).
beneficiary_(span("paid",335,338),span("Bob",373,375)).
start_(span("paid",260,263),span(20170101,305,308)).
agent_(span("paid",260,263),span("Alice",250,254)).
amount_(span("paid",260,263),span(45252,266,270)).
patient_(span("paid",260,263),span("Bob",275,277)).
purpose_(span("paid",260,263),span("work",283,286)).
agent_(span("maintains",61,69),span("Alice",55,59)).
patient_(span("maintains",61,69),span("house",73,77)).
purpose_(span("maintains",61,69),span("house",73,77)).
amount_(span("maintains",61,69),span(1,61,69)).
agent_(span("live",106,109),span("Alice",55,59)).
patient_(span("live",106,109),span("house",73,77)).
agent_(span("live",106,109),span("daughter",97,104)).
start_(span("live",106,109),span(20140101,49,52)).
start_(span("retired",453,459),span(20160101,469,472)).
agent_(span("retired",453,459),span("Charlie",419,425)).
start_(span("work",283,286),span(20170101,305,308)).
patient_(span("work",283,286),span("Alice",250,254)).
agent_(span("work",283,286),span("Bob",275,277)).
end_(span("work",283,286),span(20171231,305,308)).

% Test
:- tax("Alice",2017,90683).
:- halt.
