%S7703. Determination of marital status
s7703(Taxp,Spouse,Marriage,Taxy) :-
    (
        nonvar(Taxp);
        nonvar(Spouse)
    ),
    \+ double_equal(Taxp, Spouse),
	s7703_a(Taxp,Spouse,Marriage,Taxy),
	\+ s7703_b(Taxp,Spouse,Taxy).

%(a) General rule
s7703_a(Taxp,Spouse,Marriage,Taxy) :-
	s7703_a_1(Taxp,Spouse,Marriage,_,Taxy),
	\+ s7703_a_2(Taxp,Spouse,Marriage,_,Taxy).

%(1) the determination of whether an individual is married shall be made as of the close of his taxable year; except that if his spouse dies during his taxable year such determination shall be made as of the time of such death; and
spouse_died(Spouse_dies, Spouse) :-
    death_(Spouse_dies),
    agent_(Spouse_dies,span(Spouse,_,_)).

spouse_died_during_taxable_year(Spouse, S13B, First_day_year, Last_day_year) :-
    death_(Death_spouse),
    agent_(Death_spouse,span(Spouse,_,_)),
    start_(Death_spouse,span(S13B,_,_)),
    is_before(First_day_year,S13B),
    is_before(S13B,Last_day_year).

s7703_a_1(Taxp,Spouse,Marriage,S13B,Taxy) :-
	% useful constants
	last_day_year(Taxy,Last_day_year),
	first_day_year(Taxy,First_day_year),
    number(Taxy),
	Taxy1 is Taxy+1,
	first_day_year(Taxy1,First_day_next_year),
	% main body
	marriage_(Marriage),
	agent_(Marriage,span(Taxp,_,_)),
	agent_(Marriage,span(Spouse,_,_)),
	\+ double_equal(Taxp,Spouse),
    (
        (
            \+ start_(Marriage,_),
            Start_marriage = First_day_year
        );
        (
            start_(Marriage,span(Start_marriage,_,_))
        )
    ),
    is_before(Start_marriage,Last_day_year),
	( % if spouse died during taxable year
		(
            spouse_died_during_taxable_year(Spouse, S13B, First_day_year, Last_day_year),
            ( % such determination shall be made as of the time of such death
                is_before(Start_marriage,S13B),
                (
                    ( % marriage was still ongoing at death
                        \+ end_(Marriage,_)
                    );
                    ( % or ended with death
                        end_(Marriage,span(End_time,_,_)),
                        is_before(S13B,End_time)
                    )
                )
            )
		);
		( % otherwise, default behavior: check at end of year
            \+ spouse_died_during_taxable_year(Spouse, S13B, First_day_year, Last_day_year),
            ( % determining the end date of a marriage:
                ( % if no end date,
                    \+ end_(Marriage,_),
                    (
                        ( % if spouse died, take death date as end time
                            spouse_died(Spouse_dies, Spouse),
                            start_(Spouse_dies,span(End_time,_,_)),
                            is_before(First_day_next_year,End_time)
                        );
                        % else marriage hasn't ended
                        \+ spouse_died(_, Spouse)
                    )
                );
                ( % else take end date
                    end_(Marriage,span(End_time,_,_)),
                    is_before(First_day_next_year,End_time)
                )
            )
		)
	).

%(2) an individual legally separated from his spouse under a decree of divorce or of separate maintenance shall not be considered as married.
s7703_a_2(Taxp,Spouse,Marriage,S19,Taxy) :-
    marriage_(Marriage),
    agent_(Marriage,span(Taxp,_,_)),
    agent_(Marriage,span(Spouse,_,_)),
    \+ double_equal(Taxp,Spouse),
	legal_separation_(S19),
	patient_(S19,Marriage),
	(
		agent_(S19,span("decree of divorce",_,_));
		agent_(S19,span("decree of separate maintenance",_,_))
	),
	start_(S19,span(Divorce_time,_,_)),
	last_day_year(Taxy,Last_day_year),
	is_before(Divorce_time,Last_day_year).

%(b) Certain married individuals living apart

%For purposes of those provisions of this title which refer to this subsection, if-
s7703_b(Taxp,Spouse,Taxy) :-
	s7703_b_1(Taxp,Household,_,Taxy), 
	s7703_b_2(Taxp,Household,_,Taxy),
	s7703_b_3(Taxp,Spouse,Household,Taxy).


