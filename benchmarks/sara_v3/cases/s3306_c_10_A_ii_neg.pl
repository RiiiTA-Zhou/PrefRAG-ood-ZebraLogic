% Text
% Alice's father, Bob, was paid $3200 in 2017 for services performed for Johns Hopkins University. Alice was enrolled at Johns Hopkins University and attending classes from August 29, 2015 to May 30th, 2019.

% Question
% Section 3306(c)(10)(A)(ii) applies to Bob's employment situation in 2017. Contradiction

% Facts
:- [statutes/prolog/init].
father_(span("father",8,13)).
payment_(span("paid",25,28)).
service_(span("services",48,55)).
educational_institution_(span("University",85,94)).
enrollment_(span("enrolled",107,114)).
attending_classes_(span("attending",148,156)).
agent_(span("attending",148,156),span("Alice",97,101)).
location_(span("attending",148,156),span("Johns Hopkins University",119,142)).
start_(span("attending",148,156),span(20150829,171,185)).
end_(span("attending",148,156),span(20190530,190,203)).
agent_(span("University",85,94),span("Johns Hopkins University",71,94)).
agent_(span("enrolled",107,114),span("Alice",97,101)).
patient_(span("enrolled",107,114),span("Johns Hopkins University",119,142)).
start_(span("enrolled",107,114),span(20150829,171,185)).
end_(span("enrolled",107,114),span(20190530,190,203)).
patient_(span("father",8,13),span("Alice",0,4)).
agent_(span("father",8,13),span("Bob",16,18)).
patient_(span("paid",25,28),span("Bob",16,18)).
amount_(span("paid",25,28),span(3200,31,34)).
start_(span("paid",25,28),span(20170101,39,42)).
purpose_(span("paid",25,28),span("services",48,55)).
agent_(span("paid",25,28),span("Johns Hopkins University",71,94)).
agent_(span("services",48,55),span("Bob",16,18)).
end_(span("services",48,55),span(20171231,39,42)).
start_(span("services",48,55),span(20170101,39,42)).
patient_(span("services",48,55),span("Johns Hopkins University",71,94)).

% Test
:- \+ s3306_c_10_A_ii("Alice","Bob",20170101).
:- halt.
