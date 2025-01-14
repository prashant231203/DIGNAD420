function m = strings(dd)

% Returns a cell array of strings containing the dates
%
% INPUTS
%   o dd   dates object
%
% OUTPUTS
%   o m    cell array of strings
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2013-2017 Dynare Team
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

m = cell(1,dd.ndat);

for i = 1:dd.ndat
    m(i) = { date2string(dd.time(i,:), dd.freq) };
end