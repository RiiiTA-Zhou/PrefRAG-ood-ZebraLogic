% Text
% Alice and Bob have been married since 2 Feb 2015. Charlie counts as Alice's dependent under section 152(c)(1) for 2015.

% Question
% Alice can claim an exemption with Bob as the dependent for 2015 under section 151(c). Contradiction

% Facts
:- discontiguous s152_c_1/3.
:- [statutes/prolog/init].
s152_c_1("Charlie","Alice",2015).
marriage_(span("married",24,30)).
agent_(span("married",24,30),span("Alice",0,4)).
agent_(span("married",24,30),span("Bob",10,12)).
start_(span("married",24,30),span(20150202,38,47)).

% Test
:- \+ s151_c("Alice","Bob",_,2015).
:- halt.
