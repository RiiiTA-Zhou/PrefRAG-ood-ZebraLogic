% Text
% Alice and Bob got married on Feb 3rd, 1992. Alice paid each of her 87 employees $5207 for work done in 2015. Alice paid each of her 70 employees $6341 for work done in 2016. Alice and Bob file jointly in 2015 and had no income. They take the standard deduction.

% Question
% How much tax does Alice have to pay in 2015? $27181

% Facts
:- [statutes/prolog/init].
service_(span(Service_event,70,78)) :-
    between(1,87,Employee_id),
    atom_concat('workforalice_2015_',Employee_id,Service_event).
agent_(span(Service_event,70,78),span(Employee,70,78)) :-
    split_event_name(Service_event,X,Y,Z),
    double_equal(X, "workforalice"),
    double_equal(Y, "2015"),
    atom_concat('employee_2015_',Z,Employee).
patient_(span(Service_event,70,78),span("Alice",44,48)) :-
    split_event_name(Service_event,X,_,_),
    double_equal(X, "workforalice").
patient_(span(Service_event,135,143),span("Alice",109,113)) :-
    split_event_name(Service_event,X,_,_),
    double_equal(X, "workforalice").
start_(span(Service_event,70,78),span(20150101,103,106)) :-
    split_event_name(Service_event,X,Y,_),
    double_equal(X, "workforalice"),
    double_equal(Y, "2015").
end_(span(Service_event,70,78),span(20151231,103,106)) :-
    split_event_name(Service_event,X,Y,_),
    double_equal(X, "workforalice"),
    double_equal(Y, "2015").
payment_(span(Payment_event,50,53)) :-
    between(1,87,Employee_id),
    atom_concat('payment_2015_',Employee_id,Payment_event).
agent_(span(Payment_event,50,53),span("Alice",44,48)) :-
    split_event_name(Payment_event,X,_,_),
    double_equal(X, "payment"). 
agent_(span(Payment_event,115,118),span("Alice",109,113)) :-
    split_event_name(Payment_event,X,_,_),
    double_equal(X, "payment"). 
purpose_(span(Payment_event,_,_),span(Service_event,_,_)) :-
    split_event_name(Payment_event,Xp,Yp,Zp),
    split_event_name(Service_event,Xs,Ys,Zs),
    double_equal(Xp, "payment"),
    double_equal(Xs, "workforalice"),
    double_equal(Yp, Ys),
    double_equal(Zp, Zs).
amount_(span(Payment_event,_,_),span(5207,81,84)) :-
    split_event_name(Payment_event,X,Y,_),
    double_equal(X, "payment"),
    double_equal(Y, "2015").
patient_(span(Payment_event,_,_),span(Employee,70,78)) :-
    split_event_name(Payment_event,X,Y,Z),
    atom_number(Z,Employee_id),
    double_equal(X, "payment"),
    double_equal(Y, "2015"),
    between(1,87,Employee_id),
    atom_concat('employee_2015_',Z,Employee).
start_(span(Payment_event,50,53),span(20150101,103,106)) :-
    split_event_name(Payment_event,X,Y,_),
    double_equal(X, "payment"),
    double_equal(Y, "2015").
service_(span(Service_event,135,143)) :-
    between(1,70,Employee_id),
    atom_concat('workforalice_2016_',Employee_id,Service_event).
agent_(span(Service_event,_,_),span(Employee,135,143)) :-
    split_event_name(Service_event,X,Y,Z),
    double_equal(X, "workforalice"),
    double_equal(Y, "2016"), 
    atom_concat('employee_2016_',Z,Employee). 
start_(span(Service_event,_,_),span(20160101,168,171)) :-
    split_event_name(Service_event,X,Y,_),
    double_equal(X, "workforalice"),
    double_equal(Y, "2016").
end_(span(Service_event,_,_),span(20161231,168,171)) :-
    split_event_name(Service_event,X,Y,_),
    double_equal(X, "workforalice"),
    double_equal(Y, "2016").
payment_(span(Payment_event,115,118)) :-
    between(1,70,Employee_id),
    atom_concat('payment_2016_',Employee_id,Payment_event).
amount_(span(Payment_event,_,_),span(6341,146,149)) :-
    split_event_name(Payment_event,X,Y,_),
    double_equal(X, "payment"),
    double_equal(Y, "2016").
patient_(span(Payment_event,_,_),span(Employee,135,143)) :-
    split_event_name(Payment_event,X,Y,Z),
    atom_number(Z,Employee_id),
    double_equal(X, "payment"),
    double_equal(Y, "2016"),
    between(1,70,Employee_id),
    atom_concat('employee_2016_',Z,Employee).
start_(span(Payment_event,_,_),span(20161231,168,171)) :-
    split_event_name(Payment_event,X,Y,_),
    double_equal(X, "payment"),
    double_equal(Y, "2016").
marriage_(span("married",18,24)).
joint_return_(span("jointly",193,199)).
agent_(span("jointly",193,199),span("Alice",174,178)).
agent_(span("jointly",193,199),span("Bob",184,186)).
end_(span("jointly",193,199),span(20151231,204,207)).
start_(span("jointly",193,199),span(20150101,204,207)).
agent_(span("married",18,24),span("Alice",0,4)).
agent_(span("married",18,24),span("Bob",10,12)).
start_(span("married",18,24),span(19920203,29,41)).

% Test
:- tax("Alice",2015,27181).
:- halt.
