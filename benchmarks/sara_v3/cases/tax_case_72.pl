% Text
% Bob is Alice's father. Alice has paid $2561 to Bob for work done from Feb 1st, 2013 to Sep 2nd, 2013, in Baltimore, Maryland, USA. Alice's gross income in 2013 is $42384. Alice takes the standard deduction in 2013.

% Question
% How much tax does Alice have to pay in 2013? $7595

% Facts
:- [statutes/prolog/init].
father_(span("father",15,20)).
payment_(span("paid",33,36)).
service_(span("work",55,58)).
income_(span("income",145,150)).
agent_(span("father",15,20),span("Bob",0,2)).
patient_(span("father",15,20),span("Alice",7,11)).
agent_(span("income",145,150),span("Alice",131,135)).
start_(span("income",145,150),span(20130101,155,158)).
amount_(span("income",145,150),span(42384,164,168)).
agent_(span("paid",33,36),span("Alice",23,27)).
amount_(span("paid",33,36),span(2561,39,42)).
patient_(span("paid",33,36),span("Bob",47,49)).
purpose_(span("paid",33,36),span("work",55,58)).
start_(span("paid",33,36),span(20130902,87,99)).
patient_(span("work",55,58),span("Alice",23,27)).
agent_(span("work",55,58),span("Bob",47,49)).
start_(span("work",55,58),span(20130201,70,82)).
end_(span("work",55,58),span(20130902,87,99)).
location_(span("work",55,58),span("Baltimore",105,113)).
location_(span("work",55,58),span("Maryland",116,123)).
location_(span("work",55,58),span("USA",126,128)).

% Test
:- tax("Alice",2013,7595).
:- halt.
