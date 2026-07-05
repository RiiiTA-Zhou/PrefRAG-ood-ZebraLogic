% Text
% Alice has a son, Bob. From September 1st, 2015 to November 3rd, 2019, Alice and Bob lived in the same home. Bob married Charlie on October 23rd, 2018. Bob satisfied section 152(c)(2) and 152(c)(3) with Alice as the taxpayer for the years 2015 to 2020.

% Question
% Under section 152(c)(1), Bob is a qualifying child of Alice for the year 2019. Entailment

% Facts
:- discontiguous s152_c_3/3.
:- discontiguous s152_c_2/4.
:- [statutes/prolog/init].
s152_c_2("Bob","Alice",20150101,20201231).
s152_c_3("Bob","Alice",Year) :- between(2015,2020,Year).
son_(span("son",12,14)).
residence_(span("lived",84,88)).
marriage_(span("married",112,118)).
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
:- s152_c_1("Bob","Alice",2019).
:- halt.
