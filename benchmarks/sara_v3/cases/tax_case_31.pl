% Text
% In 2017, Alice was paid $39212, and Bob had no income. Alice and Bob have been married since Feb 3rd, 2017. Alice and Bob file separately in 2017.

% Question
% How much tax does Alice have to pay in 2017? $6621

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
marriage_(span("married",79,85)).
agent_(span("married",79,85),span("Alice",55,59)).
agent_(span("married",79,85),span("Bob",65,67)).
start_(span("married",79,85),span(20170203,93,105)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(39212,25,29)).

% Test
:- tax("Alice",2017,6621).
:- halt.
