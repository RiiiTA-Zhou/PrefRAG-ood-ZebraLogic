% Text
% Alice has paid $3200 to Bob for agricultural labor done from Feb 1st, 2020 to Sep 2nd, 2020. Alice paid Bob with eggs, grapes and hay. Alice has been married since 1999. Alice files a joint return with her spouse for 2020. Alice's and her spouse's gross income for the year 2020 is $103272. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2020? $17399

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("labor",45,49)).
marriage_(span("married",150,156)).
joint_return_(span("joint return",184,195)).
income_(span("income",254,259)).
agent_(span("income",254,259),span("Alice",223,227)).
start_(span("income",254,259),span(20200101,274,277)).
amount_(span("income",254,259),span(103272,283,288)).
agent_(span("joint return",184,195),span("Alice",170,174)).
agent_(span("joint return",184,195),span("spouse",206,211)).
start_(span("joint return",184,195),span(20200101,217,220)).
agent_(span("married",150,156),span("Alice",135,139)).
start_(span("married",150,156),span(19990101,164,167)).
agent_(span("married",150,156),span("spouse",206,211)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",24,26)).
purpose_(span("paid",10,13),span("labor",45,49)).
start_(span("paid",10,13),span(20200902,78,90)).
means_(span("paid",10,13),span("eggs, grapes and hay",113,132)).
patient_(span("labor",45,49),span("Alice",0,4)).
agent_(span("labor",45,49),span("Bob",24,26)).
purpose_(span("labor",45,49),span("agricultural labor",32,49)).
start_(span("labor",45,49),span(20200201,61,73)).
end_(span("labor",45,49),span(20200902,78,90)).

% Test
:- tax("Alice",2020,17399).
:- halt.
