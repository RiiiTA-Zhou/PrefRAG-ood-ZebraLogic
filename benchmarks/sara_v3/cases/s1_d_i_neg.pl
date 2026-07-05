% Text
% Alice is married under section 7703 for the year 2017. Alice's taxable income for the year 2017 is $67285. Alice files taxes separately in 2017.

% Question
% Alice has to pay $17123 in taxes for the year 2017 under section 1(d)(i). Contradiction

% Facts
:- discontiguous s7703/4.
:- discontiguous s63/3.
:- [statutes/prolog/init].
s7703("Alice",_,_,2017).
s63("Alice",2017,67285).

% Test
:- \+ s1_d_i(67285,17123).
:- halt.
