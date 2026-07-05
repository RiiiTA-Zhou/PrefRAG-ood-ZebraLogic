%S3306. Definitions

%(a) Employer
s3306_a(Employer,Caly) :-
    (
        s3306_a_1(Employer,Caly);
        s3306_a_2(Employer,Caly);
        s3306_a_3(Employer,_,_,Caly)
    ).

%(1) In general

%The term "employer" means, with respect to any calendar year, any person who-
s3306_a_1(Employer,Caly) :-
    s3306_a_1_A(Employer,Caly,_);
    s3306_a_1_B(Employer,_,_,Caly).

%(A) during the calendar year or the preceding calendar year paid wages of $1,500 or more, or
s3306_a_1_is_wages(Person, Year, Remuneration, Wages) :-
    s3306_b(Wages,Remuneration,Service,Person,_,_,_,_),
	start_(Remuneration,span(Time,_,_)),
    last_day_year(Year,Last_day_year),
    is_before(Time,Last_day_year),
    first_day_year(Year,First_day_year),
    is_before(First_day_year,Time),
    \+ purpose_(Service,span("agricultural labor",_,_)),
	\+ purpose_(Service,span("domestic service",_,_)).

s3306_a_1_A(Employee,Caly,Wages) :-
	findall(
		Amount,
		(
			s3306_a_1_is_wages(Employee, Caly, Remuneration, Amount);
			(
                number(Caly),
				Pyear is Caly-1,
				s3306_a_1_is_wages(Employee, Pyear, Remuneration, Amount)
			)
		),
		Wages_list
	),
	sum_list(Wages_list,Wages),
    number(Wages),
	Wages>=1500.

%(B) on each of some 10 days during the calendar year or during the preceding calendar year, each day being in a different calendar week, employed at least one individual in employment for some portion of the day.
s3306_a_1_is_day_of_employment(Person, Employee, Day) :-
	s3306_c(Service,Person,Employee,Day,_),
    \+ purpose_(Service,span("agricultural labor",_,_)),
    \+ purpose_(Service,span("domestic service",_,_)),
    \+ type_(Service,span("agricultural labor",_,_)),
    \+ type_(Service,span("domestic service",_,_)).

s3306_a_1_B(Employer,Workday,Employee,Caly) :-
    last_day_year(Caly,Last_day_year),
    number(Caly),
    Year1 is Caly-1,
    first_day_year(Year1,First_day_year1),
	findall(
		(Day,Individual),
		(
			s3306_a_1_is_day_of_employment(Employer,Individual,Day),
            is_before(First_day_year1,Day),
            is_before(Day,Last_day_year)
		),
		Day_individual
	),
    findall(
        Day,
        member((Day,_),Day_individual),
        Workday
    ),
    list_to_set(Workday,Emp_days_set),
	length(Emp_days_set,Num_days),
    number(Num_days),
	Num_days>=10,
    findall(
		Week,
		(
			member(Day,Workday),
            iso_week_date(Day, Week)
		),
		Weeks
	),
	list_to_set(Weeks,Weeks_set),
	length(Weeks_set,Num_weeks),
    number(Num_weeks),
	Num_weeks>=10,
    findall(
        Individual,
        member((_,Individual),Day_individual),
        Employee
    ).

%For purposes of this paragraph, there shall not be taken into account any wages paid to, or employment of, an employee performing domestic services referred to in paragraph (3).

%(2) Agricultural labor

%In the case of agricultural labor, the term "employer" means, with respect to any calendar year, any person who-
s3306_a_2(Employer,Caly) :-
    s3306_a_2_A(Employer,Caly,_,_);
    s3306_a_2_B(Employer,_,_,_,_,Caly).

%(A) during any calendar quarter in the calendar year or the preceding calendar year paid wages of $20,000 or more for agricultural labor, or
s3306_a_2_is_wages(Person, Year, Remuneration, Wages, Service) :- 
    s3306_b(Wages,Remuneration,Service,Person,_,_,_,_),
    start_(Remuneration,span(Time,_,_)),
    last_day_year(Year,Last_day_year),
    is_before(Time,Last_day_year),
    first_day_year(Year,First_day_year),
    is_before(First_day_year,Time),
    purpose_(Service,span("agricultural labor",_,_)).

