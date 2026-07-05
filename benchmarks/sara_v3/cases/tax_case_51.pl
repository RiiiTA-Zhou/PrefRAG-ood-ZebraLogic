% Text
% Alice has paid $23200 in remuneration to Bob for agricultural labor done from Feb 1st, 2017 to Sep 2nd, 2017, in Caracas, Venezuela. Bob is an American citizen. Alice is an American employer. In 2017, Alice maintains as her principal place of abode a house where her mother Dorothy lives. Alice's gross income for the year 2017 is $197407. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2017? $55528

% Facts
:- [statutes/prolog/init].
payment_(span("paid",10,13)).
service_(span("labor",62,66)).
citizenship_(span("citizen",152,158)).
american_employer_(span("American employer",173,189)).
payment_(span("maintains",207,215)).
residence_(span("abode",243,247)).
mother_(span("mother",267,272)).
residence_(span("lives",282,286)).
income_(span("income",303,308)).
agent_(span("American employer",173,189),span("Alice",161,165)).
agent_(span("citizen",152,158),span("Bob",133,135)).
agent_(span("income",303,308),span("Alice",289,293)).
start_(span("income",303,308),span(20170101,323,326)).
amount_(span("income",303,308),span(197407,332,337)).
patient_(span("mother",267,272),span("Alice",201,205)).
agent_(span("mother",267,272),span("Dorothy",274,280)).
agent_(span("maintains",207,215),span("Alice",201,205)).
purpose_(span("maintains",207,215),span("house",251,255)).
amount_(span("maintains",207,215),span(1,207,215)).
start_(span("maintains",207,215),span(20170101,195,198)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(23200,16,20)).
patient_(span("paid",10,13),span("Bob",41,43)).
purpose_(span("paid",10,13),span("labor",62,66)).
start_(span("paid",10,13),span(20170902,95,107)).
agent_(span("abode",243,247),span("Alice",201,205)).
patient_(span("abode",243,247),span("house",251,255)).
end_(span("abode",243,247),span(20171231,195,198)).
start_(span("abode",243,247),span(20170101,195,198)).
patient_(span("lives",282,286),span("house",251,255)).
agent_(span("lives",282,286),span("Dorothy",274,280)).
end_(span("lives",282,286),span(20171231,195,198)).
start_(span("lives",282,286),span(20170101,195,198)).
patient_(span("labor",62,66),span("Alice",0,4)).
agent_(span("labor",62,66),span("Bob",41,43)).
purpose_(span("labor",62,66),span("agricultural labor",49,66)).
start_(span("labor",62,66),span(20170201,78,90)).
end_(span("labor",62,66),span(20170902,95,107)).
location_(span("labor",62,66),span("Caracas, Venezuela",113,130)).
country_(span("Caracas, Venezuela",113,130),span("Venezuela",122,130)).
patient_(span("citizen",152,158),span("American",143,150)).

% Test
:- tax("Alice",2017,55528).
:- halt.
