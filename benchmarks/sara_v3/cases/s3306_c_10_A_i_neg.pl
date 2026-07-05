% Text
% Alice was paid $3200 in 2017 for services performed for Johns Hopkins University. Alice was enrolled at Johns Hopkins University and attending classes from August 27, 2011 to May 29th, 2016.

% Question
% Section 3306(c)(10)(A)(i) applies to Alice's employment situation in 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("services",33,40)).
educational_institution_(span("University",70,79)).
enrollment_(span("enrolled",92,99)).
attending_classes_(span("attending",133,141)).
agent_(span("attending",133,141),span("Alice",82,86)).
location_(span("attending",133,141),span("Johns Hopkins University",104,127)).
start_(span("attending",133,141),span(20110827,156,170)).
end_(span("attending",133,141),span(20160529,175,188)).
agent_(span("University",70,79),span("Johns Hopkins University",56,79)).
agent_(span("enrolled",92,99),span("Alice",82,86)).
patient_(span("enrolled",92,99),span("Johns Hopkins University",104,127)).
start_(span("enrolled",92,99),span(20110827,156,170)).
end_(span("enrolled",92,99),span(20160529,175,188)).
patient_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
start_(span("paid",10,13),span(20170101,24,27)).
purpose_(span("paid",10,13),span("services",33,40)).
agent_(span("paid",10,13),span("Johns Hopkins University",56,79)).
agent_(span("services",33,40),span("Alice",0,4)).
end_(span("services",33,40),span(20171231,24,27)).
start_(span("services",33,40),span(20170101,24,27)).
patient_(span("services",33,40),span("Johns Hopkins University",56,79)).

% Test
:- \+ s3306_c_10_A_i("Alice",_,20170101).
:- halt.
