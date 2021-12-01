% system.pl

% Contains calls to initialise whole system for performing time abduction.

:- ['/home/timm/apps/bight4/bin/system.pl'].
:- [abduct, dupmods, linkdups, readtdat, utils, mutate].

% This calls the following files:
%   HT4		- Tim's basic HT4 system (other system.pl)
%   abduct	- main code for time abduction
%   dupmods	- duplication and joining models to represent each time step
%   linkdups	- performs implicit and explicit linking of models, using nodes
%		  or links where appropriate
%   readtdat	- code for reading time data sequences and generating the
%		  input and output values (no averaging or other preprocessing)
%   utils	- general utilities
%   mutate	- code to mutate models and data for testing performance on
%		  incorrect models.
