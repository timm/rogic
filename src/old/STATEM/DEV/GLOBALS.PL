h/hello is bool - 'should i say hello?' :-
        [-h,t];[-h,f].

%XXX setting switches from command line
%XXX changing help text to show the vars
%XXX stripping back all this silly var stuff..
%         its just another flag!!!
%    use bagof, msort, not setof for flag listing
% XXX add type expectation to help string

t/time is posInt - 'how often to print time ticks' :-
         [-t,1];[-t,0].

m/meng is posInt - 'how often to handle details?' :-
         [-m,200];[-m,0].
          

