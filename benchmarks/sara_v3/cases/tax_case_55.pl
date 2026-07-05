% Text
% Alice has a son, Bob. From September 1st, 2015 to November 3rd, 2019, Alice and Bob lived in the same home, maintained by Alice. Bob was born on September 1st, 2015. Alice's gross income for the year 2017 is $545547. Alice's gross income for the year 2018 is $545947. Alice's gross income for the year 2019 is $545927.

% Question
% How much tax does Alice have to pay in 2018? $187552

% Facts
:- [statutes/prolog/init].
start_(span("maintained",108,117),span(Day,145,163)) :- between(2015,2019,Year), first_day_year(Year,Day).
son_(span("son",12,14)).
residence_(span("lived",84,88)).
payment_(span("maintained",108,117)).
income_(span("income",180,185)).
income_(span("income",231,236)).
income_(span("income",282,287)).
agent_(span("income",180,185),span("Alice",166,170)).
start_(span("income",180,185),span(20170101,200,203)).
amount_(span("income",180,185),span(545547,209,214)).
agent_(span("income",231,236),span("Alice",217,221)).
start_(span("income",231,236),span(20180101,251,254)).
amount_(span("income",231,236),span(545947,260,265)).
agent_(span("income",282,287),span("Alice",268,272)).
start_(span("income",282,287),span(20190101,302,305)).
amount_(span("income",282,287),span(545927,311,316)).
purpose_(span("maintained",108,117),span("home",102,105)).
agent_(span("maintained",108,117),span("Alice",122,126)).
amount_(span("maintained",108,117),span(1,108,117)).
end_(span("lived",84,88),span(20191103,50,67)).
agent_(span("lived",84,88),span("Alice",70,74)).
agent_(span("lived",84,88),span("Bob",80,82)).
patient_(span("lived",84,88),span("home",102,105)).
start_(span("lived",84,88),span(20150901,27,45)).
patient_(span("son",12,14),span("Alice",0,4)).
agent_(span("son",12,14),span("Bob",17,19)).
start_(span("son",12,14),span(20150901,145,163)).
birth_(span("born",137,140)).
agent_(span("born",137,140),span("Bob",129,131)).
start_(span("born",137,140),span(20150901,145,163)).

% Test
:- tax("Alice",2018,187552).
:- halt.
