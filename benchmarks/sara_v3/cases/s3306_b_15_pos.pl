% Text
% Alice employed Bob for agricultural labor from Feb 1st, 2011 to November 19th, 2019. On November 25th, Bob died from a heart attack. On January 20th, 2020, Alice paid Charlie, Bob's surviving spouse, Bob's outstanding wages of $1200.

% Question
% Section 3306(b)(15) applies to the payment that Alice made to Charlie in 2020. Entailment

% Facts
:- discontiguous s3306_c/5.
:- [statutes/prolog/init].
s3306_c(span("labor",36,40),"Alice","Bob",Day,_) :-
    (
        nonvar(Day),
        is_before(20110201,Day),
        is_before(Day,20191119)
    );
    var(Day).
death_(span("died",107,110)).
payment_(span("paid",162,165)).
marriage_(span("spouse",192,197)).
start_(span("died",107,110),span(20191125,88,100)).
agent_(span("died",107,110),span("Bob",103,105)).
agent_(span("spouse",192,197),span("Charlie",167,173)).
agent_(span("spouse",192,197),span("Bob",176,178)).
purpose_(span("labor",36,40),span("agricultural labor",23,40)).
purpose_(span("paid",162,165),span("labor",36,40)).
start_(span("paid",162,165),span(20200120,136,153)).
agent_(span("paid",162,165),span("Alice",156,160)).
patient_(span("paid",162,165),span("Charlie",167,173)).
amount_(span("paid",162,165),span(1200,228,231)).

% Test
:- s3306_b_15(span("paid",162,165),"Alice","Charlie",_,_).
:- halt.
