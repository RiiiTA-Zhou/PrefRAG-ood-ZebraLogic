% Text
% Alice was born January 10th, 1992. Bob was born January 31st, 1984. Alice adopted Bob on March 4th, 2018.

% Question
% Bob satisfies section 152(c)(3) with Alice claiming Bob as a qualifying child for the year 2019. Contradiction

% Facts
:- [statutes/prolog/init].
birth_(span("born",10,13)).
birth_(span("born",43,46)).
son_(span("adopted",74,80)).
agent_(span("born",10,13),span("Alice",0,4)).
start_(span("born",10,13),span(19920110,15,32)).
agent_(span("born",43,46),span("Bob",35,37)).
start_(span("born",43,46),span(19840131,48,65)).
patient_(span("adopted",74,80),span("Alice",68,72)).
agent_(span("adopted",74,80),span("Bob",82,84)).
start_(span("adopted",74,80),span(20180304,89,103)).

% Test
:- \+ s152_c_3("Bob","Alice",2019).
:- halt.
