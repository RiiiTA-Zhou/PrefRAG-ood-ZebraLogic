% time
day_from_date(Date, Day) :-
    integer(Date),
    Day is Date mod 100.

month_from_date(Date, Month) :-
    integer(Date),
    D1 is Date // 100,
    integer(D1),
    Month is D1 mod 100.

year_from_date(Date, Year) :-
    integer(Date),
    Year is Date // 10000.

day_of_week(Date, Weekday) :- % computes the weekday by Sakamoto's method. Only valid for Year > 1752.
    % 0 = Sunday, 1 = Monday etc
    day_from_date(Date, Day),
    month_from_date(Date, Month),
    year_from_date(Date, Year),
    integer(Month),
    (
        (
            Month<3,
            integer(Year),
            Y is Year-1
        );
        (
            Month >=3,
            Y is Year
        )
    ),
    nth1(Month, [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4], T),
    integer(Y),
    integer(T),
    integer(Day),
    Weekday is (Y + Y//4 - Y//100 + Y//400 + T + Day) mod 7.

is_leap_year(Year) :-
    integer(Year),
    M4 is Year mod 4,
    M100 is Year mod 100,
    M400 is Year mod 400,
    integer(M4),
    integer(M100),
    integer(M400),
    (
        (
            M4 = 0,
            M100 > 0,
            M400 > 0
        );
        (
            M4 = 0,
            M100 > 0,
            M400 = 0
        );
        (
            M4 = 0,
            M100 = 0,
            M400 = 0
        )
    ).

ordinal_date(Date, Ordinal) :- % compute the index of Date in its year
    day_from_date(Date, Day),
    month_from_date(Date, Month),
    year_from_date(Date, Year),
    (
        (
            is_leap_year(Year),
            Leap is 1
        );
        (
            \+ is_leap_year(Year),
            Leap is 0
        )
    ),
    integer(Month),
    integer(Day),
    (
        (
            Month < 3,
            Ordinal is Day + 31*(Month-1)
        );
        (
            Month >= 3,
            Ordinal is Day + 59 + Leap + (153 * (Month - 3) + 2)//5
        )
    ).
    
iso_week_date(Date, Iso_week_date) :- % compute the index of the week in the year of Date
    ordinal_date(Date, Doy),
    day_of_week(Date, Weekday),
    integer(Weekday),
    Dow is Weekday + 1,
    integer(Doy),
    integer(Dow),
    Iso_week_date is (10 + Doy - Dow)//7.

is_before(Day1,Day2) :- % Is true if Day2 occurs after Day1. Arguments are input as integers in format YYYYMMDD.
    integer(Day1), integer(Day2),
    Day1=<Day2.

last_day_year(Year, Day) :-
    integer(Year),
    Day is Year*10000+1231.

first_day_year(Year, Day) :-
    integer(Year),
    Day is Year*10000+0101.

% out of days in format YYYYMMDD, extract latest day
latest([],_). % just leave the output unbound

latest([Day|Days],Output) :- 
    (
        nonvar(Day),
        latest(Days,Day,Output)
);
(
        var(Day),
        latest(Days,Output)
    ).

latest([],Output,Output).

latest([Day|Days],Latest,Output) :-
    (
        nonvar(Day),
        (
            (
                is_before(Day,Latest),
                latest(Days,Latest,Output)
            );
            (
                \+ is_before(Day,Latest),
                latest(Days,Day,Output)
            )
        )
    );
    (
        var(Day),
        latest(Days,Latest,Output)
    ).

% out of days in format YYYYMMDD, extract earliest date
earliest([],_). % just leave the output unbound

earliest([Day|Days],Output) :- 
    (
        nonvar(Day),
        earliest(Days,Day,Output)
    );
    (
        var(Day),
        earliest(Days,Output)
    ).

earliest([],Output,Output).

earliest([Day|Days],Earliest,Output) :-
    (
        nonvar(Day),
        (
            (
                is_before(Earliest,Day),
                earliest(Days,Earliest,Output)
            );
            (
                \+ is_before(Earliest,Day),
                earliest(Days,Day,Output)
            )
        )
    );
    (
        var(Day),
        earliest(Days,Earliest,Output)
    ).

duration(Date1,Date2,Duration) :- % duration in arbitrary units for days in YYYY-MM-DD format
    year_from_date(Date1,Year1),
    year_from_date(Date2,Year2),
    month_from_date(Date1,Month1),
    month_from_date(Date2,Month2),
    day_from_date(Date1,Day1),
    day_from_date(Date2,Day2),
    integer(Year1),
    integer(Year2),
    integer(Month1),
    integer(Month2),
    integer(Day1),
    integer(Day2),
    Duration is (Year2-Year1)*365.25 + (Month2-Month1)*365.25/12 + Day2-Day1.

% kinship
is_child_of(X,Y,Day_start,Day_end) :- % X is the child of Y from Day_start to Day_end if...
	( % what kind of relationship exists between X and Y
		( % X is child of Y, or
			(
                son_(Relationship);
                daughter_(Relationship)
			),
			agent_(Relationship,span(X,_,_)),
			patient_(Relationship,span(Y,_,_))
		);
		( % Y is parent of X
			(
				father_(Relationship);
                mother_(Relationship)
			),
			agent_(Relationship,span(Y,_,_)),
			patient_(Relationship,span(X,_,_))
		)
	),
    \+ double_equal(X, Y),
	(
        (
            \+ start_(Relationship,_)
        );
        start_(Relationship,span(Day_start,_,_))
    ),
	(
		( % if no end to Relationship then it's still ongoing
			\+ end_(Relationship,_)
		);
        end_(Relationship,span(Day_end,_,_))
	).

is_sibling_of(X,Y,Day_start,Day_end) :- % X is the sibling of Y on from Day_start to Day_end if...
	( % there is a brother or sister relationship
		brother_(Relationship);
		sister_(Relationship)
	),
	( % X is somehow involved in it
		agent_(Relationship,span(X,_,_));
		patient_(Relationship,span(X,_,_))
	),
	( % and so is Y
		agent_(Relationship,span(Y,_,_));
		patient_(Relationship,span(Y,_,_))
	),
    \+ double_equal(X, Y),
	(
        (
            \+ start_(Relationship,_)
        );
        start_(Relationship,span(Day_start,_,_))
    ),
	(
		( % if no end to Relationship then it's still ongoing
			\+ end_(Relationship,_)
		);
        end_(Relationship,span(Day_end,_,_))
	).

is_descendent_of(X,Y,Day_start,Day_end) :- % X is a descendent of Y if
	( % as a base case, X is a descendent of Y if X is a child of Y
		is_child_of(X,Y,Day_start,Day_end)
	);
	( % else
		is_child_of(Z,Y,_,_), % Z is a child of Y and
		is_descendent_of(X,Z,Day_start,Day_end) % X is a descendent of Z
	).

is_stepsibling_of(X,Y,Day_start,Day_end) :- % X is stepsibling of Y if
	is_child_of(Y,ParentY,Day_start_x,Day_end_x), % one of the parents of Y
	is_child_of(X,ParentX,Day_start_y,Day_end_y), % and one of the parents of X
	marriage_(Marriage), % got married
	agent_(Marriage,span(ParentY,_,_)),
	agent_(Marriage,span(ParentX,_,_)),
    \+ double_equal(X, Y),
    (
        (
            \+ start_(Marriage,_)
        );
        start_(Marriage,span(Start_time,_,_))
    ),
    latest([Day_start_x,Day_start_y,Start_time], Day_start),
	(
		(
			\+ end_(Marriage,_)
		);
        end_(Marriage,span(End_time,_,_))
	),
    earliest([Day_end_x,Day_end_y,End_time],Day_end).

is_sibling_in_law_of(X,Y,Day_start,Day_end) :- % symmetry of relationship
    is_sibling_in_law_of_aux(X,Y,Day_start,Day_end);
    is_sibling_in_law_of_aux(Y,X,Day_start,Day_end).

is_sibling_in_law_of_aux(X,Y,Day_start,Day_end) :- % X is sibling in law of Y if
	is_sibling_of(Y,SiblingY,Day_start_y,Day_end_y), % one of Y's siblings
	marriage_(Marriage), % and X got married
	agent_(Marriage,span(SiblingY,_,_)),
	agent_(Marriage,span(X,_,_)),
    \+ double_equal(X, Y),
    (
        (
            \+ start_(Marriage,_)
        );
        start_(Marriage,span(Start_time,_,_))
    ),
    latest([Start_time,Day_start_y],Day_start),
	(
		(
			\+ end_(Marriage,_)
		);
        end_(Marriage,span(End_time,_,_))
	),
    earliest([End_time,Day_end_y],Day_end).

is_child_in_law_of(X,Y,Day_start,Day_end) :- % X is child in law of Y if
	is_child_of(ChildY,Y,Day_start_y,Day_end_y), % one of the children of Y
	marriage_(Marriage), % got married with X
	agent_(Marriage,span(ChildY,_,_)),
	agent_(Marriage,span(X,_,_)),
    \+ double_equal(X, Y),
    (
        (
            \+ start_(Marriage,_)
        );
        start_(Marriage,span(Start_time,_,_))
    ),
    latest([Start_time,Day_start_y],Day_start),
	(
		(
			\+ end_(Marriage,_)
		);
        end_(Marriage,span(End_time,_,_))
	),
    earliest([End_time,Day_end_y],Day_end).

is_parent_in_law_of(X,Y,Day_start,Day_end) :- % X is parent in law of Y if
	is_child_of(Y,ParentY,Day_start_y,Day_end_y), % one of the parents of Y
	marriage_(Marriage), % got married with X
	agent_(Marriage,span(ParentY,_,_)),
	agent_(Marriage,span(X,_,_)),
    \+ double_equal(X, Y),
    (
        (
            \+ start_(Marriage,_)
        );
        start_(Marriage,span(Start_time,_,_))
    ),
    latest([Start_time,Day_start_y],Day_start),
	(
		(
			\+ end_(Marriage,_)
		);
        end_(Marriage,span(End_time,_,_))
	),
    earliest([End_time,Day_end_y],Day_end).

is_stepparent_of(X,Y,Day_start,Day_end) :- % X is parent in law of Y if
	is_child_of(Y,ParentY,Day_start_y,Day_end_y), % one of the parents of Y
	marriage_(Marriage), % got married with X
	agent_(Marriage,span(ParentY,_,_)),
	agent_(Marriage,span(X,_,_)),
	start_(Marriage,span(Start_time,_,_)), % and their marriage holds on Day
    latest([Start_time,Day_start_y],Day_start),
    \+ double_equal(X, Y),
	(
		(
			\+ end_(Marriage,_)
		);
        end_(Marriage,span(End_time,_,_))
	),
    earliest([End_time,Day_end_y],Day_end).

% aggregation of income
gross_income(Person,Year,Gross_income) :-
	first_day_year(Year,First_day_year),
    last_day_year(Year,Last_day_year),
    (
        ( % if the individual is filing a joint return with his spouse, sum both incomes
            s7703(Person,Spouse,_,Year),
            joint_return_(Joint_return),
            agent_(Joint_return,span(Person,_,_)),
            agent_(Joint_return,span(Spouse,_,_)),
            start_(Joint_return,span(Day_return,_,_)),
            is_before(First_day_year,Day_return),
            is_before(Day_return,Last_day_year),
            gross_income_individual(Person,Year,Income_individual),
            gross_income_individual(Spouse,Year,Income_spouse),
            number(Income_individual),
            number(Income_spouse),
            Gross_income is Income_individual+Income_spouse
        );
        ( % otherwise, it's just the individual's income
            \+ (
                s7703(Person,Spouse,_,Year),
                joint_return_(Joint_return),
                agent_(Joint_return,span(Person,_,_)),
                agent_(Joint_return,span(Spouse,_,_)),
                start_(Joint_return,span(Day_return,_,_)),
                is_before(First_day_year,Day_return),
                is_before(Day_return,Last_day_year)
            ),
            gross_income_individual(Person,Year,Gross_income)
        )
    ).

gross_income_individual(Person,Year,Gross_income) :-
    first_day_year(Year,First_day_year),
    last_day_year(Year,Last_day_year),
    findall(
        Amount,
        (
            income_(Income),
            agent_(Income,span(Person,_,_)),
            amount_(Income,span(Amount,_,_)),
            start_(Income,span(Start_time,_,_)),
            is_before(First_day_year,Start_time),
            is_before(Start_time,Last_day_year)
        ),
        Income_amounts
    ),
    findall(
        Amount,
        (
            payment_(Payment),
            patient_(Payment,span(Person,_,_)),
            amount_(Payment,span(Amount,_,_)),
            start_(Payment,span(Start_time,_,_)),
            is_before(First_day_year,Start_time),
            is_before(Start_time,Last_day_year)
        ),
        Payment_amounts
    ),
    sum_list(Income_amounts,Income),
    sum_list(Payment_amounts,Payment),
    number(Income),
    number(Payment),
    Gross_income is Income+Payment.

% compute tax owed by a person for a given taxable year
tax(Taxp,Taxy,Tax) :-
    (
        s1(Taxp,Taxy,_,Income_tax);
        (
            \+ s1(Taxp,Taxy,_,_),
            Income_tax is 0
        )
    ),
    (
        s3301(Taxp,Taxy,_,_,_,Employment_tax);
        (
            \+ s3301(Taxp,Taxy,_,_,_,_),
            Employment_tax is 0
        )
    ),
    number(Income_tax),
    number(Employment_tax),
    Tax is Income_tax+Employment_tax.

% this is meant to emulate '==' although it is not strictly equivalent
double_equal(X, Y) :-
    nonvar(X),
    nonvar(Y),
    X=Y.

is_prefix(Prefix, Whole) :-
    nonvar(Prefix),
    nonvar(Whole),
    is_prefix_term(Prefix, Whole).

is_suffix(Suffix, Whole) :-
    nonvar(Suffix),
    nonvar(Whole),
    is_suffix_term(Suffix, Whole).

rounding(In, Out) :-
    number(In),
    F is float_fractional_part(In),
    number(F),
    (
        (
            F<0.5,
            Out is integer(float_integer_part(In))
        );
        (
            F>=0.5,
            Out is integer(float_integer_part(In+1))
        )
    ).

is_prefix_term(Prefix, Whole) :-
    string_chars(Whole, Lwhole),
    string_chars(Prefix, Lprefix),
    append(Lprefix, _, Lwhole).

is_suffix_term(Suffix, Whole) :-
    string_chars(Whole, Lwhole),
    string_chars(Suffix, Lsuffix),
    append(_, Lsuffix, Lwhole).

% this is only for use in tax_case_33 and is a shortcut to avoid writing out
% a lot of code to represent the facts
split_event_name(In_term, Out_X, Out_Y, Out_Z) :-
    % the input is an atom of the form
    % '<X>_<Y>_<Z>' and we want to return X, Y, Z as terms
    nonvar(In_term),
    split_string(In_term,"_","", [Out_X, Out_Y, Out_Z]).
