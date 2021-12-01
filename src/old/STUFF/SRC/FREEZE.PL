% things we should defer till
% runtime

 freeze(A) :- instance(_,A).
 freeze(A) :- class(C,A), var(C).