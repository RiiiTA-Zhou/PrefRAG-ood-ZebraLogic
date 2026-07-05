% Text
% Alice has a brother, Bob, who was born January 31st, 2014 and has always lived at his parents' place. In 2016, Alice's gross income was $567192. Alice got married on Jan 12, 2016. Her husband had no income in 2016. Alice does not file a joint return. Alice has itemized deductions of $100206.

% Question
% How much tax does Alice have to pay in 2016? $178147

% Facts
:- [statutes/prolog/init].
brother_(span("brother",12,18)).
residence_(span("lived",73,77)).
son_(span("parents",86,92)).
residence_(span("parents' place",86,99)).
income_(span("income",125,130)).
marriage_(span("married",155,161)).
deduction_(span("deductions",270,279)).
patient_(span("brother",12,18),span("Alice",0,4)).
agent_(span("brother",12,18),span("Bob",21,23)).
start_(span("brother",12,18),span(20140131,39,56)).
start_(span("deductions",270,279),span(20160101,209,212)).
agent_(span("deductions",270,279),span("Alice",251,255)).
amount_(span("deductions",270,279),span(100206,285,290)).
start_(span("income",125,130),span(20160101,105,108)).
agent_(span("income",125,130),span("Alice",111,115)).
amount_(span("income",125,130),span(567192,137,142)).
agent_(span("married",155,161),span("Alice",145,149)).
start_(span("married",155,161),span(20160112,166,177)).
agent_(span("married",155,161),span("husband",184,190)).
agent_(span("parents' place",86,99),span("parents",86,92)).
patient_(span("parents' place",86,99),span("place",95,99)).
agent_(span("lived",73,77),span("Bob",21,23)).
start_(span("lived",73,77),span(20140131,39,56)).
patient_(span("lived",73,77),span("place",95,99)).
agent_(span("parents",86,92),span("Bob",21,23)).
start_(span("parents",86,92),span(20140131,39,56)).
patient_(span("parents",86,92),span("parents",86,92)).
birth_(span("born",34,37)).
agent_(span("born",34,37),span("Bob",21,23)).
start_(span("born",34,37),span(20140131,39,56)).

% Test
:- tax("Alice",2016,178147).
:- halt.
