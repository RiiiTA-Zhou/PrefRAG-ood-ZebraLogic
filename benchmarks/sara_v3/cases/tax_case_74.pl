% Text
% Alice was paid $200 in March 2017 for services performed at Johns Hopkins Hospital. Alice was a patient at Johns Hopkins Hospital from March 15th, 2017 to April 2nd, 2017. In 2017, Alice was also paid $31220 in remuneration. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $4525

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("services",38,45)).
hospital_(span("Hospital",74,81)).
agent_(span("Hospital",74,81),span("Johns Hopkins Hospital",60,81)).
patient_(span("patient",96,102),span("Johns Hopkins Hospital",107,128)).
agent_(span("paid",10,13),span("Johns Hopkins Hospital",60,81)).
patient_(span("services",38,45),span("Johns Hopkins Hospital",60,81)).
medical_patient_(span("patient",96,102)).
income_(span("paid",196,199)).
start_(span("paid",196,199),span(20170101,175,178)).
agent_(span("paid",196,199),span("Alice",181,185)).
amount_(span("paid",196,199),span(31220,202,206)).
agent_(span("patient",96,102),span("Alice",84,88)).
start_(span("patient",96,102),span(20170315,135,150)).
end_(span("patient",96,102),span(20170402,155,169)).
patient_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(200,16,18)).
start_(span("paid",10,13),span(20170301,23,32)).
purpose_(span("paid",10,13),span("services",38,45)).
agent_(span("services",38,45),span("Alice",0,4)).
end_(span("services",38,45),span(20170402,155,169)).
start_(span("services",38,45),span(20170315,135,150)).

% Test
:- tax("Alice",2017,4525).
:- halt.
