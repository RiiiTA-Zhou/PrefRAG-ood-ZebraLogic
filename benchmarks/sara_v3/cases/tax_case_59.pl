% Text
% Bob is Charlie and Dorothy's son, born April 15th, 2015. Alice married Charlie on August 8th, 2018. Alice was paid $73200 in 2020 as an employee of the United States Government in Arlington, Virginia, USA. Alice files a separate return and takes the standard deduction. Since 2019, Alice, Bob and Charlie live in a house maintained by Alice and Charlie.

% Question
% How much tax does Alice have to pay in 2020? $15236

% Facts
:- [statutes/prolog/init].
son_(span("son",29,31)).
birth_(span("born",34,37)).
agent_(span("born",34,37),span("Bob",0,2)).
start_(span("born",34,37),span(20150415,39,54)).
marriage_(span("married",63,69)).
payment_(span("paid",110,113)).
service_(span("employee",136,143)).
residence_(span("live",305,308)).
payment_(span("maintained",321,330)).
agent_(span("married",63,69),span("Alice",57,61)).
agent_(span("married",63,69),span("Charlie",71,77)).
start_(span("married",63,69),span(20180808,82,97)).
start_(span("maintained",321,330),span(20200101,276,279)).
amount_(span("maintained",321,330),span(1,321,330)).
start_(span("maintained",321,330),span(20190101,276,279)).
agent_(span("maintained",321,330),span("Alice",335,339)).
agent_(span("maintained",321,330),span("Charlie",345,351)).
patient_(span("paid",110,113),span("Alice",100,104)).
amount_(span("paid",110,113),span(73200,116,120)).
start_(span("paid",110,113),span(20200101,125,128)).
purpose_(span("paid",110,113),span("employee",136,143)).
agent_(span("paid",110,113),span("United States Government",152,175)).
start_(span("live",305,308),span(20190101,276,279)).
agent_(span("live",305,308),span("Bob",289,291)).
agent_(span("live",305,308),span("Charlie",297,303)).
patient_(span("live",305,308),span("house",315,319)).
agent_(span("live",305,308),span("Alice",335,339)).
agent_(span("employee",136,143),span("Alice",100,104)).
end_(span("employee",136,143),span(20201231,125,128)).
start_(span("employee",136,143),span(20200101,125,128)).
patient_(span("employee",136,143),span("United States Government",152,175)).
location_(span("employee",136,143),span("Arlington",180,188)).
location_(span("employee",136,143),span("Virginia",191,198)).
location_(span("employee",136,143),span("USA",201,203)).
agent_(span("son",29,31),span("Bob",0,2)).
patient_(span("son",29,31),span("Charlie",7,13)).
patient_(span("son",29,31),span("Dorothy",19,25)).
start_(span("son",29,31),span(20150415,39,54)).

% Test
:- tax("Alice",2020,15236).
:- halt.
