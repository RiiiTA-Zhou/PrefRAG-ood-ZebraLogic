% Text
% Alice has paid $3200 to Bob for work done from Feb 1st, 2017 to Sep 2nd, 2017, in Toronto, Ontario, Canada.

% Question
% Section 3306(c)(A) applies to Alice employing Bob for the year 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("work",32,35)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",24,26)).
purpose_(span("paid",10,13),span("work",32,35)).
start_(span("paid",10,13),span(20170902,64,76)).
patient_(span("work",32,35),span("Alice",0,4)).
agent_(span("work",32,35),span("Bob",24,26)).
start_(span("work",32,35),span(20170201,47,59)).
end_(span("work",32,35),span(20170902,64,76)).
location_(span("work",32,35),span("Toronto, Ontario, Canada",82,105)).
country_(span("Toronto, Ontario, Canada",82,105),span("Canada",100,105)).

% Test
:- \+ s3306_c_A(span("work",32,35),"Alice","Bob").
:- halt.
