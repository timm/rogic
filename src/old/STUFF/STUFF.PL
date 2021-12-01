 /**************************************************************************
 STUFF: cool prolog stuff
 Copyright (C) 2003 Tim Menzies

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 **************************************************************************/

 % where are we
 :- cd('d:/tim/src/pl/stuff').

 about(program,   'STUFF').
 about(version,   0.1).
 about(copyright, 2003).
 about(motto,     'Prolog things \'n stuff').
 about(copywho,   'Tim Menzies').

 stuff:- ssh([src/ops      % syntactic sugar stuff
             ,src/flags    % prolog control stuff
	     ,src/hooks    % stuff to hook into the reader
             ,src/hacks    % bad stuff we don't talk about
             ,src/lib      % standard stuff
             ,src/gpl      % license stuff
             ,src/freeze   % stuff not to optimize
             ,src/eval     % stuff to optimize
             ,src/zip      % the optimizer
             ,src/touch123 % helper predicates for...
             ,src/touch5   % ...the worker that accesses stuff
             ,src/things   % high-level drivers for touching stuff
             ]),
	 hello,            % welcome to stuff!
	 ssh([eg/kb1       % demo stuff
             ,eg/egs       % example stuff
             ]).
 
 ssh(L) :- load_files(L,[silent(yes)]).

 :- stuff.

