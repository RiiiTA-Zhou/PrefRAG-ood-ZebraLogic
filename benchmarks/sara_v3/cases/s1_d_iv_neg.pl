% Text
% Alice is married under section 7703 for the year 2017. Alice's taxable income for the year 2017 is $28864. Alice files a separate return.

% Question
% Alice has to pay $5683 in taxes for the year 2017 under section 1(d)(iv). Contradiction

% Facts
:- discontiguous s7703/4.
:- discontiguous s63/3.
:- [statutes/prolog/init].
s7703("Alice",_,_,2017).
s63("Alice",2017,28864).

% Test
:- \+ s1_d_iv(28864,5683).
:- halt.
