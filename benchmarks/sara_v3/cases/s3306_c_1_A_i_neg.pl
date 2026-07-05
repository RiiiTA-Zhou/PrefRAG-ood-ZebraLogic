% Text
% Alice has paid $2300 to Bob for agricultural labor done from Feb 1st, 2017 to Sep 2nd, 2017, in Caracas, Venezuela. Alice and Bob are both American citizens.

% Question
% Section 3306(c)(1)(A)(i) applies to Alice employing Bob for the year 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("labor",45,49)).
citizenship_(span("citizens",148,155)).
agent_(span("citizens",148,155),span("Alice",116,120)).
agent_(span("citizens",148,155),span("Bob",126,128)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(2300,16,19)).
patient_(span("paid",10,13),span("Bob",24,26)).
purpose_(span("paid",10,13),span("labor",45,49)).
start_(span("paid",10,13),span(20170902,78,90)).
patient_(span("labor",45,49),span("Alice",0,4)).
agent_(span("labor",45,49),span("Bob",24,26)).
purpose_(span("labor",45,49),span("agricultural labor",32,49)).
start_(span("labor",45,49),span(20170201,61,73)).
end_(span("labor",45,49),span(20170902,78,90)).
location_(span("labor",45,49),span("Caracas, Venezuela",96,113)).
country_(span("Caracas, Venezuela",96,113),span("Venezuela",105,113)).
patient_(span("citizens",148,155),span("American",139,146)).

% Test
:- \+ s3306_c_1_A_i("Alice",_,["Bob"],_,2017).
:- halt.
