% Text
% Alice has paid $3200 to her father Bob for work done from Feb 1st, 2017 to Sep 2nd, 2017, in Baltimore, Maryland, USA.

% Question
% Section 3306(c)(5) applies to Alice employing Bob for the year 2017. Entailment

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
father_(span("father",28,33)).
service_(span("work",43,46)).
patient_(span("father",28,33),span("Alice",0,4)).
agent_(span("father",28,33),span("Bob",35,37)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",35,37)).
purpose_(span("paid",10,13),span("work",43,46)).
start_(span("paid",10,13),span(20170902,75,87)).
patient_(span("work",43,46),span("Alice",0,4)).
agent_(span("work",43,46),span("Bob",35,37)).
start_(span("work",43,46),span(20170201,58,70)).
end_(span("work",43,46),span(20170902,75,87)).
location_(span("work",43,46),span("Baltimore",93,101)).
location_(span("work",43,46),span("Maryland",104,111)).
location_(span("work",43,46),span("USA",114,116)).

% Test
:- s3306_c_5(span("work",43,46),"Alice","Bob",20170201).
:- halt.
