% Text
% Alice has been married since April 4th, 2015. Alice files a joint return with her spouse for 2016. Alice's and her spouse's gross income for the year 2016 is $164612. Alice has paid $4525 to Bob for work done in the year 2016. In 2016, Alice has also paid $9832 into a retirement fund for Bob, and paid $5322 into health insurance for Charlie, who is Alice's father and has retired in 2016. Charlie had no income in 2016. Alice and her spouse take the standard deduction.

% Question
% How much tax does Alice have to pay in 2016? $40741

% Facts
:- [statutes/prolog/init].
marriage_(span("married",15,21)).
joint_return_(span("joint return",60,71)).
income_(span("income",130,135)).
payment_(span("paid",177,180)).
service_(span("work",199,202)).
payment_(span("paid",251,254)).
plan_(span("retirement fund",269,283)).
payment_(span("paid",298,301)).
plan_(span("health insurance",314,329)).
father_(span("father",359,364)).
retirement_(span("retired",374,380)).
patient_(span("father",359,364),span("Alice",351,355)).
agent_(span("father",359,364),span("Charlie",335,341)).
agent_(span("income",130,135),span("Alice",99,103)).
start_(span("income",130,135),span(20160101,150,153)).
amount_(span("income",130,135),span(164612,159,164)).
agent_(span("joint return",60,71),span("Alice",46,50)).
agent_(span("joint return",60,71),span("spouse",82,87)).
start_(span("joint return",60,71),span(20160101,93,96)).
agent_(span("married",15,21),span("Alice",0,4)).
start_(span("married",15,21),span(20150404,29,43)).
agent_(span("married",15,21),span("spouse",82,87)).
purpose_(span("paid",298,301),span("make provisions for employees in case of sickness",314,329)).
amount_(span("paid",298,301),span(5322,304,307)).
patient_(span("paid",298,301),span("health insurance",314,329)).
beneficiary_(span("paid",298,301),span("Charlie",335,341)).
agent_(span("paid",298,301),span("Alice",236,240)).
start_(span("paid",298,301),span(20160101,230,233)).
start_(span("paid",251,254),span(20160101,230,233)).
agent_(span("paid",251,254),span("Alice",236,240)).
amount_(span("paid",251,254),span(9832,257,260)).
patient_(span("paid",251,254),span("retirement fund",269,283)).
purpose_(span("paid",251,254),span("make provisions for employees in case of retirement",269,283)).
beneficiary_(span("paid",251,254),span("Bob",289,291)).
agent_(span("paid",177,180),span("Alice",167,171)).
amount_(span("paid",177,180),span(4525,183,186)).
patient_(span("paid",177,180),span("Bob",191,193)).
purpose_(span("paid",177,180),span("work",199,202)).
start_(span("paid",177,180),span(20160101,221,224)).
start_(span("retired",374,380),span(20160101,385,388)).
agent_(span("retired",374,380),span("Charlie",335,341)).
patient_(span("work",199,202),span("Alice",167,171)).
agent_(span("work",199,202),span("Bob",191,193)).
end_(span("work",199,202),span(20161231,221,224)).
start_(span("work",199,202),span(20160101,221,224)).

% Test
:- tax("Alice",2016,40741).
:- halt.
