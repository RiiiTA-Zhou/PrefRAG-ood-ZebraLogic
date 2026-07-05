% Text
% In 2017, Alice was paid $33200. Alice and Bob have been married since Feb 3rd, 2017. Bob had no income in 2017. In 2017, Alice and Bob file separately, and Alice takes the standard deduction. Alice and Bob have the same principal place of abode in 2017.

% Question
% How much tax does Alice have to pay in 2017? $4938

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
marriage_(span("married",56,62)).
residence_(span("abode",239,243)).
agent_(span("married",56,62),span("Alice",32,36)).
agent_(span("married",56,62),span("Bob",42,44)).
start_(span("married",56,62),span(20170203,70,82)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).
agent_(span("abode",239,243),span("Alice",192,196)).
agent_(span("abode",239,243),span("Bob",202,204)).
patient_(span("abode",239,243),span("place",230,234)).
end_(span("abode",239,243),span(20171231,248,251)).
start_(span("abode",239,243),span(20170101,248,251)).

% Test
:- tax("Alice",2017,4938).
:- halt.
