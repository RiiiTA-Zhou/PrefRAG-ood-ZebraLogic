% Text
% Alice got married on June 2nd, 2006. Alice files a joint return with her spouse for 2017. Alice's and her spouse's gross income for the year 2017 is $684642. They take the standard deduction in 2017.
% Alice has employed Bob, Cameron, Dan, Emily, Fred and George for agricultural labor on various occasions during the year 2017:
% - Jan 24: Bob, Cameron, Dan, Emily and Fred
% - Feb 4: Bob, Cameron and Fred
% - Mar 3: Bob, Cameron, Dan, Emily and Fred
% - Mar 18: Cameron, Dan, Emily, Fred and George
% - Apr 1: Bob, Cameron, Dan, Fred and George
% - May 9: Cameron, Dan, Emily, Fred and George
% - Oct 14: Bob, Cameron, Dan, Emily and George
% - Oct 25: Bob, Emily, Fred and George
% - Nov 8: Bob, Cameron, Emily, Fred and George
% - Nov 22: Bob, Cameron, Dan, Emily and Fred
% - Dec 1: Bob, Cameron, Dan, Emily and George
% - Dec 2: Bob, Cameron, Dan, Emily and George
% Alice has paid each $632 on each occasion.

% Question
% How much tax does Alice have to pay in 2017? $247432

% Facts
:- [statutes/prolog/init].
agricultural_service(Event,Employee,Day) :-
    member(Dayi, [20170124,20170204,20170303,20170318,20170401,20170509,20171014,20171025,20171108,20171122,20171201,20171202]),
    (
        (
            double_equal(Dayi, 20170124),
            Day = span(Dayi,329,334),
            member(Employee, [span("Bob",337,339),span("Cameron",342,348),span("Dan",351,353),span("Emily",356,360),span("Fred",366,369)])
        );
        (
            double_equal(Dayi, 20170204),
            Day = span(Dayi,373,377),
            member(Employee, [span("Bob",380,382),span("Cameron",385,391),span("Fred",397,401)])
        );
        (
            double_equal(Dayi, 20170303),
            Day = span(Dayi,404,408),
            member(Employee, [span("Bob",411,413),span("Cameron",416,422),span("Dan",425,427),span("Emily",430,434),span("Fred",440,443)])
        );
        (
            double_equal(Dayi, 20170318),
            Day = span(Dayi,447,452),
            member(Employee, [span("Cameron",455,461),span("Dan",464,466),span("Emily",469,473),span("Fred",476,479),span("George",485,490)])
        );
        (
            double_equal(Dayi, 20170401),
            Day = span(Dayi,494,498),
            member(Employee, [span("Bob",501,503),span("Cameron",506,512),span("Dan",515,517),span("Fred",520,523),span("George",529,534)])
        );
        (
            double_equal(Dayi, 20170509),
            Day = span(Dayi,538,542),
            member(Employee, [span("Cameron",545,551),span("Dan",554,556),span("Emily",559,563),span("Fred",566,569),span("George",575,580)])
        );
        (
            double_equal(Dayi, 20171014),
            Day = span(Dayi,584,589),
            member(Employee, [span("Bob",592,594),span("Cameron",597,603),span("Dan",606,608),span("Emily",611,615),span("George",621,626)])
        );
        (
            double_equal(Dayi, 20171025),
            Day = span(Dayi,630,635),
            member(Employee, [span("Bob",638,640),span("Emily",643,647),span("Fred",650,653),span("George",659,664)])
        );
        (
            double_equal(Dayi, 20171108),
            Day = span(Dayi,668,672),
            member(Employee, [span("Bob",675,677),span("Cameron",680,686),span("Emily",689,693),span("Fred",696,699),span("George",705,710)])
        );
        (
            double_equal(Dayi, 20171122),
            Day = span(Dayi,714,719),
            member(Employee, [span("Bob",722,724),span("Cameron",727,733),span("Dan",736,738),span("Emily",741,745),span("Fred",751,754)])
        );
        (
            double_equal(Dayi, 20171201),
            Day = span(Dayi,758,762),
            member(Employee, [span("Bob",765,767),span("Cameron",770,776),span("Dan",779,781),span("Emily",784,788),span("George",794,799)])
        );
        (
            double_equal(Dayi, 20171202),
            Day = span(Dayi,803,807),
            member(Employee, [span("Bob",810,812),span("Cameron",815,821),span("Dan",824,826),span("Emily",829,833),span("George",839,844)])
        )
    ),
    atom_concat("employed ",Dayi,Tmp),
    atom_concat(Tmp,"_",Tmp2),
    span(Employee_name,_,_) = Employee,
    atom_concat(Tmp2,Employee_name,Event_name),
    Event = span(Event_name,210,217).
purpose_(Event,span("agricultural labor",265,282)) :-
    agricultural_service(Event,_,_).
service_(Event) :- agricultural_service(Event,_,_).
agent_(Event,Employee) :- agricultural_service(Event,Employee,_).
patient_(Event,span("Alice",200,204)) :- agricultural_service(Event,_,_).
start_(Event,Day) :- agricultural_service(Event,_,Day).
end_(Event,Day) :- agricultural_service(Event,_,Day).
payment_for_labor(Payment_event,Service_event,Employee,Day) :-
    agricultural_service(Service_event,Employee,Day),
    span(Service_name,_,_) = Service_event,
    atom_concat(Service_name," paid ",Payment_name),
    span(Payment_name,_,_) = Payment_event.
payment_(Event) :- payment_for_labor(Event,_,_,_).
agent_(Event,span("Alice",846,850)) :- payment_for_labor(Event,_,_,_).
patient_(Event,Employee) :- payment_for_labor(Event,_,Employee,_).
start_(Event,Day) :- payment_for_labor(Event,_,_,Day).
amount_(Event,span(632,867,869)) :- payment_for_labor(Event,_,_,_).
purpose_(Payment_event,Service_event) :-
    payment_for_labor(Payment_event,Service_event,_,_).
marriage_(span("married",10,16)).
joint_return_(span("joint return",51,62)).
income_(span("income",121,126)).
agent_(span("income",121,126),span("Alice",90,94)).
start_(span("income",121,126),span(20170101,141,144)).
amount_(span("income",121,126),span(684642,150,155)).
agent_(span("joint return",51,62),span("Alice",37,41)).
agent_(span("joint return",51,62),span("spouse",73,78)).
end_(span("joint return",51,62),span(20171231,84,87)).
start_(span("joint return",51,62),span(20170101,84,87)).
agent_(span("married",10,16),span("Alice",0,4)).
start_(span("married",10,16),span(20060602,21,34)).
agent_(span("married",10,16),span("spouse",73,78)).

% Test
:- tax("Alice",2017,247432).
:- halt.
