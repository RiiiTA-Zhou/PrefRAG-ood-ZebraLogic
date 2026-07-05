% Text
% Alice has paid $23200 in remuneration to Bob for agricultural labor done from Feb 1st, 2017 to Sep 2nd, 2017, in Caracas, Venezuela. Alice is an American employer.

% Question
% Section 3306(c)(1)(A)(i) applies to Alice employing Bob for the year 2017. Entailment

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("labor",62,66)).
american_employer_(span("American employer",145,161)).
agent_(span("American employer",145,161),span("Alice",133,137)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(23200,16,20)).
patient_(span("paid",10,13),span("Bob",41,43)).
purpose_(span("paid",10,13),span("labor",62,66)).
start_(span("paid",10,13),span(20170902,95,107)).
patient_(span("labor",62,66),span("Alice",0,4)).
agent_(span("labor",62,66),span("Bob",41,43)).
purpose_(span("labor",62,66),span("agricultural labor",49,66)).
start_(span("labor",62,66),span(20170201,78,90)).
end_(span("labor",62,66),span(20170902,95,107)).
location_(span("labor",62,66),span("Caracas, Venezuela",113,130)).
country_(span("Caracas, Venezuela",113,130),span("Venezuela",122,130)).

% Test
:- s3306_c_1_A_i("Alice",_,["Bob"],_,2017).
:- halt.
