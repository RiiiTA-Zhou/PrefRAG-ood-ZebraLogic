% Text
% Alice has paid $3200 to Bob for agricultural labor done from Feb 1st, 2017 to Sep 2nd, 2017, in Caracas, Venezuela. Alice is an American employer.

% Question
% Section 3306(c)(1) applies to Alice employing Bob for the year 2017. Entailment

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("labor",45,49)).
american_employer_(span("American employer",128,144)).
agent_(span("American employer",128,144),span("Alice",116,120)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",24,26)).
purpose_(span("paid",10,13),span("labor",45,49)).
start_(span("paid",10,13),span(20170201,61,73)).
patient_(span("labor",45,49),span("Alice",0,4)).
agent_(span("labor",45,49),span("Bob",24,26)).
purpose_(span("labor",45,49),span("agricultural labor",32,49)).
start_(span("labor",45,49),span(20170201,61,73)).
end_(span("labor",45,49),span(20170902,78,90)).
location_(span("labor",45,49),span("Caracas, Venezuela",96,113)).
country_(span("Caracas, Venezuela",96,113),span("Venezuela",105,113)).

% Test
:- s3306_c_1(span("labor",45,49),2017).
:- halt.