s3306_a_2_A(Employer,Caly,Wages,Service) :-
	findall(
		(Amount,Service_),
		(
			s3306_a_2_is_wages(Employer, Caly, Epay, Amount, Service_);
			(
                number(Caly),
				Pyear is Caly-1,
				s3306_a_2_is_wages(Employer, Pyear, Epay, Amount, Service_)
			)
		),
		Amount_service
	),
    findall(
        Amount,
        member((Amount,_),Amount_service),
        Wageslist
    ),
    findall(
        Service_,
        member((_,Service_),Amount_service),
        Service
    ),
	sum_list(Wageslist,Wages),
    number(Wages),
	Wages>=20000.

%(B) on each of some 10 days during the calendar year or during the preceding calendar year, each day being in a different calendar week, employed at least 5 individuals in employment in agricultural labor for some portion of the day.
s3306_a_2_is_day_of_employment(Person,Individuals,Agricultural_labor,Day) :-
	findall(
        (Employee,Service),
        (
            s3306_c(Service,Person,Employee,Day,_),
            (
                purpose_(Service,span("agricultural labor",_,_));
                type_(Service,span("agricultural labor",_,_))
            )
        ),
        Employee_x_service
    ),
    findall(
        Employee,
        member((Employee,_),Employee_x_service),
        Employees
    ),
    findall(
        Labor,
        member((_,Labor),Employee_x_service),
        Agricultural_labor
    ),
    list_to_set(Employees,Individuals),
	length(Individuals,Num_employees),
    number(Num_employees),
	Num_employees>=5.

s3306_a_2_B(Employer,Workday,Service,Employee,S33A,Caly) :-
    last_day_year(Caly,Last_day_year),
    number(Caly),
    Year1 is Caly-1,
    first_day_year(Year1,First_day_year1),
	findall(
		(Day,Employees,Labor),
		(
            s3306_c(_,Employer,_,Day,_), % narrow down the list of days
			s3306_a_2_is_day_of_employment(Employer,Employees,Labor,Day), % check that 5+ people were employed
            is_before(First_day_year1,Day),
            is_before(Day,Last_day_year)
		),
		Day_employees_labor
	),
    findall(
        Day,
        member((Day,_,_),Day_employees_labor),
        Day_list
    ),
	list_to_set(Day_list,Workday),
	length(Workday,Num_days),
    number(Num_days),
	Num_days>=10,
    findall(
		Week,
		(
			member(Day,Day_list),
            iso_week_date(Day, Week)
		),
		Weeks
	),
    list_to_set(Weeks,S33A),
	length(S33A,Num_weeks),
    number(Num_weeks),
	Num_weeks>=10,
    findall(
        Employees,
        member((_,Employees,_),Day_employees_labor),
        Employee
    ),
    findall(
        Labor,
        member((_,_,Labor),Day_employees_labor),
        Service
    ).

%(3) Domestic service

%In the case of domestic service in a private home, local college club, or local chapter of a college fraternity or sorority, the term "employer" means, with respect to any calendar year, any person who during any calendar quarter in the calendar year or the preceding calendar year paid wages in cash of $1,000 or more for such service.
s3306_a_3_is_wages(Person, Year, Remuneration, Service, Wages) :-
    s3306_b(Wages,Remuneration,Service,Person,_,_,_,_),
    start_(Remuneration,span(Time,_,_)),
    last_day_year(Year,Last_day_year),
    is_before(Time,Last_day_year),
    first_day_year(Year,First_day_year),
    is_before(First_day_year,Time),
	(
		(
			\+ means_(Remuneration,_)
		);
		(
			means_(Remuneration,span("cash",_,_))
		)
	),
	purpose_(Service,span("domestic service",_,_)).

