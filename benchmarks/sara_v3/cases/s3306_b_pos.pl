% Text
% Over the year 2018, Alice has paid $2325 in cash to Bob for walking her dog.

% Question
% Section 3306(b) applies to the money paid by Alice to Bob for the year 2018. Entailment

% Facts
:- [statutes/prolog/init].
payment_(span("paid",30,33)).
service_(span("walking",60,66)).
start_(span("paid",30,33),span(20180101,14,17)).
agent_(span("paid",30,33),span("Alice",20,24)).
amount_(span("paid",30,33),span(2325,36,39)).
means_(span("paid",30,33),span("cash",44,47)).
patient_(span("paid",30,33),span("Bob",52,54)).
purpose_(span("paid",30,33),span("walking",60,66)).
end_(span("walking",60,66),span(20181231,14,17)).
start_(span("walking",60,66),span(20180101,14,17)).
patient_(span("walking",60,66),span("Alice",20,24)).
agent_(span("walking",60,66),span("Bob",52,54)).
purpose_(span("walking",60,66),span("walking",60,66)).

% Test
:- s3306_b(_,span("paid",30,33),_,"Alice","Bob","Alice","Bob",_).
:- halt.
