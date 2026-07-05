% Text
% Alice has paid $3200 to her brother Bob for work done from Feb 1st, 2017 to Sep 2nd, 2017, in Baltimore, Maryland, USA.

% Question
% Section 3306(c)(5) applies to Alice employing Bob for the year 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
brother_(span("brother",28,34)).
service_(span("work",44,47)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",36,38)).
purpose_(span("paid",10,13),span("work",44,47)).
start_(span("paid",10,13),span(20170902,76,88)).
patient_(span("work",44,47),span("Alice",0,4)).
agent_(span("work",44,47),span("Bob",36,38)).
start_(span("work",44,47),span(20170201,59,71)).
end_(span("work",44,47),span(20170902,76,88)).
location_(span("work",44,47),span("Baltimore",94,102)).
location_(span("work",44,47),span("Maryland",105,112)).
location_(span("work",44,47),span("USA",115,117)).
patient_(span("brother",28,34),span("Alice",0,4)).
agent_(span("brother",28,34),span("Bob",36,38)).

% Test
:- \+ s3306_c_5(span("work",44,47),"Alice","Bob",20170201).
:- halt.
