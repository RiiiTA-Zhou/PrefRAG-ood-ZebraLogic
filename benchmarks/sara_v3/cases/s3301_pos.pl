% Text
% Alice is an employer under section 3306(a) for the year 2015 and 2016, and she has paid $453009 in total wages in 2015, and $443870 in 2016.

% Question
% Alice has to pay $27181 in excise tax for the year 2015 under section 3301. Entailment

% Facts
:- discontiguous total_wages_employer/6.
:- discontiguous s3306_a/2.
:- [statutes/prolog/init].
s3306_a("Alice",2015).
s3306_a("Alice",2016).
total_wages_employer("Alice",453009,_,_,20150101,20151231).
total_wages_employer("Alice",443870,_,_,20160101,20161231).

% Test
:- s3301("Alice",2015,_,_,_,27181).
:- halt.
