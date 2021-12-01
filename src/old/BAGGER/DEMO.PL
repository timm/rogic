term_expansion((X - Y = Z :- Body),
               (demo(X,Y) :- Body 
                             ->  portray_clause((X/Y  :- Z)) 
                              ;  format('E> test case failed: [~p - ~p]\n'
                                        ,[X,Y]),
                                 fail)).	

loading- 1 = X :- 
	goal_expansion(when with [day=1
                                 ,sad
                                 ,month=2
                                 ,happy
                                 ],X).

loading- 2 = X :-
	goal_expansion(when with [day=1
                                 ,sad
                                 ,second= day with [month=41]
                                 ,month=2,happy
                                 ],X).
