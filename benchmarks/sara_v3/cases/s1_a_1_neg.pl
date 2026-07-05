% Text
% Alice is a head of household for the year 2017. Alice's taxable income for the year 2017 is $97407.

% Question
% Alice has to pay $24056 in taxes for the year 2017 under section 1(a). Contradiction

% Facts
:- discontiguous s2_b/3.
:- discontiguous s63/3.
:- [statutes/prolog/init].
s2_b("Alice",_,2017).
s63("Alice",2017,97407).

% Test
:- \+ s1_a("Alice",2017,_,24056).
:- halt.