s3306_a_3(Employer,Service,Wages,Caly) :-
	findall(
		(Amount,Service_),
        (
			s3306_a_3_is_wages(Employer, Caly, Epay, Service_, Amount);
			(
                number(Caly),
				Pyear is Caly-1,
				s3306_a_3_is_wages(Employer, Pyear, Epay, Service_, Amount)
			)
		),
		Amount_service
	),
    findall(
        Amount,
        member((Amount,_),Amount_service),
        Wages_list
    ),
    findall(
        Service_,
        member((_,Service_),Amount_service),
        Service
    ),
	sum_list(Wages_list,Wages),
    number(Wages),
	Wages>=1000.

%(4) Special rule

%A person treated as an employer under paragraph (3) shall not be treated as an employer with respect to wages paid for any service other than domestic service referred to in paragraph (3) unless such person is treated as an employer under paragraph (1) or (2) with respect to such other service.
% This will be satisfied automatically here since all 3 types of employer are kept separate.
s3306_a_4(). % always true.

%(b) Wages

%For purposes of this chapter, the term "wages" means all remuneration for employment, including the cash value of all remuneration (including benefits) paid in any medium other than cash; except that such term shall not include-
s3306_b(Wages,Remuneration,Employment,Payer,Payee,Employer,Employee,Medium) :-
	payment_(Remuneration),
    (
        (\+ means_(Remuneration,_));
        means_(Remuneration,span(Medium,_,_))
    ),
    agent_(Remuneration,span(Payer,_,_)),
    (
        (
            patient_(Remuneration,span(Payee,_,_)),
            \+ plan_(span(Payee,_,_))
        );
        (
            patient_(Remuneration,Plan),
            plan_(Plan),
            beneficiary_(Plan,span(Payee,_,_))
        )
    ),
	service_(Employment),
    agent_(Employment,span(Employee,_,_)),
    patient_(Employment,span(Employer,_,_)),
	purpose_(Remuneration,Employment),
    end_(Employment,span(End_service,_,_)),
    year_from_date(End_service, Year),
	s3306_c(Employment,_,_,_,Year),
	amount_(Remuneration,span(Wages_before,_,_)),
    s3306_b_1(Wages_before,Wages),
	\+ s3306_b_2(Remuneration,Employment,Payer,Payee,_,Plan),
    \+ s3306_b_7(Remuneration,Employment,Payer,Payee,_,_),
	\+ s3306_b_10(Remuneration,Employment,Payer,Payee,_,Plan),
	\+ s3306_b_11(Remuneration,Employment,_),
    \+ s3306_b_15(Remuneration,Employer,Payee,Employee,_).

%(1) that part of the remuneration which, after remuneration (other than remuneration referred to in the succeeding paragraphs of this subsection) equal to $7,000 with respect to employment has been paid to an individual by an employer during any calendar year, is paid to such individual by such employer during such calendar year;
s3306_b_1(Remuneration,Remuneration2) :-
    number(Remuneration),
    Remuneration2 is min(7000,Remuneration).

%(2) the amount of any payment (including any amount paid by an employer for insurance or annuities, or into a fund, to provide for any such payment) made to, or on behalf of, an employee or any of his dependents under a plan or system established by an employer which makes provision for his employees generally (or for his employees generally and their dependents) or for a class or classes of his employees (or for a class or classes of his employees and their dependents), on account of-
s3306_b_2(Remuneration,Service,Employer,Employee,Payee,Plan) :-
	s3306_c(Service,Employer,Employee,_,_),
	payment_(Remuneration),
	agent_(Remuneration,span(Employer,_,_)),
	plan_(Plan), % existence of the plan
	beneficiary_(Plan,span(Payee,_,_)),
	(
		double_equal(Employee,Payee);
        s152(Payee,Employee,_)
	),
	(
		s3306_b_2_A(Plan);
		s3306_b_2_C(Plan)
	),
	(   % payment into a fund
		patient_(Remuneration,Plan);
		% payment using the fund
		(
			means_(Remuneration,Plan),
			patient_(Remuneration,span(Payee,_,_))
		)
	).

%(A) sickness or accident disability, or
s3306_b_2_A(Plan) :-
    purpose_(Plan,span("make provisions for employees in case of sickness",_,_));
    purpose_(Plan,span("make provisions for employees in case of accident disability",_,_)).

