% Text
% Alice has a brother, Bob, who was born January 31st, 2014. Alice's gross income in 2015 was $260932. Bob lived at Alice's house in 2015. For 2015, Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2015? $81487

% Facts
:- [statutes/prolog/init].
brother_(span("brother",12,18)).
income_(span("income",73,78)).
residence_(span("lived",105,109)).
patient_(span("brother",12,18),span("Alice",0,4)).
agent_(span("brother",12,18),span("Bob",21,23)).
start_(span("brother",12,18),span(20140131,39,56)).
birth_(span("born",34,37)).
agent_(span("born",34,37),span("Bob",21,23)).
start_(span("born",34,37),span(20140131,39,56)).
agent_(span("income",73,78),span("Alice",59,63)).
start_(span("income",73,78),span(20150101,83,86)).
amount_(span("income",73,78),span(260932,93,98)).
agent_(span("lived",105,109),span("Bob",101,103)).
agent_(span("lived",105,109),span("Alice",114,118)).
patient_(span("lived",105,109),span("house",122,126)).
end_(span("lived",105,109),span(20151231,131,134)).
start_(span("lived",105,109),span(20150101,131,134)).

% Test
:- tax("Alice",2015,81487).
:- halt.
