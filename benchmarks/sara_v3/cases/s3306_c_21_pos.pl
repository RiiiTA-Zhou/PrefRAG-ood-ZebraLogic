% Text
% Alice was paid $200 in 2017 for services performed in jail. Alice was committed to jail from January 24, 2015 to May 5th, 2019.

% Question
% Section 3306(c)(21) applies to Alice's employment situation in 2017. Entailment

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("services",32,39)).
penal_institution_(span("jail",54,57)).
incarceration_(span("committed",70,78)).
agent_(span("committed",70,78),span("Alice",60,64)).
patient_(span("committed",70,78),span("jail",83,86)).
start_(span("committed",70,78),span(20150124,93,108)).
end_(span("committed",70,78),span(20190505,113,125)).
patient_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(200,16,18)).
start_(span("paid",10,13),span(20170101,23,26)).
purpose_(span("paid",10,13),span("services",32,39)).
agent_(span("paid",10,13),span("jail",54,57)).
agent_(span("jail",54,57),span("jail",54,57)).
agent_(span("services",32,39),span("Alice",0,4)).
end_(span("services",32,39),span(20171231,23,26)).
start_(span("services",32,39),span(20170101,23,26)).
patient_(span("services",32,39),span("jail",54,57)).

% Test
:- s3306_c_21(span("services",32,39),"Alice",_,20170101).
:- halt.
