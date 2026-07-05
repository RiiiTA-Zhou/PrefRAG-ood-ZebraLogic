% Text
% Alice and Bob have been married since 2 Feb 2015. Bob has no income for 2015. Alice and Bob file their taxes jointly for 2015.

% Question
% Alice can receive an exemption for Bob under section 151(b) for the year 2015. Contradiction

% Facts
:- [statutes/prolog/init].
marriage_(span("married",24,30)).
joint_return_(span("jointly",109,115)).
agent_(span("jointly",109,115),span("Alice",78,82)).
agent_(span("jointly",109,115),span("Bob",88,90)).
start_(span("jointly",109,115),span(20150101,121,124)).
agent_(span("married",24,30),span("Alice",0,4)).
agent_(span("married",24,30),span("Bob",10,12)).
start_(span("married",24,30),span(20150202,38,47)).

% Test
:- \+ s151_b("Alice","Bob",2015).
:- halt.
