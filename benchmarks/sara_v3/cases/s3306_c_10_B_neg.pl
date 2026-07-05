% Text
% Alice was paid $200 in March 2017 for services performed at Johns Hopkins Hospital in March 2017. Alice was a patient at Johns Hopkins Hospital from January 12th, 2017 to February 20th, 2017.

% Question
% Section 3306(c)(10)(B) applies to Alice's employment situation in 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("services",38,45)).
hospital_(span("Hospital",74,81)).
medical_patient_(span("patient",110,116)).
agent_(span("Hospital",74,81),span("Johns Hopkins Hospital",60,81)).
agent_(span("patient",110,116),span("Alice",98,102)).
patient_(span("patient",110,116),span("Johns Hopkins Hospital",121,142)).
start_(span("patient",110,116),span(20170112,149,166)).
end_(span("patient",110,116),span(20170220,171,189)).
patient_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(200,16,18)).
start_(span("paid",10,13),span(20170301,23,32)).
purpose_(span("paid",10,13),span("services",38,45)).
agent_(span("paid",10,13),span("Johns Hopkins Hospital",60,81)).
agent_(span("services",38,45),span("Alice",0,4)).
end_(span("services",38,45),span(20170331,86,95)).
start_(span("services",38,45),span(20170301,86,95)).
patient_(span("services",38,45),span("Johns Hopkins Hospital",60,81)).

% Test
:- \+ s3306_c_10_B(span("services",38,45),_,"Alice",20170301).
:- halt.
