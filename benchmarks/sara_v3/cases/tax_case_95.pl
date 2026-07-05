% Text
% Alice and Bob got married on Aug 6th, 2010. Their son Charlie was born February 2nd, 2012. Alice and Bob were legally separated under a decree of divorce on March 2nd, 2015. In 2017, Alice and Charlie live in a house maintained by Alice. Alice's gross income for the year 2017 is $9560. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $174

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
son_(span("son",50,52)).
legal_separation_(span("separated",118,126)).
residence_(span("live",201,204)).
payment_(span("maintained",217,226)).
income_(span("income",252,257)).
agent_(span("income",252,257),span("Alice",238,242)).
start_(span("income",252,257),span(20170101,272,275)).
amount_(span("income",252,257),span(9560,281,284)).
patient_(span("separated",118,126),span("married",18,24)).
agent_(span("separated",118,126),span("decree of divorce",136,152)).
start_(span("separated",118,126),span(20150302,157,171)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(20100806,29,41)).
purpose_(span("maintained",217,226),span("house",211,215)).
agent_(span("maintained",217,226),span("Alice",231,235)).
amount_(span("maintained",217,226),span(1,217,226)).
start_(span("maintained",217,226),span(20170101,177,180)).
agent_(span("live",201,204),span("Alice",183,187)).
agent_(span("live",201,204),span("Charlie",193,199)).
patient_(span("live",201,204),span("house",211,215)).
end_(span("live",201,204),span(20171231,177,180)).
start_(span("live",201,204),span(20170101,177,180)).
agent_(span("son",50,52),span("Charlie",54,60)).
start_(span("son",50,52),span(20120202,71,88)).
patient_(span("son",50,52),span("Alice",0,4)).
patient_(span("son",50,52),span("Bob",10,12)).
birth_(span("born",66,69)).
agent_(span("born",66,69),span("Charlie",54,60)).
start_(span("born",66,69),span(20120202,71,88)).

% Test
:- tax("Alice",2017,174).
:- halt.
