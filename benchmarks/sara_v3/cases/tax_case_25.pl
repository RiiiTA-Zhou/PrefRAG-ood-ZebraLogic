% Text
% Bob is Charlie and Dorothy's son, born on April 15th, 2015. Alice married Charlie on August 8th, 2018. Alice's and Charlie's gross incomes in 2018 were $324311 and $414231 respectively. Alice, Bob and Charlie have the same principal place of abode in 2018. Alice and Charlie file jointly in 2018, and take the standard deduction.

% Question
% How much tax does Alice have to pay in 2018? $259487

% Facts
:- [statutes/prolog/init].
son_(span("son",29,31)).
marriage_(span("married",66,72)).
income_(span("Charlie's",115,123)).
income_(span("Alice's",103,109)).
residence_(span("abode",242,246)).
joint_return_(span("jointly",280,286)).
agent_(span("Charlie's",115,123),span("Charlie",115,121)).
agent_(span("Alice's",103,109),span("Alice",103,107)).
start_(span("Charlie's",115,123),span(20180101,142,145)).
start_(span("Alice's",103,109),span(20180101,142,145)).
amount_(span("Charlie's",115,123),span(414231,165,170)).
amount_(span("Alice's",103,109),span(324311,153,158)).
agent_(span("jointly",280,286),span("Alice",257,261)).
agent_(span("jointly",280,286),span("Charlie",267,273)).
start_(span("jointly",280,286),span(20180101,291,294)).
agent_(span("married",66,72),span("Alice",60,64)).
agent_(span("married",66,72),span("Charlie",74,80)).
start_(span("married",66,72),span(20180808,85,100)).
agent_(span("abode",242,246),span("Bob",193,195)).
agent_(span("abode",242,246),span("Charlie",201,207)).
patient_(span("abode",242,246),span("abode",242,246)).
end_(span("abode",242,246),span(20181231,251,254)).
start_(span("abode",242,246),span(20180101,251,254)).
agent_(span("abode",242,246),span("Alice",186,190)).
agent_(span("son",29,31),span("Bob",0,2)).
patient_(span("son",29,31),span("Charlie",7,13)).
patient_(span("son",29,31),span("Dorothy",19,25)).
start_(span("son",29,31),span(20150415,42,57)).
birth_(span("born",34,37)).
agent_(span("born",34,37),span("Bob",0,2)).
start_(span("born",34,37),span(20150415,42,57)).

% Test
:- tax("Alice",2018,259487).
:- halt.
