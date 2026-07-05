% Text
% Alice was paid $200 in March 2017 for services performed at Johns Hopkins Hospital. Alice was a patient at Johns Hopkins Hospital from March 15th, 2017 to April 2nd, 2017. Bob is Alice's son since April 15th, 2014. Bob and Alice have the same principal place of abode, a house maintained by Alice. Alice takes the standard deduction in 2017.

% Question
% How much tax does Alice have to pay in 2017? $0

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("services",38,45)).
hospital_(span("Hospital",74,81)).
medical_patient_(span("patient",96,102)).
son_(span("son",187,189)).
residence_(span("abode",262,266)).
payment_(span("maintained",277,286)).
agent_(span("Hospital",74,81),span("Johns Hopkins Hospital",60,81)).
agent_(span("patient",96,102),span("Alice",84,88)).
patient_(span("patient",96,102),span("Johns Hopkins Hospital",107,128)).
start_(span("patient",96,102),span(20170315,135,150)).
end_(span("patient",96,102),span(20170402,155,169)).
purpose_(span("maintained",277,286),span("house",271,275)).
agent_(span("maintained",277,286),span("Alice",291,295)).
amount_(span("maintained",277,286),span(1,277,286)).
start_(span("maintained",277,286),span(20170101,336,339)).
patient_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(200,16,18)).
start_(span("paid",10,13),span(20170301,23,32)).
purpose_(span("paid",10,13),span("services",38,45)).
agent_(span("paid",10,13),span("Johns Hopkins Hospital",60,81)).
agent_(span("abode",262,266),span("Bob",215,217)).
agent_(span("abode",262,266),span("Alice",223,227)).
patient_(span("abode",262,266),span("house",271,275)).
end_(span("abode",262,266),span(20171231,336,339)).
start_(span("abode",262,266),span(20170101,336,339)).
agent_(span("services",38,45),span("Alice",0,4)).
end_(span("services",38,45),span(20170331,23,32)).
patient_(span("services",38,45),span("Johns Hopkins Hospital",60,81)).
start_(span("services",38,45),span(20170315,135,150)).
agent_(span("son",187,189),span("Bob",172,174)).
patient_(span("son",187,189),span("Alice",179,183)).
start_(span("son",187,189),span(20140415,197,212)).

% Test
:- tax("Alice",2017,0).
:- halt.
