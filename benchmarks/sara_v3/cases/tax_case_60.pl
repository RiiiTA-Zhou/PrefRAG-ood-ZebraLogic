% Text
% Alice got married on Jan 6th, 2005. Alice files a joint return with her spouse for 2015. Alice's and her spouse's gross income for the year 2015 is $42876. Alice and her spouse take the standard deduction. Alice has a son, Bob, who has the same principal place of abode as her in 2015. Bob has a son, Charlie, who also has the same principal place of abode as his father in 2015.

% Question
% How much tax does Alice have to pay in 2015? $4331

% Facts
:- [statutes/prolog/init].
marriage_(span("married",10,16)).
joint_return_(span("joint return",50,61)).
income_(span("income",120,125)).
son_(span("son",218,220)).
residence_(span("abode",264,268)).
son_(span("son",296,298)).
residence_(span("abode",351,355)).
agent_(span("income",120,125),span("Alice",89,93)).
start_(span("income",120,125),span(20150101,140,143)).
amount_(span("income",120,125),span(42876,149,153)).
agent_(span("joint return",50,61),span("Alice",36,40)).
agent_(span("joint return",50,61),span("spouse",72,77)).
start_(span("joint return",50,61),span(20150101,83,86)).
agent_(span("married",10,16),span("Alice",0,4)).
start_(span("married",10,16),span(20050106,21,33)).
agent_(span("married",10,16),span("spouse",72,77)).
agent_(span("abode",264,268),span("Alice",206,210)).
agent_(span("abode",264,268),span("Bob",223,225)).
patient_(span("abode",264,268),span("place",255,259)).
end_(span("abode",264,268),span(20151231,280,283)).
start_(span("abode",264,268),span(20150101,280,283)).
patient_(span("abode",351,355),span("place",342,346)).
agent_(span("abode",351,355),span("Bob",286,288)).
agent_(span("abode",351,355),span("Charlie",301,307)).
end_(span("abode",351,355),span(20151231,374,377)).
start_(span("abode",351,355),span(20150101,374,377)).
patient_(span("son",218,220),span("Alice",206,210)).
agent_(span("son",218,220),span("Bob",223,225)).
patient_(span("son",296,298),span("Bob",286,288)).
agent_(span("son",296,298),span("Charlie",301,307)).

% Test
:- tax("Alice",2015,4331).
:- halt.
