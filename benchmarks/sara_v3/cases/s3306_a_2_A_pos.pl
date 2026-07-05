% Text
% Alice has paid wages of $6771 to Bob, $6954 to Charlie, and $6872 to Dan for agricultural labor done from Feb 1st, 2017 to Sep 2nd, 2017. Bob has paid wages of $4520 to Alice for work done from Apr 1st, 2017 to Sep 1st, 2018.

% Question
% Under section 3306(a)(2)(A), Alice is an employer for the year 2017. Entailment

% Facts
:- discontiguous s3306_b/8.
:- [statutes/prolog/init].
s3306_b(6771,span("$6771",24,28),span("labor",90,94),"Alice","Bob","Alice","Bob",_).
s3306_b(6954,span("$6954",38,42),span("labor",90,94),"Alice","Charlie","Alice","Charlie",_).
s3306_b(6872,span("$6872",60,64),span("labor",90,94),"Alice","Dan","Alice","Dan",_).
s3306_b(4520,span("paid",146,149),span("work",179,182),"Bob","Alice","Bob","Alice",_).
payment_(span("$6771",24,28)).
payment_(span("$6954",38,42)).
payment_(span("$6872",60,64)).
service_(span("labor",90,94)).
payment_(span("paid",146,149)).
service_(span("work",179,182)).
agent_(span("$6771",24,28),span("Alice",0,4)).
amount_(span("$6771",24,28),span(6771,25,28)).
patient_(span("$6771",24,28),span("Bob",33,35)).
purpose_(span("$6771",24,28),span("labor",90,94)).
start_(span("$6771",24,28),span(20170902,123,135)).
agent_(span("$6872",60,64),span("Alice",0,4)).
amount_(span("$6872",60,64),span(6872,61,64)).
patient_(span("$6872",60,64),span("Dan",69,71)).
purpose_(span("$6872",60,64),span("labor",90,94)).
start_(span("$6872",60,64),span(20170902,123,135)).
agent_(span("$6954",38,42),span("Alice",0,4)).
amount_(span("$6954",38,42),span(6954,39,42)).
patient_(span("$6954",38,42),span("Charlie",47,53)).
purpose_(span("$6954",38,42),span("labor",90,94)).
start_(span("$6954",38,42),span(20170902,123,135)).
agent_(span("paid",146,149),span("Bob",138,140)).
amount_(span("paid",146,149),span(4520,161,164)).
patient_(span("paid",146,149),span("Alice",169,173)).
purpose_(span("paid",146,149),span("work",179,182)).
start_(span("paid",146,149),span(20180901,211,223)).
patient_(span("labor",90,94),span("Alice",0,4)).
agent_(span("labor",90,94),span("Bob",33,35)).
agent_(span("labor",90,94),span("Charlie",47,53)).
agent_(span("labor",90,94),span("Dan",69,71)).
purpose_(span("labor",90,94),span("agricultural labor",77,94)).
start_(span("labor",90,94),span(20170201,106,118)).
end_(span("labor",90,94),span(20170902,123,135)).
patient_(span("work",179,182),span("Bob",138,140)).
agent_(span("work",179,182),span("Alice",169,173)).
start_(span("work",179,182),span(20170401,194,206)).
end_(span("work",179,182),span(20180901,211,223)).

% Test
:- s3306_a_2_A("Alice",2017,_,_).
:- halt.
