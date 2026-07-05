% Text
% Alice has paid $3200 to her father Bob for work done from Feb 1st, 2017 to Sep 2nd, 2017, in Baltimore, Maryland, USA. Alice and Charlie got married on April 5th, 2012. Alice and Charlie were legally separated under a decree of divorce on September 16th, 2017. Alice's gross income in 2017 was $756420. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $279126

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
father_(span("father",28,33)).
service_(span("work",43,46)).
marriage_(span("married",141,147)).
legal_separation_(span("separated",200,208)).
income_(span("income",275,280)).
patient_(span("father",28,33),span("Alice",0,4)).
agent_(span("father",28,33),span("Bob",35,37)).
agent_(span("income",275,280),span("Alice",261,265)).
start_(span("income",275,280),span(20170101,285,288)).
amount_(span("income",275,280),span(756420,295,300)).
patient_(span("separated",200,208),span("married",141,147)).
agent_(span("separated",200,208),span("decree of divorce",218,234)).
start_(span("separated",200,208),span(20170916,239,258)).
agent_(span("married",141,147),span("Alice",119,123)).
agent_(span("married",141,147),span("Charlie",129,135)).
start_(span("married",141,147),span(20120405,152,166)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,16,19)).
patient_(span("paid",10,13),span("Bob",35,37)).
purpose_(span("paid",10,13),span("work",43,46)).
start_(span("paid",10,13),span(20170902,75,87)).
patient_(span("work",43,46),span("Alice",0,4)).
agent_(span("work",43,46),span("Bob",35,37)).
start_(span("work",43,46),span(20170201,58,70)).
end_(span("work",43,46),span(20170902,75,87)).
location_(span("work",43,46),span("Baltimore",93,101)).
location_(span("work",43,46),span("Maryland",104,111)).
location_(span("work",43,46),span("USA",114,116)).

% Test
:- tax("Alice",2017,279126).
:- halt.
