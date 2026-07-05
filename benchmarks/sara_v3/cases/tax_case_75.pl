% Text
% Alice shares a house with her father Bob since 2007. Alice pays for 75% of the costs of the house, while Charlie, her brother, pays for the remaining 25%. Alice's gross income for the year 2012 was $67285 and Charlie's income was $56174. Alice is allowed itemized deductions of $17817.

% Question
% How much tax does Alice have to pay in 2012? $8883

% Facts
:- [statutes/prolog/init].
start_(span("pays",59,62),span(Day,47,50)) :- between(2007,2017,Year),
    first_day_year(Year,Day).
start_(span("pays",127,130),span(Day,47,50)) :- between(2007,2017,Year),
    first_day_year(Year,Day).
residence_(span("house",15,19)).
father_(span("father",30,35)).
payment_(span("pays",59,62)).
brother_(span("brother",118,124)).
payment_(span("pays",127,130)).
income_(span("income",169,174)).
income_(span("income",219,224)).
deduction_(span("deductions",264,273)).
agent_(span("brother",118,124),span("Charlie",105,111)).
patient_(span("brother",118,124),span("Alice",53,57)).
start_(span("deductions",264,273),span(20120101,189,192)).
agent_(span("deductions",264,273),span("Alice",238,242)).
amount_(span("deductions",264,273),span(17817,279,283)).
patient_(span("father",30,35),span("Alice",0,4)).
agent_(span("father",30,35),span("Bob",37,39)).
agent_(span("income",169,174),span("Alice",155,159)).
start_(span("income",169,174),span(20120101,189,192)).
amount_(span("income",169,174),span(67285,199,203)).
start_(span("income",219,224),span(20120101,189,192)).
agent_(span("income",219,224),span("Charlie",209,215)).
amount_(span("income",219,224),span(56174,231,235)).
purpose_(span("pays",59,62),span("house",15,19)).
agent_(span("pays",59,62),span("Alice",53,57)).
amount_(span("pays",59,62),span(75,68,69)).
purpose_(span("pays",127,130),span("house",15,19)).
amount_(span("pays",127,130),span(25,150,151)).
agent_(span("pays",127,130),span("Charlie",105,111)).
agent_(span("house",15,19),span("Alice",0,4)).
patient_(span("house",15,19),span("house",15,19)).
agent_(span("house",15,19),span("Bob",37,39)).
start_(span("house",15,19),span(20070101,47,50)).

% Test
:- tax("Alice",2012,8883).
:- halt.
