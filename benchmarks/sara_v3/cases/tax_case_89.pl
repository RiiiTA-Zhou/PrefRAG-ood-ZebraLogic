% Text
% In 2018, Alice was paid $3200. Alice and Bob have been married since Feb 3rd, 2017. Alice and Bob file separate returns and each take their standard deduction. Bob had no income in 2018. Alice has been blind since March 20, 2016. Alice was enrolled at Johns Hopkins University and attending classes from August 29, 2015 to May 30th, 2019.

% Question
% How much tax does Alice have to pay in 2018? $0

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
marriage_(span("married",55,61)).
blindness_(span("blind",202,206)).
enrollment_(span("enrolled",240,247)).
educational_institution_(span("University",266,275)).
attending_classes_(span("attending classes",281,297)).
agent_(span("attending classes",281,297),span("Alice",230,234)).
location_(span("attending classes",281,297),span("Johns Hopkins University",252,275)).
start_(span("attending classes",281,297),span(20150829,304,318)).
end_(span("attending classes",281,297),span(20190530,323,336)).
agent_(span("blind",202,206),span("Alice",187,191)).
start_(span("blind",202,206),span(20160320,214,227)).
agent_(span("University",266,275),span("Johns Hopkins University",252,275)).
agent_(span("enrolled",240,247),span("Alice",230,234)).
patient_(span("enrolled",240,247),span("Johns Hopkins University",252,275)).
start_(span("enrolled",240,247),span(20150829,304,318)).
end_(span("enrolled",240,247),span(20190530,323,336)).
agent_(span("married",55,61),span("Alice",31,35)).
agent_(span("married",55,61),span("Bob",41,43)).
start_(span("married",55,61),span(20170203,69,81)).
start_(span("paid",19,22),span(20180101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(3200,25,28)).

% Test
:- tax("Alice",2018,0).
:- halt.
