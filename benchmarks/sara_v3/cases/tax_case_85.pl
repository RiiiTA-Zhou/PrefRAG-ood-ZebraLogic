% Text
% In 2019, Alice was paid $34510. Alice has a brother, Charlie, whose son Bob lived at Alice's place in 2019, a house that she maintains. In 2019, Charlie had a different principal place of abode, and Bob had no income. Alice takes the standard deduction in 2019.

% Question
% How much tax does Alice have to pay in 2019? $2477

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
brother_(span("brother",44,50)).
son_(span("son",68,70)).
residence_(span("lived",76,80)).
residence_(span("place",93,97)).
payment_(span("maintains",125,133)).
residence_(span("abode",188,192)).
patient_(span("brother",44,50),span("Alice",32,36)).
agent_(span("brother",44,50),span("Charlie",53,59)).
agent_(span("maintains",125,133),span("Alice",85,89)).
purpose_(span("maintains",125,133),span("house",110,114)).
amount_(span("maintains",125,133),span(1,125,133)).
start_(span("maintains",125,133),span(20190101,102,105)).
start_(span("paid",19,22),span(20190101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(34510,25,29)).
agent_(span("place",93,97),span("Alice",85,89)).
patient_(span("place",93,97),span("house",110,114)).
end_(span("place",93,97),span(20191231,102,105)).
start_(span("place",93,97),span(20190101,102,105)).
agent_(span("lived",76,80),span("Bob",72,74)).
patient_(span("lived",76,80),span("house",110,114)).
end_(span("lived",76,80),span(20191231,102,105)).
start_(span("lived",76,80),span(20190101,102,105)).
end_(span("abode",188,192),span(20191231,139,142)).
start_(span("abode",188,192),span(20190101,139,142)).
agent_(span("abode",188,192),span("Charlie",145,151)).
patient_(span("abode",188,192),span("place",179,183)).
patient_(span("son",68,70),span("Charlie",53,59)).
agent_(span("son",68,70),span("Bob",72,74)).

% Test
:- tax("Alice",2019,2477).
:- halt.
