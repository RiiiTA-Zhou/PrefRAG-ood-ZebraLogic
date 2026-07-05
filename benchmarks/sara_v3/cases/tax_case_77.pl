% Text
% Alice's gross income for the year 2023 is $54775. In 2023, Bob, the son of her son Charlie, lives at her place, a house that she maintains. Bob has no income in 2023. Alice takes the standard deduction.

% Question
% How much tax does Alice have to pay in 2023? $6449

% Facts
:- [statutes/prolog/init].
income_(span("income",14,19)).
son_(span("son",68,70)).
son_(span("son",79,81)).
residence_(span("lives",92,96)).
residence_(span("place",105,109)).
payment_(span("maintains",129,137)).
agent_(span("income",14,19),span("Alice",0,4)).
start_(span("income",14,19),span(20230101,34,37)).
amount_(span("income",14,19),span(54775,43,47)).
purpose_(span("maintains",129,137),span("house",114,118)).
amount_(span("maintains",129,137),span(1,129,137)).
start_(span("maintains",129,137),span(20230101,53,56)).
agent_(span("maintains",129,137),span("Alice",0,4)).
patient_(span("place",105,109),span("house",114,118)).
end_(span("place",105,109),span(20231231,53,56)).
start_(span("place",105,109),span(20230101,53,56)).
agent_(span("place",105,109),span("Alice",0,4)).
patient_(span("lives",92,96),span("house",114,118)).
agent_(span("lives",92,96),span("Bob",59,61)).
end_(span("lives",92,96),span(20231231,53,56)).
start_(span("lives",92,96),span(20230101,53,56)).
agent_(span("son",68,70),span("Bob",59,61)).
patient_(span("son",68,70),span("Charlie",83,89)).
patient_(span("son",79,81),span("Alice",0,4)).
agent_(span("son",79,81),span("Charlie",83,89)).

% Test
:- tax("Alice",2023,6449).
:- halt.
