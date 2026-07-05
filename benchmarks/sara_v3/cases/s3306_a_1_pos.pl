% Text
% Alice has paid wages of $3200 to Bob for domestic service done from Feb 1st, 2017 to Sep 2nd, 2017. In 2018, Bob has paid wages of $4500 to Alice for work done from Apr 1st, 2017 to Sep 1st, 2018.

% Question
% Bob is an employer under section 3306(a)(1) for the year 2018. Entailment

% Facts
:- discontiguous s3306_b/8.
:- [statutes/prolog/init].
s3306_b(3200,span("paid",10,13),span("service",50,56),"Alice","Bob","Alice","Bob",_).
s3306_b(4500,span("paid",117,120),span("work",150,153),"Bob","Alice","Bob","Alice",_).
payment_(span("paid",10,13)).
service_(span("service",50,56)).
payment_(span("paid",117,120)).
service_(span("work",150,153)).
agent_(span("paid",10,13),span("Alice",0,4)).
amount_(span("paid",10,13),span(3200,25,28)).
patient_(span("paid",10,13),span("Bob",33,35)).
purpose_(span("paid",10,13),span("service",50,56)).
start_(span("paid",10,13),span(20170902,85,97)).
agent_(span("paid",117,120),span("Bob",109,111)).
amount_(span("paid",117,120),span(4500,132,135)).
patient_(span("paid",117,120),span("Alice",140,144)).
purpose_(span("paid",117,120),span("work",150,153)).
start_(span("paid",117,120),span(20180101,103,106)).
patient_(span("service",50,56),span("Alice",0,4)).
agent_(span("service",50,56),span("Bob",33,35)).
purpose_(span("service",50,56),span("domestic service",41,56)).
start_(span("service",50,56),span(20170201,68,80)).
end_(span("service",50,56),span(20170902,85,97)).
start_(span("work",150,153),span(20170401,165,177)).
end_(span("work",150,153),span(20180901,182,194)).
patient_(span("work",150,153),span("Bob",109,111)).
agent_(span("work",150,153),span("Alice",140,144)).

% Test
:- s3306_a_1("Bob",2018).
:- halt.
