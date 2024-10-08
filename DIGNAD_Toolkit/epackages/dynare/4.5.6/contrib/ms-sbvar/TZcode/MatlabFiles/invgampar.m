function f = invgampar(ab, XLO, XUP, PLO, PUP);

% The function takes as inputs the parameters ab=[a, b] of the Inverse gamma
% distribution, the bounds of the support [XLO, XUP], the the corresponding
% probability of the bounds [PLO, PUP] and returns the residual value f.

%
% Copyright (C) 1997-2012 Tao Zha
%
% This free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% It is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% If you did not received a copy of the GNU General Public License
% with this software, see <http://www.gnu.org/licenses/>.
%

a = ab(1); b = ab(2);
f1 = PLO - invgamcdf(XLO, a, b);
f2 = PUP - invgamcdf(XUP, a, b);

f = [f1, f2];
