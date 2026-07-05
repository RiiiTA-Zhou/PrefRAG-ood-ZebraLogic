% Text
% In 2012, Alice was paid $54268 in remuneration. In addition, Alice has paid $11571 to Bob for work done from Feb 1st, 2012 to Sep 1st, 2012, in Caracas, Venezuela. Alice is an American employer, and Bob is an American citizen. Bob takes the standard deduction in 2012.

% Question
% How much tax does Bob have to pay in 2012? $986

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
payment_(span("paid",71,74)).
service_(span("work",94,97)).
american_employer_(span("American employer",176,192)).
citizenship_(span("citizen",218,224)).
agent_(span("American employer",176,192),span("Alice",164,168)).
agent_(span("citizen",218,224),span("Bob",199,201)).
agent_(span("paid",71,74),span("Alice",61,65)).
amount_(span("paid",71,74),span(11571,77,81)).
patient_(span("paid",71,74),span("Bob",86,88)).
purpose_(span("paid",71,74),span("work",94,97)).
start_(span("paid",71,74),span(20120901,126,138)).
start_(span("paid",19,22),span(20120101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(54268,25,29)).
patient_(span("work",94,97),span("Alice",61,65)).
agent_(span("work",94,97),span("Bob",86,88)).
start_(span("work",94,97),span(20120201,109,121)).
end_(span("work",94,97),span(20120901,126,138)).
location_(span("work",94,97),span("Caracas, Venezuela",144,161)).
country_(span("Caracas, Venezuela",144,161),span("Venezuela",153,161)).
patient_(span("citizen",218,224),span("American",209,216)).

% Test
:- tax("Bob",2012,986).
:- halt.
