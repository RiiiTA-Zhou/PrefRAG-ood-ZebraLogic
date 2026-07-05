% Text
% In 2016, Alice's gross income was $567192.
% Alice has employed Bob, Cameron, Dan, Emily, Fred and George for agricultural labor on various occasions during the year 2016:
% - Jan 23: Bob, Cameron, Dan, Emily and Fred
% - Feb 4: Bob, Cameron and Fred
% - Mar 3: Bob, Cameron, Dan, Emily and Fred
% - Mar 19: Cameron, Dan, Emily, Fred and George
% - Apr 2: Bob, Cameron, Dan, Fred and George
% - May 9: Cameron, Dan, Emily, Fred and George
% - Oct 15: Bob, Cameron, Dan, Emily and George
% - Oct 25: Bob, Emily, Fred and George
% - Nov 8: Bob, Cameron, Emily, Fred and George
% - Nov 22: Bob, Cameron, Dan, Emily and Fred
% - Dec 1: Bob, Cameron, Dan, Emily and George
% - Dec 3: Bob, Cameron, Dan, Emily and George
% On each occasion, Alice paid each of them $550. Alice takes the standard deduction in 2016.

% Question
% How much tax does Alice have to pay in 2016? $206073

% Facts
:- [statutes/prolog/init].
agricultural_service(Event,Employee,Day) :-
    member(Dayi, [20160123,20160204,20160303,20160319,20160402,20160509,20161015,20161025,20161108,20161122,20161201,20161203]),
    (
        (
            double_equal(Dayi, 20160123),
            Day = span(Dayi,172,177),
            member(Employee, [span("Bob",180,182),span("Cameron",185,191),span("Dan",194,196),span("Emily",199,203),span("Fred",209,212)])
        );
        (
            double_equal(Dayi, 20160204),
            Day = span(Dayi,216,220),
            member(Employee, [span("Bob",223,225),span("Cameron",228,234),span("Fred",240,243)])
        );
        (
            double_equal(Dayi, 20160303),
            Day = span(Dayi,247,251),
            member(Employee, [span("Bob",254,256),span("Cameron",259,265),span("Dan",268,270),span("Emily",273,277),span("Fred",283,286)])
        );
        (
            double_equal(Dayi, 20160319),
            Day = span(Dayi,290,295),
            member(Employee, [span("Cameron",298,304),span("Dan",307,309),span("Emily",312,316),span("Fred",319,322),span("George",328,333)])
        );
        (
            double_equal(Dayi, 20160402),
            Day = span(Dayi,337,341),
            member(Employee, [span("Bob",344,346),span("Cameron",349,355),span("Dan",358,360),span("Fred",363,366),span("George",372,377)])
        );
        (
            double_equal(Dayi, 20160509),
            Day = span(Dayi,381,385),
            member(Employee, [span("Cameron",388,394),span("Dan",397,399),span("Emily",402,406),span("Fred",409,412),span("George",418,423)])
        );
        (
            double_equal(Dayi, 20161015),
            Day = span(Dayi,427,432),
            member(Employee, [span("Bob",435,437),span("Cameron",440,446),span("Dan",449,451),span("Emily",454,458),span("George",464,469)])
        );
        (
            double_equal(Dayi, 20161025),
            Day = span(Dayi,473,478),
            member(Employee, [span("Bob",481,483),span("Emily",486,490),span("Fred",493,496),span("George",502,507)])
        );
        (
            double_equal(Dayi, 20161108),
            Day = span(Dayi,511,515),
            member(Employee, [span("Bob",518,520),span("Cameron",523,529),span("Emily",532,536),span("Fred",539,542),span("George",548,553)])
        );
        (
            double_equal(Dayi, 20161122),
            Day = span(Dayi,557,562),
            member(Employee, [span("Bob",565,567),span("Cameron",570,576),span("Dan",579,581),span("Emily",584,588),span("Fred",594,597)])
        );
        (
            double_equal(Dayi, 20161201),
            Day = span(Dayi,601,605),
            member(Employee, [span("Bob",608,610),span("Cameron",613,619),span("Dan",622,624),span("Emily",627,631),span("George",637,642)])
        );
        (
            double_equal(Dayi, 20161203),
            Day = span(Dayi,646,650),
            member(Employee, [span("Bob",653,655),span("Cameron",658,664),span("Dan",667,669),span("Emily",672,676),span("George",682,687)])
        )
    ),
    atom_concat("employed ",Dayi,Tmp),
    atom_concat(Tmp,"_",Tmp2),
    span(Employee_name,_,_) = Employee,
    atom_concat(Tmp2,Employee_name,Event_name),
    Event=span(Event_name,121,125).
purpose_(Event,span("agricultural labor",108,125)) :-
    agricultural_service(Event,_,_).
service_(Event) :- agricultural_service(Event,_,_).
agent_(Event,Employee) :- agricultural_service(Event,Employee,_).
patient_(Event,span("Alice",43,47)) :- agricultural_service(Event,_,_).
start_(Event,Day) :- agricultural_service(Event,_,Day).
end_(Event,Day) :- agricultural_service(Event,_,Day).
payment_for_labor(Payment_event,Service_event,Employee,Day) :-
    agricultural_service(Service_event,Employee,Day),
    span(Service_event_name,_,_) = Service_event,
    atom_concat(Service_event_name," paid ",Payment_event_name),
    Payment_event = span(Payment_event_name,713,716).
payment_(Event) :- payment_for_labor(Event,_,_,_).
agent_(Event,span("Alice",707,711)) :- payment_for_labor(Event,_,_,_).
patient_(Event,Employee) :- payment_for_labor(Event,_,Employee,_).
start_(Event,Day) :- payment_for_labor(Event,_,_,Day).
amount_(Event,span(550,732,734)) :- payment_for_labor(Event,_,_,_).
purpose_(Payment_event,Service_event) :-
    payment_for_labor(Payment_event,Service_event,_,_).
income_(span("income",23,28)).
start_(span("income",23,28),span(20160101,3,6)).
agent_(span("income",23,28),span("Alice",9,13)).
amount_(span("income",23,28),span(567192,35,40)).

% Test
:- tax("Alice",2016,206073).
:- halt.
