% Text
% Alice is married under section 7703 for the year 2017. Alice files a joint return with her spouse for 2017. Alice's and her spouse's taxable income for the year 2017 is $17330.

% Question
% Alice and her spouse have to pay $2600 in taxes for the year 2017 under section 1(a)(i). Entailment

% Facts
:- discontiguous s63/3.
:- discontiguous s7703/4.
:- [statutes/prolog/init].
s7703("Alice","spouse",_,2017).
s63("Alice",2017,17330).
joint_return_(span("joint return",69,80)).
agent_(span("joint return",69,80),span("Alice",55,59)).
agent_(span("joint return",69,80),span("spouse",91,96)).
start_(span("joint return",69,80),span(20170101,102,105)).

% Test
:- s1_a_i(17330,2600).
:- halt.
