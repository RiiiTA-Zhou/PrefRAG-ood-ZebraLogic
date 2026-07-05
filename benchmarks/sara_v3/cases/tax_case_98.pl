% Text
% Alice has a son, Bob, who in 2015 lives with her at the house she maintains as her home. Alice was paid $73200 in 2015 as an employee of Bertha's Mussels in Baltimore, Maryland, USA. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2015? $14296

% Facts
:- [statutes/prolog/init].
son_(span("son",12,14)).
residence_(span("lives",34,38)).
payment_(span("maintains",66,74)).
payment_(span("paid",99,102)).
service_(span("employee",125,132)).
amount_(span("maintains",66,74),span(1,66,74)).
start_(span("maintains",66,74),span(20150101,29,32)).
purpose_(span("maintains",66,74),span("house",56,60)).
agent_(span("maintains",66,74),span("Alice",0,4)).
patient_(span("paid",99,102),span("Alice",89,93)).
amount_(span("paid",99,102),span(73200,105,109)).
start_(span("paid",99,102),span(20151231,114,117)).
purpose_(span("paid",99,102),span("employee",125,132)).
agent_(span("paid",99,102),span("Bertha's Mussels",137,152)).
agent_(span("lives",34,38),span("Bob",17,19)).
end_(span("lives",34,38),span(20151231,29,32)).
start_(span("lives",34,38),span(20150101,29,32)).
patient_(span("lives",34,38),span("house",56,60)).
agent_(span("lives",34,38),span("Alice",0,4)).
agent_(span("employee",125,132),span("Alice",89,93)).
end_(span("employee",125,132),span(20151231,114,117)).
start_(span("employee",125,132),span(20150101,114,117)).
patient_(span("employee",125,132),span("Bertha's Mussels",137,152)).
location_(span("employee",125,132),span("Baltimore",157,165)).
location_(span("employee",125,132),span("Maryland",168,175)).
location_(span("employee",125,132),span("USA",178,180)).
patient_(span("son",12,14),span("Alice",0,4)).
agent_(span("son",12,14),span("Bob",17,19)).

% Test
:- tax("Alice",2015,14296).
:- halt.
