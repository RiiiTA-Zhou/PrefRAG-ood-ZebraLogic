% Text
% Alice's husband, Bob, was paid $3200 in 2017 for services performed for Johns Hopkins University. Alice was enrolled at Johns Hopkins University and attending classes from August 29, 2015 to May 30th, 2019.

% Question
% Section 3306(c)(10)(A)(ii) applies to Bob's employment situation in 2017. Entailment

% Facts
:- [statutes/prolog/init].
marriage_(span("husband",8,14)).
payment_(span("paid",26,29)).
service_(span("services",49,56)).
educational_institution_(span("University",86,95)).
enrollment_(span("enrolled",108,115)).
attending_classes_(span("attending",149,157)).
agent_(span("attending",149,157),span("Alice",98,102)).
location_(span("attending",149,157),span("Johns Hopkins University",120,143)).
start_(span("attending",149,157),span(20150829,172,186)).
end_(span("attending",149,157),span(20190530,191,204)).
agent_(span("University",86,95),span("Johns Hopkins University",72,95)).
agent_(span("enrolled",108,115),span("Alice",98,102)).
patient_(span("enrolled",108,115),span("Johns Hopkins University",120,143)).
start_(span("enrolled",108,115),span(20150829,172,186)).
end_(span("enrolled",108,115),span(20190530,191,204)).
agent_(span("husband",8,14),span("Alice",0,4)).
agent_(span("husband",8,14),span("Bob",17,19)).
patient_(span("paid",26,29),span("Bob",17,19)).
amount_(span("paid",26,29),span(3200,32,35)).
start_(span("paid",26,29),span(20170101,40,43)).
purpose_(span("paid",26,29),span("services",49,56)).
agent_(span("paid",26,29),span("Johns Hopkins University",72,95)).
agent_(span("services",49,56),span("Bob",17,19)).
end_(span("services",49,56),span(20171231,40,43)).
start_(span("services",49,56),span(20170101,40,43)).
patient_(span("services",49,56),span("Johns Hopkins University",72,95)).

% Test
:- s3306_c_10_A_ii("Alice","Bob",20170101).
:- halt.
