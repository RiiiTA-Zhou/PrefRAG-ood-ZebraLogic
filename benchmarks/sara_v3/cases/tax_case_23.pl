% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice died on July 9th, 2014. In 2014, Alice's gross income was $55431 and Bob's gross income was $64314. Bob files a joint return for himself and Alice for 2014. Bob takes the standard deduction.

% Question
% How much tax does Bob have to pay in 2014? $26549

% Facts
:- [statutes/prolog/init].
marriage_(span("married",18,24)).
death_(span("died",50,53)).
income_(span("income",97,102)).
income_(span("income",131,136)).
joint_return_(span("joint return",162,173)).
agent_(span("died",50,53),span("Alice",44,48)).
start_(span("died",50,53),span(20140709,58,71)).
agent_(span("income",97,102),span("Alice",83,87)).
amount_(span("income",97,102),span(55431,109,113)).
start_(span("income",97,102),span(20140101,77,80)).
agent_(span("income",131,136),span("Bob",119,121)).
amount_(span("income",131,136),span(64314,143,147)).
start_(span("income",131,136),span(20140101,77,80)).
agent_(span("joint return",162,173),span("Bob",150,152)).
agent_(span("joint return",162,173),span("Alice",191,195)).
start_(span("joint return",162,173),span(20140101,201,204)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).

% Test
:- tax("Bob",2014,26549).
:- halt.