%(C) death;
s3306_b_2_C(Plan) :-
	purpose_(Plan,span("make provisions for employees in case of death",_,_)).

%(7) remuneration paid in any medium other than cash to an employee for service not in the course of the employer's trade or business;
s3306_b_7(Remuneration,Service,Employer,Employee,Medium,S92) :-
	s3306_c(Service,Employer,Employee,_,_),
	means_(Remuneration,span(Medium,_,_)),
	\+ double_equal(Medium,"cash"),
    business_(Employers_business),
	agent_(Employers_business,span(Employer,_,_)),
	type_(Employers_business,span(S92,_,_)),
    type_(Service,span(Type_service,_,_)),
	\+ double_equal(S92, Type_service).

%(10) any payment or series of payments by an employer to an employee or any of his dependents which is paid-
s3306_b_10(Remuneration,Service,Employer,Employee,Payee,Plan) :-
	s3306_c(Service,Employer,Employee,_,_),
    start_(Remuneration,span(Remuneration_day,_,_)),
    year_from_date(Remuneration_day, Year_int),
	agent_(Remuneration,span(Employer,_,_)),
	patient_(Remuneration,span(Payee,_,_)),
	(
		double_equal(Employee,Payee);
		(
			s152(Employee,Any_of_his_dependents,Year_int),
			double_equal(Any_of_his_dependents,Payee)
		)
	),
	s3306_b_10_A(Remuneration,Service,Employee,Employer,_,_),
    s3306_b_10_B(Employer,Remuneration,Plan).

%(A) upon or after the termination of an employee's employment relationship because of (i) death, or (ii) retirement for disability, and
s3306_b_10_A(Remuneration,Employment,Employee,Employer,S101,S105) :-
	start_(Remuneration,span(Start_remuneration,_,_)),
	termination_(S101),
    agent_(S101,span(Employer,_,_)),
	patient_(S101,Employment),
	(
        start_(S101,span(Start_termination,_,_));
        end_(Employment,span(Start_termination,_,_))
    ),
    is_before(Start_termination,Start_remuneration),
	reason_(S101,S105),
	(
        disability_(S105);
        death_(S105)
    ),
	agent_(S105,span(Employee,_,_)).

%(B) under a plan established by the employer which makes provision for his employees generally or a class or classes of his employees (or for such employees or class or classes of employees and their dependents),
s3306_b_10_B(Employer,Remuneration,Plan) :-
	means_(Remuneration,Plan),
	plan_(Plan),
	agent_(Plan,span(Employer,_,_)),
    purpose_(Plan,span("make provisions for employees or dependents",_,_)).

%other than any such payment or series of payments which would have been paid if the employee's employment relationship had not been so terminated;

%(11) remuneration for agricultural labor paid in any medium other than cash;
s3306_b_11(Remuneration,Service,Medium) :-
    service_(Service),
	purpose_(Service,span("agricultural labor",_,_)),
	patient_(Service,span(Employer,_,_)),
	agent_(Service,span(Employee,_,_)),
    agent_(Remuneration,span(Employer,_,_)),
	patient_(Remuneration,span(Employee,_,_)),
	purpose_(Remuneration,Service),
	means_(Remuneration,span(Medium,_,_)),
    \+ double_equal(Medium,"cash").

%(15) any payment made by an employer to a survivor or the estate of a former employee after the calendar year in which such employee died;
s3306_b_15(Remuneration,Employer,Payee,Employee,Caly) :-
    s3306_c(_,Employer,Employee,_,_),
	agent_(Remuneration,span(Employer,_,_)),
	patient_(Remuneration,span(Payee,_,_)),
	start_(Remuneration,span(Start_remuneration,_,_)),
	death_(Edeath),
	agent_(Edeath,span(Employee,_,_)),
	start_(Edeath,span(Time_death,_,_)),
    marriage_(Emar),
	agent_(Emar,span(Employee,_,_)),
	agent_(Emar,span(Payee,_,_)),
	(
        \+ end_(Emar,_);
        end_(Emar,span(Time_death,_,_))
    ),
    year_from_date(Start_remuneration, Year_remuneration),
    year_from_date(Time_death, Caly),
    number(Year_remuneration),
    number(Caly),
	Year_remuneration>Caly.

