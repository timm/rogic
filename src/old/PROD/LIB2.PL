%%%% Start-up commands
%Create an infinity assertions.
%<
:- current_prolog_flag(max_integer,X), 
    X1 is X - 1, 
    retractall(inf(_)),
    assert(inf(X1)).
%>
%Initialize the hash tree syste,s.
%<
:- make=L,initHts(L).
%>