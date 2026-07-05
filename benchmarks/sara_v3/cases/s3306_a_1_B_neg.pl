% Text
% Alice has employed Bob on various occasions during the year 2017:
% - Jan 24
% - Feb 4
% - Mar 3
% - Mar 18
% - Apr 1
% - Oct 25
% - Nov 8
% - Nov 22
% - Dec 1
% - Dec 2

% Question
% Section 3306(a)(1)(B) applies to Alice for the year 2017. Contradiction

% Facts
:- discontiguous s3306_c/5.
:- [statutes/prolog/init].
s3306_c(span("employed",10,17),"Alice","Bob",20170124,_).
s3306_c(span("employed",10,17),"Alice","Bob",20170204,_).
s3306_c(span("employed",10,17),"Alice","Bob",20170303,_).
s3306_c(span("employed",10,17),"Alice","Bob",20170318,_).
s3306_c(span("employed",10,17),"Alice","Bob",20170401,_).
s3306_c(span("employed",10,17),"Alice","Bob",20171025,_).
s3306_c(span("employed",10,17),"Alice","Bob",20171108,_).
s3306_c(span("employed",10,17),"Alice","Bob",20171122,_).
s3306_c(span("employed",10,17),"Alice","Bob",20171201,_).
s3306_c(span("employed",10,17),"Alice","Bob",20171202,_).

% Test
:- \+ s3306_a_1_B("Alice",_,_,2017).
:- halt.
