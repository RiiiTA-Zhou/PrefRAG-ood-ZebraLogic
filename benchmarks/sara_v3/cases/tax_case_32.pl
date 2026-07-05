% Text
% Alice's gross income in 2019 was $5723215. Alice has employed Bob from Jan 1st, 2011 to Feb 9th, 2019. Alice paid Bob $3255 in 2019. On Oct 10, 2019 Bob retired because he reached age 65. Alice paid Bob $12980 as a retirement bonus. In 2019, Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2019? $2242833

% Facts
:- [statutes/prolog/init].
income_(span("income",14,19)).
service_(span("employed",53,60)).
payment_(span("paid",109,112)).
retirement_(span("retired",153,159)).
payment_(span("paid",194,197)).
agent_(span("income",14,19),span("Alice",0,4)).
start_(span("income",14,19),span(20190101,24,27)).
amount_(span("income",14,19),span(5723215,34,40)).
purpose_(span("paid",194,197),span("employed",53,60)).
start_(span("paid",194,197),span(20190209,88,100)).
agent_(span("paid",194,197),span("Alice",188,192)).
patient_(span("paid",194,197),span("Bob",199,201)).
amount_(span("paid",194,197),span(12980,204,208)).
purpose_(span("paid",109,112),span("employed",53,60)).
agent_(span("paid",109,112),span("Alice",103,107)).
patient_(span("paid",109,112),span("Bob",114,116)).
amount_(span("paid",109,112),span(3255,119,122)).
start_(span("paid",109,112),span(20190101,127,130)).
start_(span("retired",153,159),span(20190209,88,100)).
agent_(span("retired",153,159),span("Bob",149,151)).
reason_(span("retired",153,159),span("reached age 65",172,185)).
patient_(span("employed",53,60),span("Alice",43,47)).
agent_(span("employed",53,60),span("Bob",62,64)).
start_(span("employed",53,60),span(20110101,71,83)).
end_(span("employed",53,60),span(20191010,136,147)).

% Test
:- tax("Alice",2019,2242833).
:- halt.
