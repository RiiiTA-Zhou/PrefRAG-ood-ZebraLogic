% Text
% In 2017, Alice was paid $33200. Alice and Bob got married on Feb 3rd, 2017. Alice was a nonresident alien from August 23rd, 2015 to September 15th, 2016.

% Question
% Section 63(c)(6)(B) applies to Alice for 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
marriage_(span("married",50,56)).
nonresident_alien_(span("nonresident alien",88,104)).
agent_(span("married",50,56),span("Alice",32,36)).
agent_(span("married",50,56),span("Bob",42,44)).
start_(span("married",50,56),span(20170203,61,73)).
agent_(span("nonresident alien",88,104),span("Alice",76,80)).
start_(span("nonresident alien",88,104),span(20150823,111,127)).
end_(span("nonresident alien",88,104),span(20160915,132,151)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).

% Test
:- \+ s63_c_6_B("Alice",2017).
:- halt.
