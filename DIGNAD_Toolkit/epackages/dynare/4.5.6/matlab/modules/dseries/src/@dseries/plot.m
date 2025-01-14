function h = plot(ts, varargin)

% Overloads Matlab/Octave's plot function for dseries objects.

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

% Get the number of dseries objects
if isequal(nargin,1)
    ndseries = 1;
    nvariables = vobs(ts);
    nobservations = nobs(ts);
else
    if isdseries(varargin{1})
        ndseries = 2;
        nvariables = vobs(ts);
        nobservations = nobs(ts);
        if nargin>2 && any(cellfun(@isdseries,varargin(2:end)))
            error('dseries::plot: You cannot pass more two dseries objects!')
        end
        if ~isequal(nvariables, vobs(varargin{1}))
            error('dseries::plot: The two dseries objects must have the same number of variables!')
        end
        if ~isequal(nobservations, nobs(varargin{1}))
            error('dseries::plot: The two dseries objects must have the same number of observations!')
        end
    else
        ndseries = 1;
        nvariables = vobs(ts);
        nobservations = nobs(ts);
    end
end

switch ndseries
  case 1
    if isequal(nvariables,1)
        hh = plot(ts.data,varargin{:});
    else
        if length(varargin)
            message = sprintf('dseries::plot: dseries object %s has %d>1 variables but you passed additional arguments to the plot function.\n                        These additional arguments won''t ne interpreted. Use the Matlab/Octave set command and the plot\n                        handle instead if you wish to modify the properties of the plotted time series.',inputname(1),nvariables);
            warning(message)
        end
        hh = plot(ts.data);
    end
    axis tight;
    id = get(gca,'XTick');
    if isequal(id(1),0)
        dates = strings([ts.dates(1)-1,ts.dates(id(2:end))]);
    else
        dates = strings(ts.dates(id));
    end
    set(gca,'XTickLabel',dates);
  case 2
    [ts0, ts1] = align(ts, varargin{1});
    if isequal(nvariables,1)
        hh = plot(ts0.data, ts1.data, varargin{2:end});
    else
        if length(varargin)>1
            message = sprintf('dseries::plot: dseries objects %s and %s have %d>1 variables but you passed additional arguments to the plot function.\n                        These additional arguments won''t ne interpreted. Use the Matlab/Octave set command and the plot\n                        handle instead if you wish to modify the properties of the plotted time series.',inputname(1),inputname(2),nvariables);
            warning(message)
        end
        hh = plot(ts0.data, ts1.data);
    end
  otherwise
    error('dseries::plot: This is a bug! Please report the bug to the authors of Dynare.')
end

if nargout
    h = hh;
end