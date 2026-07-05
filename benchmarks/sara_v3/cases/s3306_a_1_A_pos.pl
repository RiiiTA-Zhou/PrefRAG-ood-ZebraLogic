% Text
% Alice has paid wages of $3200 to Bob for work done from Feb 1st, 2017 to Sep 1st, 2017. Bob has paid wages of $4500 to Alice for work done from Apr 1st, 2017 to Sep 1st, 2018.

% Question
% Under section 3306(a)(1)(A), Alice is an employer for the year 2017. Entailment

% Facts
:- discontiguous s3306_b/8.
:- [statutes/prolog/init].
s3306_b(3200,_,span("work",41,44),"Alice","Bob","Alice","Bob",_).
start_(span("work",41,44),span(20170201,56,68)).
end_(span("work",41,44),span(20170901,73,85)).
s3306_b(4500,_,span("work",129,132),"Bob","Alice","Bob","Alice",_).
start_(span("work",129,132),span(20170401,144,156)).
end_(span("work",129,132),span(20180901,161,173)).

% Test
:- s3306_a_1_A("Alice",2017,_).
:- halt.
