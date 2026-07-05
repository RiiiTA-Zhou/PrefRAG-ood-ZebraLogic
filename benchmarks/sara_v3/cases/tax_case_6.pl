% Text
% Alice married Bob on May 29th, 2008. Their son Charlie was born October 4th, 2004. Bob died October 22nd, 2016. Alice's gross income for the year 2016 was $113580. In 2017, Alice's gross income was $567192. In 2017, Alice and Charlie lived in a house maintained by Alice. That same year, Alice is allowed a deduction of $59850 for donating cash to a charity.

% Question
% How much tax does Alice have to pay in 2017? $180610

% Facts
:- [statutes/prolog/init].
marriage_(span("married",6,12)).
son_(span("son",43,45)).
death_(span("died",87,90)).
income_(span("income",126,131)).
income_(span("income",187,192)).
residence_(span("lived",234,238)).
payment_(span("maintained",251,260)).
deduction_(span("deduction",307,315)).
agent_(span("died",87,90),span("Bob",83,85)).
start_(span("died",87,90),span(20161022,92,109)).
start_(span("deduction",307,315),span(20170101,210,213)).
agent_(span("deduction",307,315),span("Alice",288,292)).
amount_(span("deduction",307,315),span(59850,321,325)).
agent_(span("income",126,131),span("Alice",112,116)).
start_(span("income",126,131),span(20160101,146,149)).
amount_(span("income",126,131),span(113580,156,161)).
start_(span("income",187,192),span(20170101,167,170)).
agent_(span("income",187,192),span("Alice",173,177)).
amount_(span("income",187,192),span(567192,199,204)).
agent_(span("married",6,12),span("Alice",0,4)).
agent_(span("married",6,12),span("Bob",14,16)).
start_(span("married",6,12),span(20080529,21,34)).
amount_(span("maintained",251,260),span(1,251,260)).
start_(span("maintained",251,260),span(20170101,210,213)).
purpose_(span("maintained",251,260),span("house",245,249)).
agent_(span("maintained",251,260),span("Alice",265,269)).
end_(span("lived",234,238),span(20171231,210,213)).
start_(span("lived",234,238),span(20170101,210,213)).
agent_(span("lived",234,238),span("Alice",216,220)).
agent_(span("lived",234,238),span("Charlie",226,232)).
patient_(span("lived",234,238),span("house",245,249)).
patient_(span("son",43,45),span("Alice",0,4)).
agent_(span("son",43,45),span("Charlie",47,53)).
start_(span("son",43,45),span(20041004,64,80)).
birth_(span("born",59,62)).
agent_(span("born",59,62),span("Charlie",47,53)).
start_(span("born",59,62),span(20041004,64,80)).
patient_(span("son",43,45),span("Bob",14,16)).

% Test
:- tax("Alice",2017,180610).
:- halt.
