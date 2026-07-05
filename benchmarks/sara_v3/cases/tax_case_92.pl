% Text
% Alice has paid $300 to Bob for domestic service done in her home from Feb 1st, 2010 to Sep 2nd, 2010, in Baltimore, Maryland, USA. In 2010, Alice was paid $33408. Alice is allowed itemized deductions of $680, $2102, $1993 and $4807.

% Question
% How much tax does Alice have to pay in 2010? $3274

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("service",40,46)).
payment_(span("paid",150,153)).
deduction_(span("$680",203,206)).
deduction_(span("$2102",209,213)).
deduction_(span("$1993",216,220)).
deduction_(span("$4807",226,230)).
start_(span("$1993",216,220),span(20100101,134,137)).
agent_(span("$1993",216,220),span("Alice",163,167)).
amount_(span("$1993",216,220),span(1993,217,220)).
start_(span("$2102",209,213),span(20100101,134,137)).
agent_(span("$2102",209,213),span("Alice",163,167)).
amount_(span("$2102",209,213),span(2102,210,213)).
start_(span("$4807",226,230),span(20100101,134,137)).
agent_(span("$4807",226,230),span("Alice",163,167)).
amount_(span("$4807",226,230),span(4807,227,230)).
start_(span("$680",203,206),span(20100101,134,137)).
agent_(span("$680",203,206),span("Alice",163,167)).
amount_(span("$680",203,206),span(680,204,206)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(300,16,18)).
patient_(span("paid",10,13),span("Bob",23,25)).
purpose_(span("paid",10,13),span("service",40,46)).
start_(span("paid",10,13),span(20100902,87,99)).
start_(span("paid",150,153),span(20100101,134,137)).
patient_(span("paid",150,153),span("Alice",140,144)).
amount_(span("paid",150,153),span(33408,156,160)).
patient_(span("service",40,46),span("Alice",0,4)).
agent_(span("service",40,46),span("Bob",23,25)).
purpose_(span("service",40,46),span("domestic service",31,46)).
location_(span("service",40,46),span("home",60,63)).
start_(span("service",40,46),span(20100201,70,82)).
end_(span("service",40,46),span(20100902,87,99)).
location_(span("service",40,46),span("Baltimore",105,113)).
location_(span("service",40,46),span("Maryland",116,123)).
location_(span("service",40,46),span("USA",126,128)).

% Test
:- tax("Alice",2010,3274).
:- halt.
