:- +[records, lib/lists].

record(obj(name)).

obj0(numeric,obj(Id,Name),obj(Id,Name)) :- numericP(Name).
obj0(oneOf,  obj(Id,Name),obj(Id,Name)) :- rangeP(Name,_).


