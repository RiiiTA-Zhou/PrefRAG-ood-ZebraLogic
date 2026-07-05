% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice and Bob have a child, Charlie, born October 9th, 2000. From 2004 to 2019, Bob furnished the costs of maintaining the home where he and Charlie lived during that time. From 2015 to 2018, Alice had a different principal place of abode. In 2017, Alice was paid $33200, and Bob's income was $32311. Alice was born March 2nd, 1950 and Bob was born March 3rd, 1955. In 2017, Alice and Bob file jointly and take the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $10018

% Facts
:- [statutes/prolog/init].
bob_household_maintenance(Year,Event,Start_day,End_day) :-
    between(2004,2019,Year),
    atom_concat("furnished the costs ",Year,Event),
    first_day_year(Year,Start_day),
    last_day_year(Year,End_day).
payment_(span(Event,128,136)) :- bob_household_maintenance(_,Event,_,_).
agent_(span(Event,128,136),span("Bob",124,126)) :- bob_household_maintenance(_,Event,_,_).
amount_(span(Event,128,136),span(1,138,140)) :- bob_household_maintenance(_,Event,_,_).
purpose_(span(Event,128,136),span("home",167,170)) :- bob_household_maintenance(_,Event,_,_).
start_(span(Event,128,136),span(Start_day,110,113)) :- bob_household_maintenance(_,Event,Start_day,_).
end_(span(Event,128,136),span(End_day,118,121)) :- bob_household_maintenance(_,Event,_,End_day).
marriage_(span("married",18,24)).
son_(span("child",65,69)).
residence_(span("lived",193,197)).
residence_(span("abode",277,281)).
payment_(span("paid",303,306)).
income_(span("income",326,331)).
birth_(span("born",355,358)).
agent_(span("born",355,358),span("Alice",345,349)).
start_(span("born",355,358),span(19500302,360,374)).
birth_(span("born",388,391)).
agent_(span("born",388,391),span("Bob",380,382)).
start_(span("born",388,391),span(19550303,393,407)).
joint_return_(span("file jointly",433,444)).
start_(span("income",326,331),span(20170101,287,290)).
agent_(span("income",326,331),span("Bob",320,322)).
amount_(span("income",326,331),span(32311,338,342)).
start_(span("file jointly",433,444),span(20170101,413,416)).
agent_(span("file jointly",433,444),span("Alice",419,423)).
agent_(span("file jointly",433,444),span("Bob",429,431)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).
start_(span("paid",303,306),span(20170101,287,290)).
patient_(span("paid",303,306),span("Alice",293,297)).
amount_(span("paid",303,306),span(33200,309,313)).
start_(span("lived",193,197),span(20040101,110,113)).
end_(span("lived",193,197),span(20191231,118,121)).
agent_(span("lived",193,197),span("Bob",124,126)).
patient_(span("lived",193,197),span("home",167,170)).
agent_(span("lived",193,197),span("Charlie",185,191)).
agent_(span("abode",277,281),span("Alice",236,240)).
start_(span("abode",277,281),span(20150101,222,225)).
end_(span("abode",277,281),span(20181231,230,233)).
patient_(span("abode",277,281),span("place",268,272)).
patient_(span("child",65,69),span("Alice",44,48)).
patient_(span("child",65,69),span("Bob",54,56)).
agent_(span("child",65,69),span("Charlie",72,78)).
start_(span("child",65,69),span(20001009,86,102)).
birth_(span("born",81,84)).
agent_(span("born",81,84),span("Charlie",72,78)).
start_(span("born",81,84),span(20001009,86,102)).

% Test
:- tax("Alice",2017,10018).
:- halt.
