% Text
% From 1973 to 2019, the Walter Brown Family Trust II was considered to be a business trust.

% Question
% Section 63(c)(6)(D) applies to the Walter Brown Family Trust II for 2021. Contradiction

% Facts
:- [statutes/prolog/init].
business_trust_(span("business trust",75,88)).
start_(span("business trust",75,88),span(19730101,5,8)).
end_(span("business trust",75,88),span(20191231,13,16)).
agent_(span("business trust",75,88),span("Walter Brown Family Trust II",23,50)).

% Test
:- \+ s63_c_6_D("Walter Brown Family Trust II",2021).
:- halt.
