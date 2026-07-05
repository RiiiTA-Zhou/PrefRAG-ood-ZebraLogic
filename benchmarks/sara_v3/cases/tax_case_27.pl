% Text
% In 2017, Alice was paid $33200. Bob is Alice's father since April 15th, 1978. In 2017, Alice and Bob lived in a house that Alice maintained. In 2017, Alice takes the standard deduction. Bob had no income in 2017.

% Question
% How much tax does Alice have to pay in 2017? $3720

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
father_(span("father",47,52)).
residence_(span("lived",101,105)).
payment_(span("maintained",129,138)).
agent_(span("father",47,52),span("Bob",32,34)).
patient_(span("father",47,52),span("Alice",39,43)).
start_(span("father",47,52),span(19780415,60,75)).
purpose_(span("maintained",129,138),span("house",112,116)).
agent_(span("maintained",129,138),span("Alice",123,127)).
amount_(span("maintained",129,138),span(1,129,138)).
start_(span("maintained",129,138),span(20170101,81,84)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).
agent_(span("lived",101,105),span("Alice",87,91)).
agent_(span("lived",101,105),span("Bob",97,99)).
patient_(span("lived",101,105),span("house",112,116)).
end_(span("lived",101,105),span(20171231,81,84)).
start_(span("lived",101,105),span(20170101,81,84)).

% Test
:- tax("Alice",2017,3720).
:- halt.
