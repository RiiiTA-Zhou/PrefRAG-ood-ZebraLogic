% Text
% Alice, born Jun 7, 1964, has a son, Bob, born Feb 7, 1988. Bob has a son, Charlie, born Jun 29, 2014. Alice, Bob and Charlie have the same principal place of abode in 2015. Bob's gross income in 2015 is $43591. Bob takes the standard deduction.

% Question
% How much tax does Bob have to pay in 2015? $6812

% Facts
:- [statutes/prolog/init].
birth_(span("born",7,10)).
agent_(span("born",7,10),span("Alice",0,4)).
start_(span("born",7,10),span(19640607,12,22)).
birth_(span("born",41,44)).
agent_(span("born",41,44),span("Bob",36,38)).
start_(span("born",41,44),span(19880207,46,56)).
birth_(span("born",83,86)).
agent_(span("born",83,86),span("Charlie",74,80)).
start_(span("born",83,86),span(20140629,88,99)).
son_(span("son",31,33)).
son_(span("son",69,71)).
residence_(span("abode",158,162)).
income_(span("income",185,190)).
agent_(span("income",185,190),span("Bob",173,175)).
start_(span("income",185,190),span(20150101,195,198)).
amount_(span("income",185,190),span(43591,204,208)).
agent_(span("abode",158,162),span("Alice",102,106)).
agent_(span("abode",158,162),span("Bob",109,111)).
agent_(span("abode",158,162),span("Charlie",117,123)).
patient_(span("abode",158,162),span("place",149,153)).
end_(span("abode",158,162),span(20151231,167,170)).
start_(span("abode",158,162),span(20150101,167,170)).
patient_(span("son",31,33),span("Alice",0,4)).
agent_(span("son",31,33),span("Bob",36,38)).
start_(span("son",31,33),span(19880207,46,56)).
patient_(span("son",69,71),span("Bob",59,61)).
agent_(span("son",69,71),span("Charlie",74,80)).
start_(span("son",69,71),span(20140629,88,99)).

% Test
:- tax("Bob",2015,6812).
:- halt.
