% Text
% Alice has paid $3200 to Bob for agricultural labor done from Feb 1st, 2017 to Sep 2nd, 2017, in Stanley, Wisconsin, USA. Alice is an American citizen, and Bob is a Mexican citizen who was admitted to the USA to perform agricultural labor pursuant to sections 214(c) and 101(a)(15)(H) of the Immigration and Nationality Act.

% Question
% Section 3306(c)(1)(B) applies to Alice employing Bob for the year 2017. Contradiction

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("labor",45,49)).
citizenship_(span("citizen",142,148)).
citizenship_(span("citizen",172,178)).
migration_(span("admitted",188,195)).
agent_(span("citizen",142,148),span("Alice",121,125)).
patient_(span("citizen",142,148),span("American",133,140)).
agent_(span("citizen",172,178),span("Bob",155,157)).
patient_(span("citizen",172,178),span("Mexican",164,170)).
agent_(span("admitted",188,195),span("Bob",155,157)).
destination_(span("admitted",188,195),span("USA",204,206)).
purpose_(span("admitted",188,195),span("agricultural labor",219,236)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",24,26)).
purpose_(span("paid",10,13),span("labor",45,49)).
start_(span("paid",10,13),span(20170902,78,90)).
patient_(span("labor",45,49),span("Alice",0,4)).
agent_(span("labor",45,49),span("Bob",24,26)).
purpose_(span("labor",45,49),span("agricultural labor",32,49)).
start_(span("labor",45,49),span(20170201,61,73)).
end_(span("labor",45,49),span(20170902,78,90)).
location_(span("labor",45,49),span("Stanley, Wisconsin, USA",96,118)).
country_(span("Stanley, Wisconsin, USA",96,118),span("USA",116,118)).

% Test
:- \+ s3306_c_1_B(span("labor",45,49),"Bob").
:- halt.
