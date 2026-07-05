% Text
% Alice was paid $200 in 2017 for services performed in a hospital. Alice was committed to a psychiatric hospital from January 24, 2015 to May 5th, 2019.

% Question
% Section 3306(c)(21) applies to Alice's employment situation in 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("services",32,39)).
medical_institution_(span("hospital",56,63)).
incarceration_(span("committed",76,84)).
patient_(span("committed",76,84),span("hospital",103,110)).
agent_(span("committed",76,84),span("Alice",66,70)).
start_(span("committed",76,84),span(20150124,117,132)).
end_(span("committed",76,84),span(20190505,137,149)).
agent_(span("hospital",56,63),span("hospital",56,63)).
patient_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(200,16,18)).
start_(span("paid",10,13),span(20170101,23,26)).
purpose_(span("paid",10,13),span("services",32,39)).
agent_(span("paid",10,13),span("hospital",56,63)).
agent_(span("services",32,39),span("Alice",0,4)).
end_(span("services",32,39),span(20171231,23,26)).
start_(span("services",32,39),span(20170101,23,26)).
patient_(span("services",32,39),span("hospital",56,63)).

% Test
:- \+ s3306_c_21(span("services",32,39),"Alice",_,20170101).
:- halt.
