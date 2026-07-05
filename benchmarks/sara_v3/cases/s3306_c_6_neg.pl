% Text
% Alice was paid $73200 in 2017 as an employee of Nando's Chicken in Arlington, Virginia, USA.

% Question
% Section 3306(c)(6) applies to Alice's employment situation in 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("employee",36,43)).
patient_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(73200,16,20)).
start_(span("paid",10,13),span(20170101,25,28)).
purpose_(span("paid",10,13),span("employee",36,43)).
agent_(span("paid",10,13),span("Nando's Chicken",48,62)).
agent_(span("employee",36,43),span("Alice",0,4)).
end_(span("employee",36,43),span(20171231,25,28)).
start_(span("employee",36,43),span(20170101,25,28)).
patient_(span("employee",36,43),span("Nando's Chicken",48,62)).
location_(span("employee",36,43),span("Arlington",67,75)).
location_(span("employee",36,43),span("Virginia",78,85)).
location_(span("employee",36,43),span("USA",88,90)).

% Test
:- \+ s3306_c_6(span("employee",36,43)).
:- halt.
