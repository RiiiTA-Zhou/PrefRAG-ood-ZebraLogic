% Text
% Bob, Alice's father, has the same principal place of abode as Alice since 2012, and has had no income since. Alice's gross income for the year 2015 is $102268. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2015? $25055

% Facts
:- [statutes/prolog/init].
father_(span("father",13,18)).
residence_(span("abode",53,57)).
income_(span("income",123,128)).
agent_(span("father",13,18),span("Bob",0,2)).
patient_(span("father",13,18),span("Alice",5,9)).
agent_(span("income",123,128),span("Alice",109,113)).
start_(span("income",123,128),span(20150101,143,146)).
amount_(span("income",123,128),span(102268,152,157)).
agent_(span("abode",53,57),span("Bob",0,2)).
patient_(span("abode",53,57),span("place",44,48)).
agent_(span("abode",53,57),span("Alice",62,66)).
start_(span("abode",53,57),span(20120101,74,77)).

% Test
:- tax("Alice",2015,25055).
:- halt.
