% Text
% Alice was paid $73200 in 2017 as an employee of the State of Maryland in Baltimore, Maryland, USA.

% Question
% Section 3306(c)(7) applies to Alice's employment situation in 2017. Entailment

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("employee",36,43)).
patient_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(73200,16,20)).
start_(span("paid",10,13),span(20170101,25,28)).
purpose_(span("paid",10,13),span("employee",36,43)).
agent_(span("paid",10,13),span("State of Maryland",52,68)).
agent_(span("employee",36,43),span("Alice",0,4)).
end_(span("employee",36,43),span(20171231,25,28)).
start_(span("employee",36,43),span(20170101,25,28)).
patient_(span("employee",36,43),span("State of Maryland",52,68)).
location_(span("employee",36,43),span("Maryland",84,91)).
location_(span("employee",36,43),span("Baltimore",73,81)).
location_(span("employee",36,43),span("USA",94,96)).

% Test
:- s3306_c_7(span("employee",36,43),_).
:- halt.
