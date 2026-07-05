% Text
% Alice and Bob got married on November 23rd, 1994. Their son Charlie was born on July 5th, 2000. Bob died on March 15th, 2015. In 2017, Alice and Charlie lived in a house maintained by Alice. Alice's gross income for the year 2017 is $95129. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $19039

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
son_(span("son",56,58)).
death_(span("died",100,103)).
residence_(span("lived",153,157)).
payment_(span("maintained",170,179)).
income_(span("income",205,210)).
agent_(span("died",100,103),span("Bob",96,98)).
start_(span("died",100,103),span(20150315,108,123)).
agent_(span("income",205,210),span("Alice",191,195)).
start_(span("income",205,210),span(20170101,225,228)).
amount_(span("income",205,210),span(95129,234,238)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19941123,29,47)).
purpose_(span("maintained",170,179),span("house",164,168)).
agent_(span("maintained",170,179),span("Alice",184,188)).
amount_(span("maintained",170,179),span(1,170,179)).
start_(span("maintained",170,179),span(20170101,129,132)).
agent_(span("lived",153,157),span("Alice",135,139)).
agent_(span("lived",153,157),span("Charlie",145,151)).
patient_(span("lived",153,157),span("house",164,168)).
end_(span("lived",153,157),span(20171231,129,132)).
start_(span("lived",153,157),span(20170101,129,132)).
patient_(span("son",56,58),span("Alice",0,4)).
agent_(span("son",56,58),span("Charlie",60,66)).
start_(span("son",56,58),span(20000705,80,93)).
patient_(span("son",56,58),span("Bob",10,12)).
birth_(span("born",72,75)).
agent_(span("born",72,75),span("Charlie",60,66)).
start_(span("born",72,75),span(20000705,80,93)).

% Test
:- tax("Alice",2017,19039).
:- halt.
