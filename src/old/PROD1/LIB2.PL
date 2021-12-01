%%%% Start-up commands %<
:- current_prolog_flag(max_integer,X), 
    X1 is X - 1, 
    retractall(inf(_)),
    assert(inf(X1)).
%>
