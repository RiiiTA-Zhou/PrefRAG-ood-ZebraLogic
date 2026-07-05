% Text
% In 2017, Alice's gross income was $33200. Alice and Bob have been married since Feb 3rd, 2017. Alice has been blind since October 4, 2013. Alice and Bob file jointly in 2017. Bob has no gross income in 2017. Alice and Bob take the standard deduction. Alice and Bob have the same principal place of abode from 2017 to 2020.

% Question
% How much tax does Alice have to pay in 2017? $3390

% Facts
:- [statutes/prolog/init].
income_(span("income",23,28)).
marriage_(span("married",66,72)).
blindness_(span("blind",110,114)).
joint_return_(span("jointly",158,164)).
residence_(span("abode",298,302)).
agent_(span("blind",110,114),span("Alice",95,99)).
start_(span("blind",110,114),span(20131004,122,136)).
start_(span("income",23,28),span(20170101,3,6)).
agent_(span("income",23,28),span("Alice",9,13)).
amount_(span("income",23,28),span(33200,35,39)).
agent_(span("jointly",158,164),span("Alice",139,143)).
agent_(span("jointly",158,164),span("Bob",149,151)).
start_(span("jointly",158,164),span(20170101,169,172)).
agent_(span("married",66,72),span("Alice",42,46)).
agent_(span("married",66,72),span("Bob",52,54)).
start_(span("married",66,72),span(20170203,80,92)).
agent_(span("abode",298,302),span("Alice",251,255)).
agent_(span("abode",298,302),span("Bob",261,263)).
patient_(span("abode",298,302),span("place",289,293)).
start_(span("abode",298,302),span(20170101,309,312)).
end_(span("abode",298,302),span(20201231,317,320)).

% Test
:- tax("Alice",2017,3390).
:- halt.
