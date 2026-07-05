% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice was a nonresident alien. Alice died on July 9th, 2014. Bob married Charlie on September 14th, 2015. Bob's gross income for the year 2015 is $28864, Charlie's gross income is $27953. Bob and Charlie file jointly in 2015 and take the standard deduction.

% Question
% How much tax does Bob have to pay in 2015? $8312

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
nonresident_alien_(span("nonresident alien",56,72)).
death_(span("died",81,84)).
marriage_(span("married",109,115)).
income_(span("income",162,167)).
income_(span("income",214,219)).
joint_return_(span("file jointly",248,259)).
agent_(span("died",81,84),span("Alice",75,79)).
start_(span("died",81,84),span(20140709,89,102)).
agent_(span("income",162,167),span("Bob",150,152)).
start_(span("income",162,167),span(20150101,182,185)).
amount_(span("income",162,167),span(28864,191,195)).
agent_(span("income",214,219),span("Charlie",198,204)).
amount_(span("income",214,219),span(27953,225,229)).
start_(span("income",214,219),span(20150101,182,185)).
agent_(span("file jointly",248,259),span("Bob",232,234)).
agent_(span("file jointly",248,259),span("Charlie",240,246)).
start_(span("file jointly",248,259),span(20150101,264,267)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).
agent_(span("married",109,115),span("Bob",105,107)).
agent_(span("married",109,115),span("Charlie",117,123)).
start_(span("married",109,115),span(20150914,128,147)).
agent_(span("nonresident alien",56,72),span("Alice",44,48)).

% Test
:- tax("Bob",2015,8312).
:- halt.
