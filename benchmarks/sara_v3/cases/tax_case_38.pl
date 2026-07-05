% Text
% Alice got married on December 30th, 2017. Alice files a joint return with her spouse for 2017. Alice's and her spouse's gross income for the year 2017 is $684642. Alice has itemized deductions of $23029 for donating cash to a charity.

% Question
% How much tax does Alice have to pay in 2017? $243097

% Facts
:- [statutes/prolog/init].
marriage_(span("married",10,16)).
joint_return_(span("joint return",56,67)).
income_(span("income",126,131)).
deduction_(span("deductions",182,191)).
start_(span("deductions",182,191),span(20170101,146,149)).
agent_(span("deductions",182,191),span("Alice",163,167)).
amount_(span("deductions",182,191),span(23029,197,201)).
agent_(span("income",126,131),span("Alice",95,99)).
start_(span("income",126,131),span(20170101,146,149)).
amount_(span("income",126,131),span(684642,155,160)).
agent_(span("joint return",56,67),span("Alice",42,46)).
agent_(span("joint return",56,67),span("spouse",78,83)).
start_(span("joint return",56,67),span(20170101,89,92)).
agent_(span("married",10,16),span("Alice",0,4)).
start_(span("married",10,16),span(20171230,21,39)).
agent_(span("married",10,16),span("spouse",78,83)).

% Test
:- tax("Alice",2017,243097).
:- halt.
