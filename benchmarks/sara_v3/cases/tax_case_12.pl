% Text
% Alice paid Bob for agricultural labor from Feb 1st, 2019 to November 19th, 2019, paying him $27371 in 2019. On November 25th, Bob died from a heart attack. On January 20th, 2020, Alice paid Charlie, Bob's surviving spouse, Bob's outstanding wages of $24500. In 2020, Alice's gross income was $372109. Alice receives a deduction of $25000 for donating goods to a food bank.

% Question
% How much tax does Alice have to pay in 2020? $118227

% Facts
:- [statutes/prolog/init].
payment_(span("paid",6,9)).
service_(span("labor",32,36)).
death_(span("died",130,133)).
payment_(span("paid",185,188)).
marriage_(span("spouse",215,220)).
payment_(span("income",281,286)).
deduction_(span("deduction",318,326)).
start_(span("died",130,133),span(20191125,111,123)).
agent_(span("died",130,133),span("Bob",126,128)).
start_(span("deduction",318,326),span(20200101,261,264)).
agent_(span("deduction",318,326),span("Alice",301,305)).
amount_(span("deduction",318,326),span(25000,332,336)).
agent_(span("spouse",215,220),span("Charlie",190,196)).
agent_(span("spouse",215,220),span("Bob",199,201)).
agent_(span("paid",6,9),span("Alice",0,4)).
patient_(span("paid",6,9),span("Bob",11,13)).
purpose_(span("paid",6,9),span("labor",32,36)).
start_(span("paid",6,9),span(20190101,102,105)).
amount_(span("paid",6,9),span(27371,93,97)).
purpose_(span("paid",185,188),span("labor",32,36)).
start_(span("paid",185,188),span(20200120,159,176)).
agent_(span("paid",185,188),span("Alice",179,183)).
patient_(span("paid",185,188),span("Charlie",190,196)).
amount_(span("paid",185,188),span(24500,251,255)).
start_(span("income",281,286),span(20200101,261,264)).
patient_(span("income",281,286),span("Alice",267,271)).
amount_(span("income",281,286),span(372109,293,298)).
patient_(span("labor",32,36),span("Alice",0,4)).
agent_(span("labor",32,36),span("Bob",11,13)).
purpose_(span("labor",32,36),span("agricultural labor",19,36)).
start_(span("labor",32,36),span(20190201,43,55)).
end_(span("labor",32,36),span(20191119,60,78)).

% Test
:- tax("Alice",2020,118227).
:- halt.
