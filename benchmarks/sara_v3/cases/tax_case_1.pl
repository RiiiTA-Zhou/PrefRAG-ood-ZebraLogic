% Text
% Alice was paid $1200 in 2019 for services performed in jail. Alice was committed to jail from January 24, 2015 to May 5th, 2019. From May 5th 2019 to Dec 31st 2019, Alice was paid $5320 in remuneration. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2019? $0

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("services",33,40)).
penal_institution_(span("jail",55,58)).
incarceration_(span("committed",71,79)).
payment_(span("paid",175,178)).
agent_(span("committed",71,79),span("Alice",61,65)).
patient_(span("committed",71,79),span("jail",84,87)).
start_(span("committed",71,79),span(20150124,94,109)).
end_(span("committed",71,79),span(20190505,114,126)).
patient_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(1200,16,19)).
purpose_(span("paid",10,13),span("services",33,40)).
agent_(span("paid",10,13),span("jail",55,58)).
start_(span("paid",10,13),span(20190101,24,27)).
start_(span("paid",175,178),span(20191231,150,162)).
patient_(span("paid",175,178),span("Alice",165,169)).
amount_(span("paid",175,178),span(5320,181,184)).
agent_(span("jail",84,87),span("jail",55,58)).
agent_(span("services",33,40),span("Alice",0,4)).
start_(span("services",33,40),span(20150124,94,109)).
patient_(span("services",33,40),span("jail",55,58)).
end_(span("services",33,40),span(20190505,114,126)).

% Test
:- tax("Alice",2019,0).
:- halt.
