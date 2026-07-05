% Text
% In 2017, Alice was paid $117192. Alice and Bob got married on Feb 3rd, 2017. Alice was a nonresident alien from August 23rd, 2016 to September 15th, 2018. Bob earned $37820 in 2017. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $34233

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
marriage_(span("married",51,57)).
nonresident_alien_(span("nonresident alien",89,105)).
income_(span("earned",159,164)).
agent_(span("earned",159,164),span("Bob",155,157)).
amount_(span("earned",159,164),span(37820,167,171)).
start_(span("earned",159,164),span(20170101,176,179)).
agent_(span("married",51,57),span("Alice",33,37)).
agent_(span("married",51,57),span("Bob",43,45)).
start_(span("married",51,57),span(20170203,62,74)).
agent_(span("nonresident alien",89,105),span("Alice",77,81)).
start_(span("nonresident alien",89,105),span(20160823,112,128)).
end_(span("nonresident alien",89,105),span(20180815,133,152)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(117192,25,30)).

% Test
:- tax("Alice",2017,34233).
:- halt.
