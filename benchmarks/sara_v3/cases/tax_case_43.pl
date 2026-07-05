% Text
% In 2017, Alice was paid $23191. Alice and Bob got married on Feb 3rd, 1992. Alice was a nonresident alien until July 9th, 2014. Bob earned $34081 in 2017. Alice and Bob file jointly in 2017 and take the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $8439

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
marriage_(span("married",50,56)).
nonresident_alien_(span("nonresident alien",88,104)).
income_(span("earned",132,137)).
joint_return_(span("file jointly",169,180)).
agent_(span("earned",132,137),span("Bob",128,130)).
amount_(span("earned",132,137),span(34081,140,144)).
start_(span("earned",132,137),span(20170101,149,152)).
agent_(span("file jointly",169,180),span("Alice",155,159)).
agent_(span("file jointly",169,180),span("Bob",165,167)).
start_(span("file jointly",169,180),span(20170101,185,188)).
agent_(span("married",50,56),span("Alice",32,36)).
agent_(span("married",50,56),span("Bob",42,44)).
start_(span("married",50,56),span(19920203,61,73)).
agent_(span("nonresident alien",88,104),span("Alice",76,80)).
end_(span("nonresident alien",88,104),span(20140709,112,125)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(23191,25,29)).

% Test
:- tax("Alice",2017,8439).
:- halt.
