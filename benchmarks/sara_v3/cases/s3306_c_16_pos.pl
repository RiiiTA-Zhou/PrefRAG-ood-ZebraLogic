% Text
% Alice was paid $73200 in 2017 as an employee of the International Monetary Fund in Washington, D.C., USA.

% Question
% Section 3306(c)(16) applies to Alice's employment situation in 2017. Entailment

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("employee",36,43)).
international_organization_(span("International Monetary Fund",52,78)).
agent_(span("International Monetary Fund",52,78),span("International Monetary Fund",52,78)).
patient_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(73200,16,20)).
start_(span("paid",10,13),span(20170101,25,28)).
purpose_(span("paid",10,13),span("employee",36,43)).
agent_(span("paid",10,13),span("International Monetary Fund",52,78)).
agent_(span("employee",36,43),span("Alice",0,4)).
end_(span("employee",36,43),span(20171231,25,28)).
start_(span("employee",36,43),span(20170101,25,28)).
patient_(span("employee",36,43),span("International Monetary Fund",52,78)).
location_(span("employee",36,43),span("Washington, D.C.,",83,99)).
location_(span("employee",36,43),span("USA",101,103)).

% Test
:- s3306_c_16(span("employee",36,43),_).
:- halt.
