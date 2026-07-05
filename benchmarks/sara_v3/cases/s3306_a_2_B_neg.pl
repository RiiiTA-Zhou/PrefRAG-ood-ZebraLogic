% Text
% Alice has employed Bob, Cameron, Dan, Emily, Fred and George for agricultural labor on various occasions during the year 2017:
% - Jan 24: Bob, Cameron, Dan, Emily and Fred
% - Feb 4: Bob, Cameron and Fred
% - Mar 3: Bob, Cameron, Dan, Emily and Fred
% - Mar 18: Cameron, Dan, Emily, Fred and George
% - Apr 1: Bob, Cameron, Dan, Fred and George
% - May 9: Cameron, Dan, Emily, Fred and George
% - Oct 14: Bob, Cameron, Dan, Emily and George
% - Oct 25: Bob, Emily, Fred and George
% - Nov 8: Bob, Cameron, Emily, Fred and George
% - Nov 22: Bob, Cameron, Dan, Emily and Fred
% - Dec 1: Bob, Cameron, Dan, Emily and George
% - Dec 2: Bob, Cameron, Dan, Emily and George

% Question
% Section 3306(a)(2)(B) applies to Alice for the year 2017. Contradiction

% Facts
:- discontiguous s3306_c/5.
:- [statutes/prolog/init].
s3306_c(span("labor",78,82),"Alice","Bob",20170124,_).
s3306_c(span("labor",78,82),"Alice","Cameron",20170124,_).
s3306_c(span("labor",78,82),"Alice","Dan",20170124,_).
s3306_c(span("labor",78,82),"Alice","Emily",20170124,_).
s3306_c(span("labor",78,82),"Alice","Fred",20170124,_).
s3306_c(span("labor",78,82),"Alice","Bob",20170204,_).
s3306_c(span("labor",78,82),"Alice","Cameron",20170204,_).
s3306_c(span("labor",78,82),"Alice","Fred",20170204,_).
s3306_c(span("labor",78,82),"Alice","Bob",20170303,_).
s3306_c(span("labor",78,82),"Alice","Cameron",20170303,_).
s3306_c(span("labor",78,82),"Alice","Dan",20170303,_).
s3306_c(span("labor",78,82),"Alice","Emily",20170303,_).
s3306_c(span("labor",78,82),"Alice","Fred",20170303,_).
s3306_c(span("labor",78,82),"Alice","Cameron",20170318,_).
s3306_c(span("labor",78,82),"Alice","Dan",20170318,_).
s3306_c(span("labor",78,82),"Alice","Emily",20170318,_).
s3306_c(span("labor",78,82),"Alice","Fred",20170318,_).
s3306_c(span("labor",78,82),"Alice","George",20170318,_).
s3306_c(span("labor",78,82),"Alice","Bob",20170401,_).
s3306_c(span("labor",78,82),"Alice","Cameron",20170401,_).
s3306_c(span("labor",78,82),"Alice","Dan",20170401,_).
s3306_c(span("labor",78,82),"Alice","Fred",20170401,_).
s3306_c(span("labor",78,82),"Alice","George",20170401,_).
s3306_c(span("labor",78,82),"Alice","Cameron",20170509,_).
s3306_c(span("labor",78,82),"Alice","Dan",20170509,_).
s3306_c(span("labor",78,82),"Alice","Emily",20170509,_).
s3306_c(span("labor",78,82),"Alice","Fred",20170509,_).
s3306_c(span("labor",78,82),"Alice","George",20170509,_).
s3306_c(span("labor",78,82),"Alice","Bob",20171014,_).
s3306_c(span("labor",78,82),"Alice","Cameron",20171014,_).
s3306_c(span("labor",78,82),"Alice","Dan",20171014,_).
s3306_c(span("labor",78,82),"Alice","Emily",20171014,_).
s3306_c(span("labor",78,82),"Alice","George",20171014,_).
s3306_c(span("labor",78,82),"Alice","Bob",20171025,_).
s3306_c(span("labor",78,82),"Alice","Emily",20171025,_).
s3306_c(span("labor",78,82),"Alice","Fred",20171025,_).
s3306_c(span("labor",78,82),"Alice","George",20171025,_).
s3306_c(span("labor",78,82),"Alice","Bob",20171108,_).
s3306_c(span("labor",78,82),"Alice","Cameron",20171108,_).
s3306_c(span("labor",78,82),"Alice","Emily",20171108,_).
s3306_c(span("labor",78,82),"Alice","Fred",20171108,_).
s3306_c(span("labor",78,82),"Alice","George",20171108,_).
s3306_c(span("labor",78,82),"Alice","Bob",20171122,_).
s3306_c(span("labor",78,82),"Alice","Cameron",20171122,_).
s3306_c(span("labor",78,82),"Alice","Dan",20171122,_).
s3306_c(span("labor",78,82),"Alice","Emily",20171122,_).
s3306_c(span("labor",78,82),"Alice","Fred",20171122,_).
s3306_c(span("labor",78,82),"Alice","Bob",20171201,_).
s3306_c(span("labor",78,82),"Alice","Cameron",20171201,_).
s3306_c(span("labor",78,82),"Alice","Dan",20171201,_).
s3306_c(span("labor",78,82),"Alice","Emily",20171201,_).
s3306_c(span("labor",78,82),"Alice","George",20171201,_).
s3306_c(span("labor",78,82),"Alice","Bob",20171202,_).
s3306_c(span("labor",78,82),"Alice","Cameron",20171202,_).
s3306_c(span("labor",78,82),"Alice","Dan",20171202,_).
s3306_c(span("labor",78,82),"Alice","Emily",20171202,_).
s3306_c(span("labor",78,82),"Alice","George",20171202,_).
purpose_(span("labor",78,82),span("agricultural labor",65,82)).

% Test
:- \+ s3306_a_2_B("Alice",_,_,_,_,2017).
:- halt.
