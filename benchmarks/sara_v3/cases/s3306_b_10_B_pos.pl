% Text
% Alice has employed Bob from Jan 1st, 2011 to Oct 10, 2019. On Oct 10, 2019 Bob was diagnosed as disabled and retired. Alice paid Bob $12980 because she had to terminate their contract due to Bob's disability, using the disability plan set up for all of Alice's employees.

% Question
% Section 3306(b)(10)(B) applies to the payment of $12980 that Alice made in 2019. Entailment

% Facts
:- [statutes/prolog/init].
purpose_(span("disability plan",219,233),span("make provisions for employees or dependents",219,233)).
service_(span("employed",10,17)).
disability_(span("disabled",96,103)).
retirement_(span("retired",109,115)).
payment_(span("paid",124,127)).
termination_(span("terminate",159,167)).
plan_(span("disability plan",219,233)).
start_(span("disabled",96,103),span(20191010,62,73)).
agent_(span("disabled",96,103),span("Bob",75,77)).
start_(span("paid",124,127),span(20191010,62,73)).
agent_(span("paid",124,127),span("Alice",118,122)).
patient_(span("paid",124,127),span("Bob",129,131)).
amount_(span("paid",124,127),span(12980,134,138)).
purpose_(span("paid",124,127),span("terminate",159,167)).
means_(span("paid",124,127),span("disability plan",219,233)).
agent_(span("disability plan",219,233),span("Alice",253,257)).
start_(span("retired",109,115),span(20191010,62,73)).
agent_(span("retired",109,115),span("Bob",75,77)).
reason_(span("retired",109,115),span("disability",197,206)).
patient_(span("employed",10,17),span("Alice",0,4)).
agent_(span("employed",10,17),span("Bob",19,21)).
start_(span("employed",10,17),span(20110101,28,40)).
end_(span("employed",10,17),span(20191010,45,56)).
patient_(span("terminate",159,167),span("employed",10,17)).
reason_(span("terminate",159,167),span("disabled",96,103)).
agent_(span("terminate",159,167),span("Alice",118,122)).

% Test
:- s3306_b_10_B("Alice",span("paid",124,127),_).
:- halt.
