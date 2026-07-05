%S1. Tax imposed
s1(Taxp,Taxy,Taxinc,Tax) :-
    s1_a(Taxp,Taxy,Taxinc,Tax);
    s1_b(Taxp,Taxy,Taxinc,Tax);
    s1_c(Taxp,Taxy,Taxinc,Tax);
    s1_d(Taxp,_,Taxy,Taxinc,Tax).

%(a) Married individuals filing joint returns and surviving spouses
s1_a(Taxp,Taxy,Taxinc,Tax) :-
    s1_a_1(Taxp,_,_,Taxy,Taxinc,Tax);
    s1_a_2(Taxp,Taxy,Taxinc,Tax).

%There is hereby imposed on the taxable income of-

%(1) every married individual (as defined in section 7703) who makes a single return jointly with his spouse, and
s1_a_1(Taxp,S4,Spouse,Taxy,Taxinc,Tax) :-
    s7703(Taxp,Spouse,_,Taxy),
    joint_return_(S4),
    agent_(S4,span(Taxp,_,_)),
    agent_(S4,span(Spouse,_,_)),
    first_day_year(Taxy,First_day),
    last_day_year(Taxy,Last_day),
    start_(S4,span(Day_return,_,_)),
    is_before(First_day,Day_return),
    is_before(Day_return,Last_day),
    \+ ( % nonresident aliens can't file jointly
        nonresident_alien_(Someone_is_nra),
        (
            agent_(Someone_is_nra,span(Taxp,_,_));
            agent_(Someone_is_nra,span(Spouse,_,_))
        ),
        (
            (
                \+ start_(Someone_is_nra,_),
                Start_time=First_day
            );
            start_(Someone_is_nra,span(Start_time,_,_))
        ),
        (
            (
                \+ end_(Someone_is_nra,_),
                End_time=Last_day
            );
            end_(Someone_is_nra,span(End_time,_,_))
        ),
        is_before(Start_time,Last_day),
        is_before(First_day,End_time)
    ),
    s63(Taxp,Taxy,Taxinc),
    s1_a_tax(Taxinc,Tax).

%(2) every surviving spouse (as defined in section 2(a)),
s1_a_2(Taxp,Taxy,Taxinc,Tax) :-
    s2_a(Taxp,_,Taxy),
    s63(Taxp,Taxy,Taxinc),
    s1_a_tax(Taxinc,Tax).

%Such tax shall be:
s1_a_tax(Taxinc,Tax) :-
    s1_a_i(Taxinc,Tax);
    s1_a_ii(Taxinc,Tax);
    s1_a_iii(Taxinc,Tax);
    s1_a_iv(Taxinc,Tax);
    s1_a_v(Taxinc,Tax).

