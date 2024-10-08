function dtest(fun, tpath)

% Runs unit test defined in fun, by calling mtest routine, and display results.
%
% INPUTS
%  - fun   [string], name of the Matlab routine where unit tests have to be run (with path).
%  - tpath [string], path to the folder where the test routines generated by mtest should be
%          temporarly saved.
%
% OUTPUTS
%  None.
%
% REMARKS
%  - If only one input argument is provided, fname must be a string containing the
%    full path to the targeted matlab routine.
%  - If two input arguments are provided, fname is the base name of the targeted
%    matlab routine and fpath is the path to this routine.
%
% See also mtest

% Copyright (C) 2011-2017 Dynare Team
%
% This file is part of Dynare (m-unit-tests module).
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare's m-unit-tests module is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
% or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
% more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

if nargin>1 || isempty(tpath)
    original_directory = pwd();
end

% Relative path
[fpath, fname, ext] = fileparts(fun);

% Absolute path
fpath = [original_directory filesep fpath];

if nargin>1 || isempty(tpath)
    cd(tpath)
end

mex_flag = 0;
if exist(fname)==3
    mex_flag = 1;
end

class_flag = 0;
if ~isempty(strfind(fun,'@')) || ~isempty(strfind(which(fname),'@'))
    class_flag = 1;
end

check = mtest(fname, fpath);

if check
    if mex_flag
        disp(['Succesfull test(s) for ' fname ' mex file!'])
    elseif class_flag
        disp(['Succesfull test(s) for ' fname ' method!'])
    else
        disp(['Succesfull test(s) for ' fname ' routine!'])
    end
end

if nargin>1 || isempty(tpath)
    cd(original_directory);
end