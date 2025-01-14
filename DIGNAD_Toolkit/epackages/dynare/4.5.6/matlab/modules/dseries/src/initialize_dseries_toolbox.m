% Copyright (C) 2015-2017 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

% Check that the dates module is available.
try
    initialize_dates_toolbox;
catch
    urlwrite('https://github.com/DynareTeam/dates/archive/master.zip','master.zip');
    warning('off','MATLAB:MKDIR:DirectoryExists')
    mkdir('../externals')
    warning('on','MATLAB:MKDIR:DirectoryExists')
    unzip('master.zip','../externals')
    delete('master.zip')
    addpath([pwd() '/../externals/dates-master/src'])
    initialize_dates_toolbox;
end

% Get the path to the dseries toolbox.
dseries_src_root = strrep(which('initialize_dseries_toolbox'),'initialize_dseries_toolbox.m','');

% Add some subfolders to the path.
addpath([dseries_src_root '/read'])
addpath([dseries_src_root '/utilities/is'])
addpath([dseries_src_root '/utilities/str'])
addpath([dseries_src_root '/utilities/insert'])
addpath([dseries_src_root '/utilities/file'])
addpath([dseries_src_root '/utilities/from'])
addpath([dseries_src_root '/utilities/variables'])
addpath([dseries_src_root '/utilities/cumulate'])

% Add missing routines if dynare is not in the path
if ~exist('demean','file')
    addpath([dseries_src_root '/utilities/missing/demean'])
end

if ~exist('ndim','file')
    addpath([dseries_src_root '/utilities/missing/ndim'])
end

if ~exist('sample_hp_filter','file')
    addpath([dseries_src_root '/utilities/missing/sample_hp_filter'])
end

if ~exist('user_has_octave_forge_package','file')
    addpath([dseries_src_root '/utilities/missing/user_has_octave_forge_package'])
end

if ~exist('get_cells_id','file')
    addpath([dseries_src_root '/utilities/missing/get_cells_id'])
end

dseries('initialize');