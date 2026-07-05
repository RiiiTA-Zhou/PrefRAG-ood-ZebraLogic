% Text
% Alice was paid $3200 in 2017 for services performed for Johns Hopkins School of Nursing. Alice was enrolled at Johns Hopkins School of Nursing and attending classes from August 29, 2015 to May 30th, 2019.

% Question
% Section 3306(c)(13) applies to Alice's employment situation in 2017. Entailment

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("services",33,40)).
nurses_training_school_(span("School of Nursing",56,86)).
enrollment_(span("enrolled",99,106)).
attending_classes_(span("attending",147,155)).
agent_(span("attending",147,155),span("Alice",89,93)).
location_(span("attending",147,155),span("Johns Hopkins School of Nursing",111,141)).
start_(span("attending",147,155),span(20150829,170,184)).
end_(span("attending",147,155),span(20190530,189,202)).
agent_(span("enrolled",99,106),span("Alice",89,93)).
patient_(span("enrolled",99,106),span("Johns Hopkins School of Nursing",111,141)).
start_(span("enrolled",99,106),span(20150829,170,184)).
end_(span("enrolled",99,106),span(20190530,189,202)).
agent_(span("School of Nursing",56,86),span("Johns Hopkins School of Nursing",56,86)).
patient_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
start_(span("paid",10,13),span(20170101,24,27)).
purpose_(span("paid",10,13),span("services",33,40)).
agent_(span("paid",10,13),span("Johns Hopkins School of Nursing",56,86)).
agent_(span("services",33,40),span("Alice",0,4)).
end_(span("services",33,40),span(20171231,24,27)).
start_(span("services",33,40),span(20170101,24,27)).
patient_(span("services",33,40),span("Johns Hopkins School of Nursing",56,86)).

% Test
:- s3306_c_13(span("services",33,40),_,"Alice",20170101).
:- halt.