%(c) Employment

%For purposes of this chapter, the term "employment" means any service, of whatever nature,
s3306_c(Service,Employer,Employee,Workday,Caly) :-
	service_(Service),
    (
        (
            var(Workday)
        );
        (
            nonvar(Workday),
            year_from_date(Workday, Caly)
        )
    ),
    ( 
        s3306_c_A(Service,Employer,Employee);
        s3306_c_B(Service,Employer,Employee,_)
	),
	\+ s3306_c_1(Service,Caly),
	\+ s3306_c_2(Service,_,Caly),
	\+ s3306_c_5(Service,Employer,Employee,Workday),
	\+ s3306_c_6(Service),
	\+ s3306_c_7(Service,_),
	\+ s3306_c_10(Service,Employer,Employee,Workday),
	\+ s3306_c_11(Service,Employer),
	\+ s3306_c_13(Service,Employer,Employee,Workday),
	\+ s3306_c_16(Service,Employer),
	\+ s3306_c_21(Service,Employee,_,Workday).

%(A) performed by an employee for the person employing him, irrespective of the citizenship or residence of either, within the United States, and
s3306_c_A(Service,Employer,Employee) :-
	agent_(Service,span(Employee,_,_)),
	patient_(Service,span(Employer,_,_)), 
    (
        location_(Service,Geographical_location);
        ( % by default, assume it's in the US
            \+ location_(Service,_),
            Geographical_location = span("USA",-1,-1)
        )
    ),
    (
        (
            country_(Geographical_location,span(Country,_,_)),
            double_equal(Country,"USA")
        );
        (
            \+ country_(Geographical_location,_),
            double_equal(Geographical_location,span("USA",_,_))
        )
    ).

%(B) performed outside the United States (except in a contiguous country with which the United States has an agreement relating to unemployment compensation) by a citizen of the United States as an employee of an American employer, except-
s3306_c_B(Service,Employer,Employee,Location) :-
	agent_(Service,span(Employee,_,_)),
	patient_(Service,span(Employer,_,_)),
	(
        (
            country_(Location,span(Country,_,_)),
            \+ double_equal(Country,"USA")
        );
        (
            \+ country_(Location,_),
            \+ double_equal(Location,"USA")
        )
    ),
	\+ (
		unemployment_compensation_agreement_(Agreement),
		agent_(Agreement,span("USA",_,_)),
		agent_(Agreement,span(Location,_,_))
	),
    american_employer_(Employer_is_american_employer),
    agent_(Employer_is_american_employer,span(Employer,_,_)),
	citizenship_(Employee_is_american),
	agent_(Employee_is_american,span(Employee,_,_)),
    (
        patient_(Employee_is_american,span("USA",_,_));
        patient_(Employee_is_american,span("American",_,_))
    ).

%(1) agricultural labor unless-
s3306_c_1(Service,Caly) :-
	(
		purpose_(Service,span("agricultural labor",_,_));
        type_(Service,span("agricultural labor",_,_))
	),
	\+ (
		s3306_c_1_A(Service,_,Caly),
		s3306_c_1_B(Service,_)
	).

%(A) such labor is performed for a person who-
s3306_c_1_A(Service,Employer,Caly) :-
    service_(Service),
	patient_(Service,span(Employer,_,_)),
    nonvar(Caly),
	(
		s3306_c_1_A_i(Employer,_,_,_,Caly);
		s3306_c_1_A_ii(Employer,_,_,_,_,Caly)
	).

