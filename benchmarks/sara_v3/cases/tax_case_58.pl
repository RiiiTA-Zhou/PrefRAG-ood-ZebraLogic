% Text
% Alice got married on May 30th, 2014. Alice files a joint return with her spouse for 2017 and they take the standard deduction. Alice's gross income for the year 2017 is $103272 while her spouse had no income. Alice has paid $3200 to her brother Bob for work done from Feb 1st, 2017 to Sep 2nd, 2017, in Baltimore, Maryland, USA.

% Question
% How much tax does Alice have to pay in 2017? $21635

% Facts
:- [statutes/prolog/init].
marriage_(span("married",10,16)).
joint_return_(span("joint return",51,62)).
income_(span("income",141,146)).
payment_(span("paid",219,222)).
brother_(span("brother",237,243)).
service_(span("work",253,256)).
patient_(span("brother",237,243),span("Alice",209,213)).
agent_(span("brother",237,243),span("Bob",245,247)).
agent_(span("income",141,146),span("Alice",127,131)).
start_(span("income",141,146),span(20170101,161,164)).
amount_(span("income",141,146),span(103272,170,175)).
agent_(span("joint return",51,62),span("Alice",37,41)).
agent_(span("joint return",51,62),span("spouse",73,78)).
start_(span("joint return",51,62),span(20170101,84,87)).
agent_(span("married",10,16),span("Alice",0,4)).
start_(span("married",10,16),span(20140530,21,34)).
agent_(span("married",10,16),span("spouse",73,78)).
agent_(span("paid",219,222),span("Alice",209,213)).
amount_(span("paid",219,222),span(3200,225,228)).
patient_(span("paid",219,222),span("Bob",245,247)).
purpose_(span("paid",219,222),span("work",253,256)).
start_(span("paid",219,222),span(20170902,285,297)).
patient_(span("work",253,256),span("Alice",209,213)).
agent_(span("work",253,256),span("Bob",245,247)).
start_(span("work",253,256),span(20170201,268,280)).
end_(span("work",253,256),span(20170902,285,297)).
location_(span("work",253,256),span("Baltimore",303,311)).
location_(span("work",253,256),span("Maryland",314,321)).
location_(span("work",253,256),span("USA",324,326)).

% Test
:- tax("Alice",2017,21635).
:- halt.
