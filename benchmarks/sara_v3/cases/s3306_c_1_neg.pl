% Text
% Alice has paid $3200 to Bob for domestic service done from Feb 1st, 2017 to Sep 2nd, 2017, in Caracas, Venezuela. Alice is an American employer.

% Question
% Section 3306(c)(1) applies to Alice employing Bob for the year 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("service",41,47)).
american_employer_(span("American employer",126,142)).
agent_(span("American employer",126,142),span("Alice",114,118)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",24,26)).
purpose_(span("paid",10,13),span("service",41,47)).
start_(span("paid",10,13),span(20170902,76,88)).
patient_(span("service",41,47),span("Alice",0,4)).
agent_(span("service",41,47),span("Bob",24,26)).
purpose_(span("service",41,47),span("domestic service",32,47)).
start_(span("service",41,47),span(20170201,59,71)).
end_(span("service",41,47),span(20170902,76,88)).
location_(span("service",41,47),span("Caracas, Venezuela",94,111)).
country_(span("Caracas, Venezuela",94,111),span("Venezuela",103,111)).

% Test
:- \+ s3306_c_1(span("service",41,47),2017).
:- halt.