%(i) during the calendar year or the preceding calendar year paid remuneration in cash of $20,000 or more to individuals employed in agricultural labor (including labor performed by an alien referred to in subparagraph (B)), or
s3306_c_1_A_i(Employer,Remuneration,Employee,Service,Caly) :-
    last_day_year(Caly,Last_day_year),
    number(Caly),
    Year1 is Caly-1,
    first_day_year(Year1,First_day_year),
    findall(
        (Amount,Employee_,Service_),
        (
            payment_(Payment),
            agent_(Payment,span(Employer,_,_)),
            patient_(Payment,span(Employee_,_,_)),
            service_(Service_),
            agent_(Service_,span(Employee_,_,_)),
            patient_(Service_,span(Employer,_,_)),
            (
                purpose_(Service_,span("agricultural labor",_,_));
                type_(Service_,span("agricultural labor",_,_))
            ),
            purpose_(Payment,Service_),
            amount_(Payment,span(Amount,_,_)),
            start_(Payment,span(Payment_time,_,_)),
            is_before(First_day_year,Payment_time),
            is_before(Payment_time,Last_day_year),
            (
                (
                    \+ means_(Payment,_)
                );
                means_(Payment,span("cash",_,_))
            )
        ),
        Amounts_employee_service
    ),
    findall(
        Amount,
        member((Amount,_,_),Amounts_employee_service),
        Amounts
    ),
    sum_list(Amounts,Remuneration),
    number(Remuneration),
    Remuneration >= 20000,
    findall(
        Individual,
        member((_,Individual,_),Amounts_employee_service),
        Employee
    ),
    findall(
        Service_,
        member((_,_,Service_),Amounts_employee_service),
        Service
    ).

%(ii) on each of some 10 days during the calendar year or the preceding calendar year, each day being in a different calendar week, employed in agricultural labor (including labor performed by an alien referred to in subparagraph (B)) for some portion of the day (whether or not at the same moment of time) 5 or more individuals; and
s3306_c_1_A_ii(Employer,Workday,Service,Employee,S156,Caly) :-
	s3306_a_2_B(Employer,Workday,Service,Employee,S156,Caly).

%(B) such labor is not agricultural labor performed by an individual who is an alien admitted to the United States to perform agricultural labor.
s3306_c_1_B(Service,Employee) :-
	\+ (
	    (
			type_(Service,span("agricultural labor",_,_));
			purpose_(Service,span("agricultural labor",_,_))
		),
		citizenship_(Employee_citizenship),
		agent_(Employee_citizenship,span(Employee,_,_)),
		patient_(Employee_citizenship,span(Country,_,_)),
		\+ (
            double_equal(Country,"USA");
            double_equal(Country,"American")
        ),
		migration_(Employee_migration),
		agent_(Employee_migration,span(Employee,_,_)),
		destination_(Employee_migration,span("USA",_,_)),
		purpose_(Employee_migration,span("agricultural labor",_,_))
	).

%(2) domestic service in a private home, local college club, or local chapter of a college fraternity or sorority unless performed for a person who paid cash remuneration of $1,000 or more to individuals employed in such domestic service in any calendar quarter in the calendar year or the preceding calendar year;
s3306_c_2(Service,Location,Caly) :-
	(
		type_(Service,span("domestic service",_,_));
		purpose_(Service,span("domestic service",_,_))
	),
    patient_(Service,span(Person,_,_)),
    location_(Service,span(Location,_,_)),
	(
		double_equal(Location,"private home");
		double_equal(Location,"local college club");
		double_equal(Location,"local chapter of a college fraternity");
		double_equal(Location,"local chapter of a college sorority")
	),
	\+ s3306_a_3(Person,_,_,Caly).

% (5) 
s3306_c_5(Service,Employer,Employee,Workday) :-
    (
        s3306_c_5_A(Service,Employee,Employer,Workday);
        s3306_c_5_B(Service,Employee,Employer,Workday)
    ).

% (A) service performed by an individual in the employ of his son, daughter, or spouse;
s3306_c_5_A(Service,Employee,Employer,Workday) :-
	service_(Service),
	agent_(Service,span(Employee,_,_)),
	patient_(Service,span(Employer,_,_)),
    (
        (
            is_child_of(Employer,Employee,_,_)
        );
        (
            marriage_(Marriage),
            agent_(Marriage,span(Employer,_,_)),
            agent_(Marriage,span(Employee,_,_)),
            \+ double_equal(Employer,Employee),
            start_(Marriage,span(Time_start,_,_)),
            is_before(Time_start,Workday),
            (
                (
                    \+ end_(Marriage,_)
                );
                (
                    end_(Marriage,span(Time_end,_,_)),
                    is_before(Workday,Time_end)
                )
            )
        )
    ).

