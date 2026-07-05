% Text
% In 2017, Alice was paid $36266. Alice and Bob have been married since Feb 3rd, 2017. Alice was born March 2nd, 1950 and Bob was born March 3rd, 1951. Bob had no income in 2017. Alice and Bob file separately in 2017. Alice takes the standard deduction. Alice and Bob have the same principal place of abode in 2017.

% Question
% How much tax does Alice have to pay in 2017? $5460

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
marriage_(span("married",56,62)).
birth_(span("born",95,98)).
birth_(span("born",128,131)).
residence_(span("abode",299,303)).
agent_(span("born",95,98),span("Alice",85,89)).
start_(span("born",95,98),span(19500302,100,114)).
agent_(span("born",128,131),span("Bob",120,122)).
start_(span("born",128,131),span(19510303,133,147)).
agent_(span("married",56,62),span("Alice",32,36)).
agent_(span("married",56,62),span("Bob",42,44)).
start_(span("married",56,62),span(20170203,70,82)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(36266,25,29)).
agent_(span("abode",299,303),span("Alice",252,256)).
agent_(span("abode",299,303),span("Bob",262,264)).
patient_(span("abode",299,303),span("place",290,294)).
end_(span("abode",299,303),span(20171231,308,311)).
start_(span("abode",299,303),span(20170101,308,311)).

% Test
:- tax("Alice",2017,5460).
:- halt.
