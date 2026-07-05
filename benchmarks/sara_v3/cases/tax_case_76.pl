% Text
% Alice, born Sep 4th, 1950, has a son, Bob, who was born January 31st, 1984. Alice and Bob share the same principal place of abode since then, which Alice maintains. Alice's gross income for the year 1997 is $172980. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 1997? $46734

% Facts
:- [statutes/prolog/init].
start_(span("maintains",154,162),span(Day,56,73)) :- between(1984,2004,Year),
    first_day_year(Year,Day).
birth_(span("born",7,10)).
son_(span("son",33,35)).
residence_(span("abode",124,128)).
payment_(span("maintains",154,162)).
income_(span("income",179,184)).
agent_(span("born",7,10),span("Alice",0,4)).
start_(span("born",7,10),span(19501104,12,24)).
agent_(span("income",179,184),span("Alice",165,169)).
start_(span("income",179,184),span(19970101,199,202)).
amount_(span("income",179,184),span(172980,208,213)).
purpose_(span("maintains",154,162),span("place",115,119)).
agent_(span("maintains",154,162),span("Alice",148,152)).
amount_(span("maintains",154,162),span(1,154,162)).
start_(span("abode",124,128),span(19840131,56,73)).
agent_(span("abode",124,128),span("Alice",76,80)).
agent_(span("abode",124,128),span("Bob",86,88)).
patient_(span("abode",124,128),span("place",115,119)).
patient_(span("son",33,35),span("Alice",0,4)).
agent_(span("son",33,35),span("Bob",38,40)).
start_(span("son",33,35),span(19840131,56,73)).
birth_(span("born",51,54)).
agent_(span("born",51,54),span("Bob",38,40)).
start_(span("born",51,54),span(19840131,56,73)).

% Test
:- tax("Alice",1997,46734).
:- halt.