% (B) service performed by a child under the age of 21 in the employ of his father or mother;
s3306_c_5_B(Service,Employee,Employer,Workday) :-
    service_(Service),
	agent_(Service,span(Employee,_,_)),
    patient_(Service,span(Employer,_,_)),
    is_child_of(Employee,Employer,_,_),
    birth_(Birth_employee),
    agent_(Birth_employee,span(Employee,_,_)),
    start_(Birth_employee,span(Date_of_birth,_,_)),
    number(Date_of_birth),
    Stamp_21 is Date_of_birth + 21*10000, % add 21 years to date of birth
    number(Stamp_21),
    number(Workday),
    Stamp_21>Workday.

%(6) service performed in the employ of the United States Government
s3306_c_6(Service) :-
	patient_(Service,span(Employer,_,_)),
	double_equal(Employer,"United States Government").

%(7) service performed in the employ of a State, or any political subdivision thereof.
s3306_c_7(Service,Employer) :-
	patient_(Service,span(Employer,_,_)),
	is_prefix("State of ", Employer).

%(10)
s3306_c_10(Service,Employer,Employee,Workday) :-
    s3306_c_10_A(Service,Employer,Employee,Workday);
    s3306_c_10_B(Service,Employer,Employee,Workday).

%(A) service performed in the employ of a school, college, or university, if such service is performed
s3306_c_10_A(Service,Employer,Employee,Workday) :-
	patient_(Service,span(Employer,_,_)),
    agent_(Service,span(Employee,_,_)),
	educational_institution_(Employer_is_an_educational_institution),
	agent_(Employer_is_an_educational_institution,span(Employer,_,_)),
    s3306_c_10_A_i(Student,Employer,Workday),
	(
		double_equal(Employee,Student);
		s3306_c_10_A_ii(Employee,Student,Workday)
	).

%(i) by a student who is enrolled and is regularly attending classes at such school, college, or university, or
s3306_c_10_A_i(Student,Employer,Workday) :-
	enrollment_(Student_is_enrolled),
	agent_(Student_is_enrolled,span(Student,_,_)),
	patient_(Student_is_enrolled,span(Employer,_,_)),
	start_(Student_is_enrolled,span(Start_enrollment,_,_)),
	attending_classes_(Student_attends_classes),
	agent_(Student_attends_classes,span(Student,_,_)),
	location_(Student_attends_classes,span(Employer,_,_)),
	start_(Student_attends_classes,span(Start_attendance,_,_)),
	is_before(Start_enrollment,Workday),
	is_before(Start_attendance,Workday),
	(
		(
			\+ end_(Student_is_enrolled,_)
		);
		(
			end_(Student_is_enrolled,span(Stop_enrollment,_,_)),
			is_before(Workday,Stop_enrollment)
		)
	),
	(
		(
			\+ end_(Student_attends_classes,_)
		);
		(
			end_(Student_attends_classes,span(Stop_attendance,_,_)),
			is_before(Workday,Stop_attendance)
		)
	).

%(ii) by the spouse of such a student, or
s3306_c_10_A_ii(Spouse,Student,Workday) :-
    year_from_date(Workday, Year),
    s7703(Student,Spouse,Marriage,Year),
	(
		(
			\+ start_(Marriage,_)
		);
		(
			start_(Marriage,span(Start_marriage,_,_)),
			is_before(Start_marriage,Workday)
		)
	),
	(
		(
			\+ end_(Marriage,_)
		);
		(
			end_(Marriage,span(End_marriage,_,_)),
			is_before(Workday,End_marriage)
		)
	),
	s3306_c_10_A_i(Spouse,_,Workday).

