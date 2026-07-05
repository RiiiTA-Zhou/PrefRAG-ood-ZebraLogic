% Text
% In 2016, Alice's income was $267192. Alice is a head of household for the year 2016. Alice is allowed itemized deductions of $60000 under section 63.

% Question
% Section 68(a)(1) prescribes a reduction of Alice's itemized deductions for the year 2016 by $306. Contradiction

% Facts
:- discontiguous s2_b/3.
:- [statutes/prolog/init].
s2_b("Alice",_,2016).
income_(span("income",17,22)).
agent_(span("income",17,22),span("Alice",9,13)).
amount_(span("income",17,22),span(267192,29,34)).
start_(span("income",17,22),span(20160101,3,6)).

% Test
goal :- \+ (
    s68_b("Alice",Applicable_amount,2016),
    gross_income("Alice",2016,Gross_income),
    s68_a_1(Gross_income,Applicable_amount,306)
    ).
:- goal.
:- halt.
