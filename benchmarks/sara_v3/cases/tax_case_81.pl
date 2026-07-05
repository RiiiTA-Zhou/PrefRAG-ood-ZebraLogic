% Text
% In 2012, Alice was paid $54268 in remuneration and takes the standard deduction. In addition, Alice has paid $11571 to Bob for work done from Feb 1st, 2012 to Sep 1st, 2012, in Caracas, Venezuela. Bob is an American citizen. Alice is not an American employer.

% Question
% How much tax does Alice have to pay in 2012? $10922

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
payment_(span("paid",104,107)).
service_(span("work",127,130)).
citizenship_(span("citizen",216,222)).
agent_(span("citizen",216,222),span("Bob",197,199)).
agent_(span("paid",104,107),span("Alice",94,98)).
amount_(span("paid",104,107),span(11571,110,114)).
patient_(span("paid",104,107),span("Bob",119,121)).
purpose_(span("paid",104,107),span("work",127,130)).
start_(span("paid",104,107),span(20120901,159,171)).
start_(span("paid",19,22),span(20120101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(54268,25,29)).
patient_(span("work",127,130),span("Alice",94,98)).
agent_(span("work",127,130),span("Bob",119,121)).
start_(span("work",127,130),span(20120201,142,154)).
end_(span("work",127,130),span(20120901,159,171)).
location_(span("work",127,130),span("Caracas, Venezuela",177,194)).
country_(span("Caracas, Venezuela",177,194),span("Venezuela",186,194)).
patient_(span("citizen",216,222),span("American",207,214)).

% Test
:- tax("Alice",2012,10922).
:- halt.
