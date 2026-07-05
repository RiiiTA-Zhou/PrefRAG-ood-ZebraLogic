% Text
% Alice has paid $3200 to Bob for work done from Feb 1st, 2017 to Sep 2nd, 2017, in Caracas, Venezuela. Alice is a citizen of Venezuela, and Bob is an American citizen.

% Question
% Section 3306(c)(B) applies to Alice employing Bob for the year 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("work",32,35)).
citizenship_(span("citizen",113,119)).
citizenship_(span("citizen",158,164)).
agent_(span("citizen",113,119),span("Alice",102,106)).
patient_(span("citizen",113,119),span("Venezuela",124,132)).
agent_(span("citizen",158,164),span("Bob",139,141)).
patient_(span("citizen",158,164),span("American",149,156)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",24,26)).
purpose_(span("paid",10,13),span("work",32,35)).
start_(span("paid",10,13),span(20170902,64,76)).
patient_(span("work",32,35),span("Alice",0,4)).
agent_(span("work",32,35),span("Bob",24,26)).
start_(span("work",32,35),span(20170201,47,59)).
end_(span("work",32,35),span(20170902,64,76)).
location_(span("work",32,35),span("Caracas, Venezuela",82,99)).
country_(span("Caracas, Venezuela",82,99),span("Venezuela",91,99)).

% Test
:- \+ s3306_c_B(span("work",32,35),"Alice","Bob",_).
:- halt.
