environment(lroot,'/home/timm/apps/prolog/lili').
environment(lbin,'/home/timm/apps/prolog/lili/bin').
environment(lkb,'/home/timm/apps/prolog/lili/kb').
environment(llib,'/home/timm/apps/prolog/lili/lib').
environment(ltemp,'/home/timm/apps/prolog/lili/temp').
environment(lid,'lili2022').
environment(lmsg,'/home/timm/apps/prolog/lili/temp/warn').

reload :- [
    '/home/timm/apps/prolog/lili/setup/ops.pl',
    '/home/timm/apps/prolog/lili/bin/utils.pl',
    '/home/timm/apps/prolog/lili/bin/q00.pl',
    '/home/timm/apps/prolog/lili/bin/q01.pl',
    '/home/timm/apps/prolog/lili/setup/loadlast.pl'].

:- reload.
