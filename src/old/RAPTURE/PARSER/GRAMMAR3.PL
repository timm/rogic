program   -> [init,'{'], rstmt, ['}'], proctypes, [eof].
rstmt     -> [run], symbol,  [';',run], symbol.
proctype  -> [proctype], symbol, ['{'], body, ['}'].
proctypes -> proctype
           | proctype, proctypes.
body      -> [do], opts,  [od].
opt       -> startopt, guard, arrow, assgn.
startopt  -> [':',':'].
arrow     -> ['-','>'].
opts      -> opt
           | opt, opts.
guard     -> bexpr.
assgn     -> symbol,[=],expr.
bexpr     -> symbol,boperator,value.
expr      -> symbol,operator,value.
symbol    -> [X],{atomic(X)}, nsyms ++ 1, syms << X.
value     -> [X],{number(X)}.
boperator -> [>=]|[>]|[=]|[<]|[<=].
operator  -> [+]|[-].
