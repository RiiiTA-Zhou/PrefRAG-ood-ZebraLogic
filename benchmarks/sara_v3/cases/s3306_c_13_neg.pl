% Text
% Alice was paid $3200 in 2017 for services performed for Johns Hopkins University. Alice was enrolled as a physics major at Johns Hopkins University and attending classes from August 29, 2015 to May 30th, 2019.

% Question
% Section 3306(c)(13) applies to Alice's employment situation in 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("services",33,40)).
educational_institution_(span("University",70,79)).
enrollment_(span("enrolled",92,99)).
attending_classes_(span("attending",152,160)).
agent_(span("attending",152,160),span("Alice",82,86)).
location_(span("attending",152,160),span("Johns Hopkins University",123,146)).
start_(span("attending",152,160),span(20150829,175,189)).
end_(span("attending",152,160),span(20190530,194,207)).
agent_(span("University",70,79),span("Johns Hopkins University",56,79)).
agent_(span("enrolled",92,99),span("Alice",82,86)).
patient_(span("enrolled",92,99),span("Johns Hopkins University",123,146)).
start_(span("enrolled",92,99),span(20150829,175,189)).
end_(span("enrolled",92,99),span(20190530,194,207)).
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
:- \+ s3306_c_13(span("services",33,40),_,"Alice",20170101).
:- halt.
