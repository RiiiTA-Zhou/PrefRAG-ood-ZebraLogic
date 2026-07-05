% Text
% Alice and Bob got married on Feb 3rd, 1998, and have a son Charlie, born April 1st, 1999. Bob died on Jan 1st, 2017. In 2019, Charlie lives at the house that Alice maintains as her principal place of abode. Alice's gross income for the year 2019 is $236422. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2019? $62000

% Facts
:- [statutes/prolog/init].
birth_(span("born",68,71)).
agent_(span("born",68,71),span("Charlie",59,65)).
start_(span("born",68,71),span(19990401,73,87)).
marriage_(span("married",18,24)).
son_(span("son",55,57)).
death_(span("died",94,97)).
residence_(span("lives",134,138)).
payment_(span("maintains",164,172)).
residence_(span("abode",200,204)).
income_(span("income",221,226)).
agent_(span("died",94,97),span("Bob",90,92)).
start_(span("died",94,97),span(20170101,102,114)).
agent_(span("income",221,226),span("Alice",207,211)).
start_(span("income",221,226),span(20190101,241,244)).
amount_(span("income",221,226),span(236422,250,255)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19980203,29,41)).
start_(span("maintains",164,172),span(20190101,120,123)).
purpose_(span("maintains",164,172),span("house",147,151)).
agent_(span("maintains",164,172),span("Alice",158,162)).
amount_(span("maintains",164,172),span(1,164,172)).
start_(span("lives",134,138),span(20190101,120,123)).
agent_(span("lives",134,138),span("Charlie",126,132)).
patient_(span("lives",134,138),span("house",147,151)).
end_(span("lives",134,138),span(20191231,120,123)).
start_(span("abode",200,204),span(20190101,120,123)).
patient_(span("abode",200,204),span("house",147,151)).
agent_(span("abode",200,204),span("Alice",158,162)).
end_(span("abode",200,204),span(20191231,120,123)).
patient_(span("son",55,57),span("Alice",0,4)).
patient_(span("son",55,57),span("Bob",10,12)).
agent_(span("son",55,57),span("Charlie",59,65)).
start_(span("son",55,57),span(19990401,73,87)).

% Test
:- tax("Alice",2019,62000).
:- halt.
