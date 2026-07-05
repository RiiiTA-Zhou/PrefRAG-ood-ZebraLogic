% Text
% Alice and Charlie have been married since 2 Feb 2015. Bob counts as Alice's dependent under section 152(c)(1) for 2015.

% Question
% Alice can claim an exemption with Bob the dependent for 2015 under section 151(c). Entailment

% Facts
:- discontiguous s152_c_1/3.
:- [statutes/prolog/init].
s152_c_1("Bob","Alice",2015).
marriage_(span("married",28,34)).
agent_(span("married",28,34),span("Alice",0,4)).
agent_(span("married",28,34),span("Charlie",10,16)).
start_(span("married",28,34),span(20150202,42,51)).

% Test
:- s151_c("Alice","Bob",_,2015).
:- halt.
