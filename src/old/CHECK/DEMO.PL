:- [shell].
:- range(saving,processing,cancel) is [t,f].
:- range(window)                   is [open,closed].

saving(t) :- processing(t), cancel(t), window(open).
end(t)    :- processing(t), cancel(t), window(closed).

processing(t).
cancel(t).
window(_).

go(One,Two) :- oops(saving(t),end(t),One,Two).














