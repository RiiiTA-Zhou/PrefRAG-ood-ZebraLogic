% Text
% Alice was born January 10th, 1992. Bob was born January 31st, 2014. Alice adopted Bob on March 4th, 2018 and Bob has lived with Alice since, in a house that Alice maintains. Alice's gross income in 2018 was $141177. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2018? $32045

% Facts
:- [statutes/prolog/init].
birth_(span("born",10,13)).
agent_(span("born",10,13),span("Alice",0,4)).
start_(span("born",10,13),span(19920110,15,32)).
birth_(span("born",43,46)).
agent_(span("born",43,46),span("Bob",35,37)).
start_(span("born",43,46),span(20140131,48,65)).
son_(span("adopted",74,80)).
patient_(span("adopted",74,80),span("Alice",68,72)).
agent_(span("adopted",74,80),span("Bob",82,84)).
start_(span("adopted",74,80),span(20180304,89,103)).
residence_(span("lived",117,121)).
start_(span("lived",117,121),span(20180101,100,103)).
agent_(span("lived",117,121),span("Bob",109,111)).
agent_(span("lived",117,121),span("Alice",128,132)).
patient_(span("lived",117,121),span("house",146,150)).
payment_(span("maintains",163,171)).
start_(span("maintains",163,171),span(20180101,100,103)).
purpose_(span("maintains",163,171),span("house",146,150)).
agent_(span("maintains",163,171),span("Alice",157,161)).
amount_(span("maintains",163,171),span(1,163,171)).
income_(span("income",188,193)).
agent_(span("income",188,193),span("Alice",174,178)).
start_(span("income",188,193),span(20180101,198,201)).
amount_(span("income",188,193),span(141177,208,213)).

% Test
:- tax("Alice",2018,32045).
:- halt.
