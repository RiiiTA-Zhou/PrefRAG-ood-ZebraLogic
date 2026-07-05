% Text
% Alice has paid $45252 to Bob for work done in the year 2017. In 2017, Alice has also paid $9832 into a retirement fund for Bob, and paid $5322 into life insurance for Bob.

% Question
% Section 3306(b)(2)(C) applies to the payment Alice made to the life insurance fund for the year 2017. Entailment

% Facts
:- [statutes/prolog/init].
purpose_(span("retirement fund",103,117),span("make provisions for employees in case of retirement",103,117)).
purpose_(span("life insurance",148,161),span("make provisions for employees in case of death",148,161)).
payment_(span("paid",10,13)).
service_(span("work",33,36)).
payment_(span("paid",85,88)).
plan_(span("retirement fund",103,117)).
payment_(span("paid",132,135)).
plan_(span("life insurance",148,161)).
start_(span("paid",132,135),span(20170101,64,67)).
agent_(span("paid",132,135),span("Alice",70,74)).
amount_(span("paid",132,135),span(5322,138,141)).
patient_(span("paid",132,135),span("life insurance",148,161)).
start_(span("paid",85,88),span(20170101,64,67)).
agent_(span("paid",85,88),span("Alice",70,74)).
amount_(span("paid",85,88),span(9832,91,94)).
patient_(span("paid",85,88),span("retirement fund",103,117)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(45252,16,20)).
patient_(span("paid",10,13),span("Bob",25,27)).
purpose_(span("paid",10,13),span("work",33,36)).
start_(span("paid",10,13),span(20170101,55,58)).
beneficiary_(span("life insurance",148,161),span("Bob",167,169)).
beneficiary_(span("retirement fund",103,117),span("Bob",123,125)).
patient_(span("work",33,36),span("Alice",0,4)).
agent_(span("work",33,36),span("Bob",25,27)).
end_(span("work",33,36),span(20171231,55,58)).
start_(span("work",33,36),span(20170101,55,58)).

% Test
:- s3306_b_2_C(span("life insurance",148,161)).
:- halt.
