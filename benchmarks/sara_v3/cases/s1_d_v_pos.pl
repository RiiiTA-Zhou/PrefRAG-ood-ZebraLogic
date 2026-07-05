% Text
% Alice is married under section 7703 for the year 2017. Alice's taxable income for the year 2017 is $554313. Alice files a separate return.

% Question
% Alice has to pay $207772 in taxes for the year 2017 under section 1(d)(v). Entailment

% Facts
:- discontiguous s7703/4.
:- discontiguous s63/3.
:- [statutes/prolog/init].
s7703("Alice","married",_,2017).
s63("Alice",2017,554313).

% Test
:- s1_d_v(554313,207772).
:- halt.
