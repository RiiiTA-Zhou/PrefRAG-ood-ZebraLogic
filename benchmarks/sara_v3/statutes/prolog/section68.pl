%S68. Overall limitation on itemized deductions
s68(Taxp,Amount_deductions_in,Amount_deductions_out,Taxy) :-
    number(Amount_deductions_in),
    (
        (
            s68_f(Taxy),
            Amount_deductions_out is Amount_deductions_in
        );
        (
            \+ s68_f(Taxy),
            (
                s68_a(Taxp,_,_,Amount_deductions_in,Reduction,Taxy),
                number(Reduction),
                Amount_deductions_out is Amount_deductions_in-Reduction
            );
            (
                \+ s68_a(Taxp,_,_,Amount_deductions_in,_,Taxy),
                Amount_deductions_out is Amount_deductions_in
            )
        )
    ).

%(a) General rule

%In the case of an individual whose adjusted gross income exceeds the applicable amount, the amount of the itemized deductions otherwise allowable for the taxable year shall be reduced by the lesser of-
s68_a(Taxp,Agi,Aa,Itemded,S7,Taxy) :-
    gross_income(Taxp,Taxy,Agi),
    s68_b(Taxp,Aa,Taxy),
    number(Agi),
    number(Aa),
    Agi>Aa,
    s68_a_1(Agi,Aa,Reduction1),
    s68_a_2(Taxp,Itemded,Reduction2,Taxy),
    number(Reduction1),
    number(Reduction2),
    S7 is min(Reduction1,Reduction2).

%(1) 3 percent of the excess of adjusted gross income over the applicable amount, or
s68_a_1(Agi,Aa,S9B) :-
    number(Agi),
    number(Aa),
    X is 3*(Agi-Aa),
    number(X),
    Tmp is X / 100,
    rounding(Tmp, S9B).

%(2) 80 percent of the amount of the itemized deductions otherwise allowable for such taxable year.
s68_a_2(Taxp,Itemded,S14,Taxy) :-
    s63_d(Taxp,_,Itemded,Taxy),
    number(Itemded),
    X is 80*Itemded,
    number(X),
    Tmp is X / 100,
    rounding(Tmp, S14).

%(b) Applicable amount
s68_b(Taxp,Aa,Taxy) :-
    (
        s68_b_1_A(Taxp,_,_,Aa,Taxy),
        !
    );
    (
        s68_b_1_B(Taxp,Aa,Taxy),
        !
    );
    (
        s68_b_1_C(Taxp,Aa,Taxy),
        !
    );
    (
        s68_b_1_D(Taxp,Aa,Taxy),
        !
    ).

%(1) In general

%For purposes of this section, the term "applicable amount" means-
amount("A",Amount) :-
    Amount is 300000.
amount("B",Amount) :-
    Amount is 275000.
amount("C",Amount) :-
    Amount is 250000.
amount("D",Amount) :-
    amount("A",Amount_A),
    number(Amount_A),
    Tmp is Amount_A/2,
    rounding(Tmp, Amount).

%(A) $300,000 in the case of a joint return or a surviving spouse (as defined in section 2(a)),
s68_b_1_A(Taxp,Joint_return,Surviving_spouse,Aa,Taxy) :-
    (
        (
            s7703(Taxp,Spouse,_,Taxy),
            joint_return_(Joint_return),
            agent_(Joint_return,span(Taxp,_,_)),
            agent_(Joint_return,span(Spouse,_,_)),
            first_day_year(Taxy,First_day_year),
            last_day_year(Taxy,Last_day_year),
            start_(Joint_return,span(Day_return,_,_)),
            is_before(First_day_year,Day_return),
            is_before(Day_return,Last_day_year)
        );
        s2_a(Surviving_spouse,_,Taxy)
    ),
    amount("A",Aa).

%(B) $275,000 in the case of a head of household (as defined in section 2(b)),
s68_b_1_B(Taxp,Aa,Taxy) :-
    s2_b(Taxp,_,Taxy),
    amount("B",Aa).

%(C) $250,000 in the case of an individual who is not married and who is not a surviving spouse or head of household, and
s68_b_1_C(Taxp,Aa,Taxy) :-
    \+ s7703(Taxp,_,_,Taxy),
    \+ s2_a(Taxp,_,Taxy), 
    \+ s2_b(Taxp,_,Taxy),
    amount("C",Aa).

%(D) 1/2 the amount applicable under subparagraph (A) in the case of a married individual filing a separate return.
s68_b_1_D(Taxp,Aa,Taxy) :-
    s7703(Taxp,Spouse,_,Taxy),
    \+ (
        joint_return_(Joint_return),
        agent_(Joint_return,span(Taxp,_,_)),
        agent_(Joint_return,span(Spouse,_,_)),
        first_day_year(Taxy,First_day_year),
        start_(Joint_return,span(First_day_year,_,_)),
        last_day_year(Taxy,Last_day_year),
        end_(Joint_return,span(Last_day_year,_,_))
    ),
    amount("D",Aa).

%For purposes of this paragraph, marital status shall be determined under section 7703.

%(f) Section not to apply

%This section shall not apply to any taxable year beginning after December 31, 2017, and before January 1, 2026.
s68_f(Taxy) :-
    between(2018,2025,Taxy).
