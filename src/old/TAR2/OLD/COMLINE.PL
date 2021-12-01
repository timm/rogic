(com)=[in,out].

com v   - 'show version'         --> {ver}.
com help- 'show help options'    --> {showOptions}.
com ?   - T                      --> com help-T.
com p   - 'open a command line'  --> {prolog}.
com q   - 'quit' --> {halt}.
com +F  - 'execute options file' -->
	{see(F), read(X), seen, com(X)}.
com run --> [].

%-----------------------------------------
% internal stuff- don't change!


com X  --> {nonvar(X)},  com X - _.
com init --> com [in  is user,out is user].
com go(Args) --> com init, com Args.
