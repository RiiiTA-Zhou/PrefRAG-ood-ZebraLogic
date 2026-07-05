% Text
% Alice has paid $45252 to Bob for work done in the year 2017. In 2017, Alice has also paid $9832 into a retirement fund for Bob, and paid $5322 into health insurance for Charlie, who is Alice's father and has retired in 2016.

% Question
% Section 3306(b)(2)(A) applies to the payment Alice made to Bob for the year 2017. Contradiction

% Facts
:- [statutes/prolog/init].
purpose_(span("retirement fund",103,117),span("make provisions for employees in case of retirement",103,117)).
purpose_(span("health insurance",148,163),span("make provisions for employees in case of sickness",148,163)).
payment_(span("paid",10,13)).
service_(span("work",33,36)).
payment_(span("paid",85,88)).
plan_(span("retirement fund",103,117)).
payment_(span("paid",132,135)).
plan_(span("health insurance",148,163)).
father_(span("father",193,198)).
retirement_(span("retired",208,214)).
agent_(span("father",193,198),span("Charlie",169,175)).
patient_(span("father",193,198),span("Alice",185,189)).
start_(span("paid",132,135),span(20170101,64,67)).
amount_(span("paid",132,135),span(5322,138,141)).
patient_(span("paid",132,135),span("health insurance",148,163)).
beneficiary_(span("paid",132,135),span("Charlie",169,175)).
agent_(span("paid",132,135),span("Alice",70,74)).
start_(span("paid",85,88),span(20170101,64,67)).
agent_(span("paid",85,88),span("Alice",70,74)).
amount_(span("paid",85,88),span(9832,91,94)).
patient_(span("paid",85,88),span("retirement fund",103,117)).
beneficiary_(span("paid",85,88),span("Bob",123,125)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(45252,16,20)).
patient_(span("paid",10,13),span("Bob",25,27)).
purpose_(span("paid",10,13),span("work",33,36)).
start_(span("paid",10,13),span(20170101,55,58)).
agent_(span("retired",208,214),span("Charlie",169,175)).
start_(span("retired",208,214),span(20160101,219,222)).
patient_(span("work",33,36),span("Alice",0,4)).
agent_(span("work",33,36),span("Bob",25,27)).
end_(span("work",33,36),span(20171231,55,58)).
start_(span("work",33,36),span(20170101,55,58)).

% Test
:- \+ s3306_b_2_A(span("paid",10,13)).
:- halt.
