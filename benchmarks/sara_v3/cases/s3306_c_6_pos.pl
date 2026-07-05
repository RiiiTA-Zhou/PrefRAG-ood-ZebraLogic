% Text
% Alice was paid $73200 in 2017 as an employee of the United States Government in Arlington, Virginia, USA.

% Question
% Section 3306(c)(6) applies to Alice's employment situation in 2017. Entailment

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("employee",36,43)).
patient_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(73200,16,20)).
start_(span("paid",10,13),span(20170101,25,28)).
purpose_(span("paid",10,13),span("employee",36,43)).
agent_(span("paid",10,13),span("United States Government",52,75)).
agent_(span("employee",36,43),span("Alice",0,4)).
end_(span("employee",36,43),span(20171231,25,28)).
start_(span("employee",36,43),span(20170101,25,28)).
patient_(span("employee",36,43),span("United States Government",52,75)).
location_(span("employee",36,43),span("Arlington",80,88)).
location_(span("employee",36,43),span("Virginia",91,98)).
location_(span("employee",36,43),span("USA",101,103)).

% Test
:- s3306_c_6(span("employee",36,43)).
:- halt.
