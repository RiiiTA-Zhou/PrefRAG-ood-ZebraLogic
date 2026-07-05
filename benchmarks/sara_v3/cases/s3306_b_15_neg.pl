% Text
% Alice employed Bob for agricultural labor from Feb 1st, 2011 to November 19th, 2019. On November 25th, Bob died from a heart attack. On December 20th, 2019, Alice paid Charlie, Bob's surviving spouse, Bob's outstanding wages of $1200.

% Question
% Section 3306(b)(15) applies to the payment that Alice made to Charlie in 2019. Contradiction

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
payment_(span("paid",163,166)).
marriage_(span("spouse",193,198)).
start_(span("died",107,110),span(20191125,88,100)).
agent_(span("died",107,110),span("Bob",103,105)).
agent_(span("spouse",193,198),span("Charlie",168,174)).
agent_(span("spouse",193,198),span("Bob",177,179)).
purpose_(span("labor",36,40),span("agricultural labor",23,40)).
purpose_(span("paid",163,166),span("labor",36,40)).
start_(span("paid",163,166),span(20191220,136,154)).
agent_(span("paid",163,166),span("Alice",157,161)).
patient_(span("paid",163,166),span("Charlie",168,174)).
amount_(span("paid",163,166),span(1200,229,232)).

% Test
:- \+ s3306_b_15(span("paid",163,166),"Alice","Charlie",_,_).
:- halt.
