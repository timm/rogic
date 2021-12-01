/* file: load.pl 1.0.0 (USP LSI) Thu Mar 17 18:23:56 1994

    Copyright (c) 1994 Richard Victor Benjamins. All rights reserved.
    richard@lsi.usp.br

    Purpose: load all necessary files
*/

:- consult([ker_construct,
   	    ker_user_restr,
	    ker_ask,
	    ker_install_case,
	    ker_predef_strat,
	    ker_welcome,
            know_grammar,
	    know_criteria,
	    know_isa_crit,
	    impl_prolog_lib,
            io_inout]).


