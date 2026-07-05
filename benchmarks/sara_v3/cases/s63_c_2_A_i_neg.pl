% Text
% In 2017, Alice was paid $33200 in remuneration. Alice and Bob have been married since Feb 3rd, 2017. Alice and Bob file separate returns in 2017.

% Question
% Section 63(c)(2)(A)(i) applies to Alice in 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
marriage_(span("married",72,78)).
agent_(span("married",72,78),span("Alice",48,52)).
agent_(span("married",72,78),span("Bob",58,60)).
start_(span("married",72,78),span(20170203,86,98)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).

% Test
:- \+ s63_c_2_A_i("Alice",_,2017).
:- halt.
