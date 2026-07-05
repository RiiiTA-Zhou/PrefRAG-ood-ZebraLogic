% Text
% Alice was paid $73200 in 2017 as an employee of Bertha's Mussels in Baltimore, Maryland, USA.

% Question
% Section 3306(c)(7) applies to Alice's employment situation in 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("employee",36,43)).
patient_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(73200,16,20)).
start_(span("paid",10,13),span(20170101,25,28)).
purpose_(span("paid",10,13),span("employee",36,43)).
agent_(span("paid",10,13),span("Bertha's Mussels",48,63)).
agent_(span("employee",36,43),span("Alice",0,4)).
end_(span("employee",36,43),span(20171231,25,28)).
start_(span("employee",36,43),span(20170101,25,28)).
patient_(span("employee",36,43),span("Bertha's Mussels",48,63)).
location_(span("employee",36,43),span("Baltimore",68,76)).
location_(span("employee",36,43),span("Maryland",79,86)).
location_(span("employee",36,43),span("USA",89,91)).

% Test
:- \+ s3306_c_7(span("employee",36,43),_).
:- halt.
