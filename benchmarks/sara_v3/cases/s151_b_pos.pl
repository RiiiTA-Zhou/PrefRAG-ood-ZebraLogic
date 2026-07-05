% Text
% Alice and Bob have been married since 2 Feb 2015. Bob has no income for 2015.
%
% Question
% Alice can receive an exemption for Bob under section 151(b) for the year 2015. Entailment

% Facts
:- [statutes/prolog/init].
marriage_(span("married",24,30)).
agent_(span("married",24,30),span("Alice",0,4)).
agent_(span("married",24,30),span("Bob",10,12)).
start_(span("married",24,30),span(20150202,38,47)).

% Test
:- s151_b("Alice","Bob",_,2015).
:- halt.
