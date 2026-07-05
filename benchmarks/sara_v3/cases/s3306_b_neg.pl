% Text
% Over the year 2018, Alice has paid $2325 in hay to Bob for agricultural labor.

% Question
% Section 3306(b) applies to the payment in hay made by Alice to Bob for the year 2018. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",30,33)).
service_(span("labor",72,76)).
start_(span("paid",30,33),span(20180101,14,17)).
agent_(span("paid",30,33),span("Alice",20,24)).
amount_(span("paid",30,33),span(2325,36,39)).
means_(span("paid",30,33),span("hay",44,46)).
patient_(span("paid",30,33),span("Bob",51,53)).
purpose_(span("paid",30,33),span("labor",72,76)).
end_(span("labor",72,76),span(20181231,14,17)).
start_(span("labor",72,76),span(20180101,14,17)).
patient_(span("labor",72,76),span("Alice",20,24)).
agent_(span("labor",72,76),span("Bob",51,53)).
purpose_(span("labor",72,76),span("agricultural labor",59,76)).

% Test
:- \+ s3306_b(_,span("paid",30,33),_,"Alice","Bob","Alice","Bob",_).
:- halt.
