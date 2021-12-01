/* file: welcome.pl 1.0.0 (USP LSI) Sat Mar 26 21:41:32 1994

    Copyright (c) 1994 Richard Victor Benjamins. All rights reserved.
    richard@lsi.usp.br

    Purpose: welcome the user.
*/

welcome:-
%  shell('cat -u /users/iasi/richard/diverse/groet/moving/gymnast2.vt'),
  nl,
  write('***************************************************************************'),nl,
  write('*                                                                         *'),
  nl,
  write('*                                                                         *'),
  nl,
  write('*Welcome to TinA, a program to construct diagnostic inference structures. *'),
  nl,
  write('*                                                                         *'),
  nl,
  write('*                        Tool in Acquisition!                             *'), 
  nl,
  write('*                                                                         *'),
  nl,
  write('*                Copyright (c) V.R. (Richard) Benjamins                   *'),nl,
  write('*                                                                         *'),
  nl,
  write('**hit****************************any**********************************key**'), 
  nl, nl,
writeln(['To go the the next screen, always hit any key, including now.']),
writeln(['Options should be ended with a dot "."']), nl,
  get_single_char(_).