%(B) service performed in the employ of a hospital, if such service is performed by a patient of such hospital;
s3306_c_10_B(Service,Employer,Employee,Workday) :-
    service_(Service),
	patient_(Service,span(Employer,_,_)),
	agent_(Service,span(Employee,_,_)),
	hospital_(Employer_is_hospital),
	agent_(Employer_is_hospital,span(Employer,_,_)),
	medical_patient_(Employee_is_medical_patient),
	agent_(Employee_is_medical_patient,span(Employee,_,_)),
	patient_(Employee_is_medical_patient,span(Employer,_,_)),
	start_(Employee_is_medical_patient,span(Start_patient,_,_)),
	is_before(Start_patient,Workday),
	(
		(
			\+ end_(Employee_is_medical_patient,_)
		);
		(
			end_(Employee_is_medical_patient,span(End_patient,_,_)),
			is_before(Workday,End_patient)
		)
	).

%(11) service performed in the employ of a foreign government (including service as a consular or other officer or employee or a nondiplomatic representative);
s3306_c_11(Service,Employer) :-
    service_(Service),
	patient_(Service,span(Employer,_,_)),
    is_suffix(" Government", Employer),
	\+ double_equal(Employer,"United States Government").

%(13) service performed as a student nurse in the employ of a hospital or a nurses' training school by an individual who is enrolled and is regularly attending classes in a nurses' training school;
s3306_c_13(Service,Employer,Employee,Workday) :-
	patient_(Service,span(Employer,_,_)),
	agent_(Service,span(Employee,_,_)),
	(
        nurses_training_school_(Employer_is_hospital_or_nurses_training_school);
        hospital_(Employer_is_hospital_or_nurses_training_school)
    ),
	agent_(Employer_is_hospital_or_nurses_training_school,span(Employer,_,_)),
    nurses_training_school_(Isa_nurses_training_school),
    agent_(Isa_nurses_training_school,span(Nurses_training_school,_,_)),
	enrollment_(Student_is_enrolled),
	agent_(Student_is_enrolled,span(Employee,_,_)),
	patient_(Student_is_enrolled,span(Nurses_training_school,_,_)),
	start_(Student_is_enrolled,span(Start_enrollment,_,_)),
	attending_classes_(Student_attends_classes),
	agent_(Student_attends_classes,span(Employee,_,_)),
	location_(Student_attends_classes,span(Nurses_training_school,_,_)),
	start_(Student_attends_classes,span(Start_attendance,_,_)),
	is_before(Start_enrollment,Workday),
	is_before(Start_attendance,Workday),
	(
		(
			\+ end_(Student_is_enrolled,_)
		);
		(
			end_(Student_is_enrolled,span(Stop_enrollment,_,_)),
			is_before(Workday,Stop_enrollment)
		)
	),
	(
		(
			\+ end_(Student_attends_classes,_)
		);
		(
			end_(Student_attends_classes,span(Stop_attendance,_,_)),
			is_before(Workday,Stop_attendance)
		)
	).

%(16) service performed in the employ of an international organization;
s3306_c_16(Service,Employer) :-
    service_(Service),
	patient_(Service,span(Employer,_,_)),
	international_organization_(Employer_is_international_organization),
	agent_(Employer_is_international_organization,span(Employer,_,_)).

%(21) service performed by a person committed to a penal institution.
s3306_c_21(Service,Employee,S235,Workday) :-
	agent_(Service,span(Employee,_,_)),
	penal_institution_(Jail_is_a_penal_institution),
	agent_(Jail_is_a_penal_institution,span(S235,_,_)),
	incarceration_(Person_goes_to_jail),
	agent_(Person_goes_to_jail,span(Employee,_,_)),
	patient_(Person_goes_to_jail,span(S235,_,_)),
	start_(Person_goes_to_jail,span(Start_incarceration,_,_)),
	is_before(Start_incarceration,Workday),
	(
		(
			\+ end_(Person_goes_to_jail,_)
		);
		(
			end_(Person_goes_to_jail,span(End_incarceration,_,_)),
			is_before(Workday,End_incarceration)
		)
	).
