% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice was a nonresident alien until July 9th, 2014. Bob died September 16th, 2017. Alice's gross income in 2013 was $71414. Bob's gross income in 2013 was $56404. Alice files separately and takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2013? $17783

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
nonresident_alien_(span("nonresident alien",56,72)).
death_(span("died",100,103)).
income_(span("income",141,146)).
income_(span("income",180,185)).
agent_(span("died",100,103),span("Bob",96,98)).
start_(span("died",100,103),span(20170916,105,124)).
agent_(span("income",141,146),span("Alice",127,131)).
start_(span("income",141,146),span(20130101,151,154)).
amount_(span("income",141,146),span(71414,161,165)).
agent_(span("income",180,185),span("Bob",168,170)).
start_(span("income",180,185),span(20130101,190,193)).
amount_(span("income",180,185),span(56404,200,204)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).
agent_(span("nonresident alien",56,72),span("Alice",44,48)).
end_(span("nonresident alien",56,72),span(20140709,80,93)).

% Test
:- tax("Alice",2013,17783).
:- halt.
