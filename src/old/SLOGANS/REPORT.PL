slogans :- slogan(_),fail.
slogans.

slogan(X) :-
	down(slogan,X),
	instance(X),
	grab(X,text,Text),
	grab(X,author,Author),
	grab(Author,fname,Fname),
	grab(Author,lname,Lname),
	format('<>\n<SLOGAN-ID>~a\n<SLOGAN-TEXT>~s\n<AUTHOR>~s ~s\n',
              [X,Text,Fname,Lname]).

sloganDetails :- sloganDetail(_),fail.
sloganDetails.

sloganDetail(X) :-
	slogan(X),
	grab(X,notes,Notes),
	grab(X,plan,Plan),
	format('<NOTES>~s\n<PLAN>~s\n',[Notes,Plan]).

authors(All) :-	setof(One,author(One),All).
author(A - B - C) :-
        down(person, C),
        instance(C),
        grab(C, fname, B),
        grab(C, lname, A).

showAuthors :-
	authors(All),
	member(Lname-Fname-A,All),
	showAuthor(Lname-Fname-A),
	fail.

showAuthor(Lname-Fname-A) :-
	slogansOfAuthors(A,Slogans),
	format('<>\n<LAST-NAME>~s\n<FIRST-NAME>~s\n',
			[Lname,Fname]),
	member(Slogan-Id,Slogans),
	format('<SLOGAN-ID>~a\n<SLOGAN>~s\n',[Id,Slogan]).

slogansOfAuthors(A,All) :-
	setof(One,A^sloganOfAuthor(A,One),All).
sloganOfAuthor(A,Slogan-Id) :-
	value0(Id,author,A),
	grab(Id,text,Slogan).
	
	
