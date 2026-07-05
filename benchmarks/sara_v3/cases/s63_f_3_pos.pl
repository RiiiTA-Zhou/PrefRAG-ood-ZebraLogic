% Text
% In 2017, Alice was paid $33200. Alice was born March 2nd, 1950 and Bob was born March 3rd, 1955.

% Question
% Under section 63(f)(3), Alice's additional standard deduction in 2017 is equal to $750. Entailment

% Facts
:- [statutes/prolog/init].
payment_(span("paid",19,22)).
birth_(span("born",42,45)).
birth_(span("born",75,78)).
agent_(span("born",42,45),span("Alice",32,36)).
start_(span("born",42,45),span(19500302,47,61)).
agent_(span("born",75,78),span("Bob",67,69)).
start_(span("born",75,78),span(19550303,80,94)).
start_(span("paid",19,22),span(20170101,3,6)).
patient_(span("paid",19,22),span("Alice",9,13)).
amount_(span("paid",19,22),span(33200,25,29)).

% Test
:- s63_f_3("Alice",2017,750).
:- halt.
