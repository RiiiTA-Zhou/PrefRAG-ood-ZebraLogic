% Text
% Alice has a son, Bob. From September 1st, 2015 to November 3rd, 2019, Alice and Bob lived in the same home. Bob married Charlie on October 23rd, 2018. Bob and Charlie filed a joint return for the year 2019.

% Question
% Section 152(c)(1)(E) applies to Bob for the year 2019. Contradiction

% Facts
:- [statutes/prolog/init].
son_(span("son",12,14)).
residence_(span("lived",84,88)).
marriage_(span("married",112,118)).
joint_return_(span("joint return",175,186)).
agent_(span("joint return",175,186),span("Bob",151,153)).
agent_(span("joint return",175,186),span("Charlie",159,165)).
start_(span("joint return",175,186),span(20190101,201,204)).
agent_(span("married",112,118),span("Bob",108,110)).
agent_(span("married",112,118),span("Charlie",120,126)).
start_(span("married",112,118),span(20181023,131,148)).
start_(span("lived",84,88),span(20150901,27,45)).
end_(span("lived",84,88),span(20191103,50,67)).
agent_(span("lived",84,88),span("Alice",70,74)).
agent_(span("lived",84,88),span("Bob",80,82)).
patient_(span("lived",84,88),span("home",102,105)).
patient_(span("son",12,14),span("Alice",0,4)).
agent_(span("son",12,14),span("Bob",17,19)).

% Test
:- \+ s152_c_1_E("Bob",_,2019).
:- halt.