%(i) 15% of taxable income if the taxable income is not over $36,900;
s1_a_i(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 36900,
    Tmp is Taxinc*0.15,
    rounding(Tmp, Tax).
%(ii) $5,535, plus 28% of the excess over $36,900 if the taxable income is over $36,900 but not over $89,150;
s1_a_ii(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 89150,
    36900 < Taxinc,
    Tmp is 5535+(Taxinc-36900)*0.28,
    rounding(Tmp, Tax).
%(iii) $20,165, plus 31% of the excess over $89,150 if the taxable income is over $89,150 but not over $140,000;
s1_a_iii(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 140000,
    89150 < Taxinc,
    Tmp is 20165+(Taxinc-89150)*0.31,
    rounding(Tmp, Tax).
%(iv) $35,928.50, plus 36% of the excess over $140,000 if the taxable income is over $140,000 but not over $250,000;
s1_a_iv(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 250000,
    140000 < Taxinc,
    Tmp is 35928.50+(Taxinc-140000)*0.36,
    rounding(Tmp, Tax).
%(v) $75,528.50, plus 39.6% of the excess over $250,000 if the taxable income is over $250,000.
s1_a_v(Taxinc,Tax) :-
    number(Taxinc),
    250000 < Taxinc,
    Tmp is 75528.50+(Taxinc-250000)*0.396,
    rounding(Tmp, Tax).

%(b) Heads of households

%There is hereby imposed on the taxable income of every head of a household (as defined in section 2(b)) a tax determined in accordance with the following:
s1_b(Taxp,Taxy,Taxinc,Tax) :-
    s2_b(Taxp,_,Taxy),
    s63(Taxp,Taxy,Taxinc),
    (
        s1_b_i(Taxinc,Tax);
        s1_b_ii(Taxinc,Tax);
        s1_b_iii(Taxinc,Tax);
        s1_b_iv(Taxinc,Tax);
        s1_b_v(Taxinc,Tax)
    ).

%(i) 15% of taxable income if the taxable income is not over $29,600;
s1_b_i(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 29600,
    Tmp is Taxinc*0.15,
    rounding(Tmp, Tax).
%(ii) $4,440, plus 28% of the excess over $29,600 if the taxable income is over $29,600 but not over $76,400;
s1_b_ii(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 76400,
    29600 < Taxinc,
    Tmp is 4440+(Taxinc-29600)*0.28,
    rounding(Tmp, Tax).
%(iii) $17,544, plus 31% of the excess over $76,400 if the taxable income is over $76,400 but not over $127,500;
s1_b_iii(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 127500,
    76400 < Taxinc,
    Tmp is 17544+(Taxinc-76400)*0.31,
    rounding(Tmp, Tax).
%(iv) $33,385, plus 36% of the excess over $127,500 if the taxable income is over $127,500 but not over $250,000;
s1_b_iv(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 250000,
    127500 < Taxinc,
    Tmp is 33385+(Taxinc-127500)*0.36,
    rounding(Tmp, Tax).
%(v) $77,485, plus 39.6% of the excess over $250,000 if the taxable income is over $250,000.
s1_b_v(Taxinc,Tax) :-
    number(Taxinc),
    250000 < Taxinc,
    Tmp is 77485+(Taxinc-250000)*0.396,
    rounding(Tmp, Tax).

%(c) Unmarried individuals (other than surviving spouses and heads of households)

%There is hereby imposed on the taxable income of every individual (other than a surviving spouse as defined in section 2(a) or the head of a household as defined in section 2(b)) who is not a married individual (as defined in section 7703) a tax determined in accordance with the following:
s1_c(Taxp,Taxy,Taxinc,Tax) :-
    \+ s2_a(Taxp,_,Taxy),
    \+ s2_b(Taxp,_,Taxy),
    \+ s7703(Taxp,_,_,Taxy),
    s63(Taxp,Taxy,Taxinc),
    (
        s1_c_i(Taxinc,Tax);
        s1_c_ii(Taxinc,Tax);
        s1_c_iii(Taxinc,Tax);
        s1_c_iv(Taxinc,Tax);
        s1_c_v(Taxinc,Tax)
    ).

%(i) 15% of taxable income if the taxable income is not over $22,100;
s1_c_i(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 22100,
    Tmp is Taxinc*0.15,
    rounding(Tmp, Tax).
%(ii) $3,315, plus 28% of the excess over $22,100 if the taxable income is over $22,100 but not over $53,500;
s1_c_ii(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 53500,
    22100 < Taxinc,
    Tmp is 3315+(Taxinc-22100)*0.28,
    rounding(Tmp, Tax).
%(iii) $12,107, plus 31% of the excess over $53,500 if the taxable income is over $53,500 but not over $115,000;
s1_c_iii(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 115000,
    53500 < Taxinc,
    Tmp is 12107+(Taxinc-53500)*0.31,
    rounding(Tmp, Tax).
%(iv) $31,172, plus 36% of the excess over $115,000 if the taxable income is over $115,000 but not over $250,000;
s1_c_iv(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 250000,
    115000 < Taxinc,
    Tmp is 31172+(Taxinc-115000)*0.36,
    rounding(Tmp, Tax).
%(v) $79,772, plus 39.6% of the excess over $250,000 if the taxable income is over $250,000.
s1_c_v(Taxinc,Tax) :-
    number(Taxinc),
    250000 < Taxinc,
    Tmp is 79772+(Taxinc-250000)*0.396,
    rounding(Tmp, Tax).

%(d) Married individuals filing separate returns

%There is hereby imposed on the taxable income of every married individual (as defined in section 7703) who does not make a single return jointly with his spouse, a tax determined in accordance with the following:
s1_d(Taxp,Spouse,Taxy,Taxinc,Tax) :-
    s7703(Taxp,Spouse,_,Taxy),
    \+ (
        joint_return_(Joint_return),
        agent_(Joint_return,span(Taxp,_,_)),
        agent_(Joint_return,span(Spouse,_,_)),
        first_day_year(Taxy,First_day),
        last_day_year(Taxy,Last_day),
        start_(Joint_return,span(Day_return,_,_)),
        is_before(First_day,Day_return),
        is_before(Day_return,Last_day)
    ),
    s63(Taxp,Taxy,Taxinc),
    (
        s1_d_i(Taxinc,Tax);
        s1_d_ii(Taxinc,Tax);
        s1_d_iii(Taxinc,Tax);
        s1_d_iv(Taxinc,Tax);
        s1_d_v(Taxinc,Tax)
    ).

%(i) 15% of taxable income if the taxable income is not over $18,450;
s1_d_i(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 18450,
    Tmp is Taxinc*0.15,
    rounding(Tmp, Tax).
%(ii) $2,767.50, plus 28% of the excess over $18,450 if the taxable income is over $18,450 but not over $44,575;
s1_d_ii(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 44575,
    18450 < Taxinc,
    Tmp is 2767.50+(Taxinc-18450)*0.28,
    rounding(Tmp, Tax).
%(iii) $10,082.50, plus 31% of the excess over $44,575 if the taxable income is over $44,575 but not over $70,000;
s1_d_iii(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 70000,
    44575 < Taxinc,
    Tmp is 10082.50+(Taxinc-44575)*0.31,
    rounding(Tmp, Tax).
%(iv) $17,964.25, plus 36% of the excess over $70,000 if the taxable income is over $70,000 but not over $125,000;
s1_d_iv(Taxinc,Tax) :-
    number(Taxinc),
    Taxinc =< 125000,
    70000 < Taxinc,
    Tmp is 17964.25+(Taxinc-70000)*0.36,
    rounding(Tmp, Tax).
%(v) $37,764.25, plus 39.6% of the excess over $125,000 if the taxable income is over $125,000
s1_d_v(Taxinc,Tax) :-
    number(Taxinc),
    125000 < Taxinc,
    Tmp is 37764.25+(Taxinc-125000)*0.396,
    rounding(Tmp, Tax).