%(1) an individual who is married (within the meaning of subsection (a)) and who files a separate return maintains as his home a household which constitutes for more than one-half of the taxable year the principal place of abode of a child with respect to whom such individual is entitled to a deduction for the taxable year under section 151,
s7703_b_1(Taxp,Household,Dependent,Taxy) :-
	first_day_year(Taxy,First_day_year),
	last_day_year(Taxy,Last_day_year),
	\+ (
		joint_return_(Joint_return),
		agent_(Joint_return,span(Taxp,_,_)),
        start_(Joint_return,span(Day_return,_,_)),
        is_before(First_day_year,Day_return),
        is_before(Day_return,Last_day_year)
	),
	residence_(Taxp_residence),
	agent_(Taxp_residence,span(Taxp,_,_)),
	patient_(Taxp_residence,span(Household,_,_)),
	residence_(Child_lives_at_home),
	agent_(Child_lives_at_home,span(Dependent,_,_)),
	patient_(Child_lives_at_home,span(Household,_,_)),
	start_(Child_lives_at_home,span(Start_time,_,_)),
    latest([Start_time,First_day_year],Start),
    (
        (
            \+ end_(Child_lives_at_home,_)
        );
        end_(Child_lives_at_home,span(End_time,_,_))
    ),
    earliest([End_time,Last_day_year],End),
	% now compute time stamp of end minus time stamp of beginning and compare with time stamps of 1/2 of the year 0.
    duration(Start,End,Duration),
    duration(First_day_year,Last_day_year,Taxy_duration),
    number(Taxy_duration),
    Half_year_duration is Taxy_duration / 2,
    number(Duration),
    number(Half_year_duration),
	Duration >= Half_year_duration,
    s152_a_1(Dependent,Taxp,Taxy).

%(2) such individual furnishes over one-half of the cost of maintaining such household during the taxable year, and
s7703_b_2(Taxp,Household,Cost,Taxy) :-
    findall(
		Payment_amount,
		(
			payment_(Payment),
			residence_(Residence),
			agent_(Payment,span(Taxp,_,_)),
			patient_(Residence,span(Household,_,_)),
			(
                purpose_(Payment,Residence);
                purpose_(Payment,span(Household,_,_))
            ),
			amount_(Payment,span(Payment_amount,_,_)),
			start_(Payment,span(Payment_time,_,_)), % assuming it's a single day
            year_from_date(Payment_time, Taxy_payment_int),
			double_equal(Taxy,Taxy_payment_int)
		),
		Payments_by_individual
	),
	findall(
		Payment_amount,
		(
			payment_(Payment),
			residence_(Residence),
			patient_(Residence,span(Household,_,_)),
			(
                purpose_(Payment,Residence);
                purpose_(Payment,span(Household,_,_))
            ),
			amount_(Payment,span(Payment_amount,_,_)),
			start_(Payment,span(Payment_time,_,_)), % assuming it's a single day
            year_from_date(Payment_time, Taxy_payment_int),
			double_equal(Taxy,Taxy_payment_int)
		),
		Payments_all
	),
	sum_list(Payments_by_individual,Payment_by_individual),
	sum_list(Payments_all,Cost),
    number(Cost),
	Cost>0,
    number(Payment_by_individual),
    number(Cost),
	Ratio is Payment_by_individual / Cost,
    number(Ratio),
	Ratio>=0.5.

%(3) during the last 6 months of the taxable year, such individual's spouse is not a member of such household,
s7703_b_3_is_member_of_household(Spouse,Household,Day) :-
    residence_(Spouse_lives_in_household),
    agent_(Spouse_lives_in_household,span(Spouse,_,_)),
	patient_(Spouse_lives_in_household,span(Household,_,_)),
    start_(Spouse_lives_in_household,span(Time_start,_,_)),
    is_before(Time_start,Day),
	(
		(
			\+ end_(Spouse_lives_in_household,_)
		);
		(
			end_(Spouse_lives_in_household,span(Time_end,_,_)),
			is_before(Day,Time_end)
		)
	).
    
s7703_b_3(Taxp,Spouse,Household,Taxy) :-
    s7703_a(Taxp,Spouse,_,Taxy),
    findall(
        Date,
        (
            between(7,12,Month),
            between(1,31,Day),
            number(Month),
            number(Day),
            Daymonth is Month*100 + Day,
            \+ member(Daymonth, [931, 1131]),
            number(Taxy),
            Date is Taxy*10000 + Month*100 + Day,
            s7703_b_3_is_member_of_household(Spouse,Household,Date)
        ),
        Days_membership
    ),
    length(Days_membership,Num_days),
    double_equal(Num_days,0).

%such individual shall not be considered as married.
