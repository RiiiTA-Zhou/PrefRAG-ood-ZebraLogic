% Text
% Alice has a son, Bob, who was born January 31st, 2014, and has lived at Alice's place since then. Alice's gross income for the year 2017 is $22895. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $2174

% Facts
:- [statutes/prolog/init].
son_(span("son",12,14)).
patient_(span("son",12,14),span("Alice",0,4)).
agent_(span("son",12,14),span("Bob",17,19)).
start_(span("son",12,14),span(20140131,35,52)).
birth_(span("born",30,33)).
agent_(span("born",30,33),span("Bob",17,19)).
start_(span("born",30,33),span(20140131,35,52)).
residence_(span("place",80,84)).
agent_(span("place",80,84),span("Alice",72,76)).
patient_(span("place",80,84),span("place",80,84)).
residence_(span("lived",63,67)).
patient_(span("lived",63,67),span("place",80,84)).
agent_(span("lived",63,67),span("Bob",17,19)).
payment_(span("Alice's",72,78)).
agent_(span("Alice's",72,78),span("Alice",72,76)).
purpose_(span("Alice's",72,78),span("place",80,84)).
amount_(span("Alice's",72,78),span(1,72,78)).
start_(span("Alice's",72,78),span(20170101,132,135)).
income_(span("income",112,117)).
agent_(span("income",112,117),span("Alice",98,102)).
start_(span("income",112,117),span(20170101,132,135)).
amount_(span("income",112,117),span(22895,141,145)).

% Test
:- tax("Alice",2017,2174).
:- halt.
