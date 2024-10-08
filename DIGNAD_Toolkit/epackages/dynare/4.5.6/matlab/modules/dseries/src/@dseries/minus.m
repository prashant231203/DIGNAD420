function A = minus(B,C) % --*-- Unitary tests --*--

%@info:
%! @deftypefn {Function File} {@var{A} =} minus (@var{B},@var{C})
%! @anchor{@dseries/minus}
%! @sp 1
%! Overloads the minus method for the Dynare time series class (@ref{dseries}).
%! @sp 2
%! @strong{Inputs}
%! @sp 1
%! @table @ @var
%! @item B
%! Dynare time series object instantiated by @ref{dseries}.
%! @item C
%! Dynare time series object instantiated by @ref{dseries}.
%! @end table
%! @sp 1
%! @strong{Outputs}
%! @sp 1
%! @table @ @var
%! @item A
%! Dynare time series object.
%! @end deftypefn
%@eod:

% Copyright (C) 2012-2014, Dynare Team
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

if isnumeric(B) && (isscalar(B) ||  isvector(B))
    if ~isdseries(C)
        error('dseries::minus: Second input argument must be a dseries object!')
    end
    A = C;
    A.data = bsxfun(@minus,B,C.data);
    return;
end

if isnumeric(C) && (isscalar(C) || isvector(C))
    if ~isdseries(B)
        error('dseries::minus: First input argument must be a dseries object!')
    end
    A = B;
    A.data = bsxfun(@minus,B.data,C);
    return
end

if ~isequal(vobs(B), vobs(C)) && ~(isequal(vobs(B),1) || isequal(vobs(C),1))
    error(['dseries::minus: Cannot substract ' inputname(1) ' and ' inputname(2) ' (wrong number of variables)!'])
else
    if vobs(B)>vobs(C)
        idB = 1:vobs(B);
        idC = ones(1:vobs(B));
    elseif vobs(B)<vobs(C)
        idB = ones(1,vobs(C));
        idC = 1:vobs(C);
    else
        idB = 1:vobs(B);
        idC = 1:vobs(C);
    end
end

if ~isequal(frequency(B),frequency(C))
    error(['dseries::plus: Cannot substract ' inputname(1) ' and ' inputname(2) ' (frequencies are different)!'])
end

if ~isequal(nobs(B), nobs(C)) || ~isequal(firstdate(B),firstdate(C))
    [B, C] = align(B, C);
end

if isempty(B)
    A = -C;
    return
end

if isempty(C)
    A = B;
    return
end

A = dseries();

A.dates = B.dates;
A_vobs = max(vobs(B), vobs(C));
A.name = cell(A_vobs,1);
A.tex = cell(A_vobs,1);
for i=1:A_vobs
    A.name(i) = {['minus(' B.name{idB(i)} ';' C.name{idC(i)} ')']};
    A.tex(i) = {['(' B.tex{idB(i)} '-' C.tex{idC(i)} ')']};
end
A.data = bsxfun(@minus,B.data,C.data);

%@test:1
%$ % Define a datasets.
%$ A = rand(10,2); B = randn(10,1);
%$
%$ % Define names
%$ A_name = {'A1';'A2'}; B_name = {'B1'};
%$
%$ t = zeros(5,1);
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    ts2 = dseries(B,[],B_name,[]);
%$    ts3 = ts1-ts2;
%$    t(1) = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ if length(t)>1
%$    t(2) = dassert(ts3.vobs,2);
%$    t(3) = dassert(ts3.nobs,10);
%$    t(4) = dassert(ts3.data,[A(:,1)-B, A(:,2)-B],1e-15);
%$    t(5) = dassert(ts3.name,{'minus(A1;B1)';'minus(A2;B1)'});
%$ end
%$ T = all(t);
%@eof:1

%@test:3
%$ % Define a datasets.
%$ A = rand(10,2); B = randn(5,1);
%$
%$ % Define names
%$ A_name = {'A1';'A2'}; B_name = {'B1'};
%$
%$ t = zeros(5,1);
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    ts2 = dseries(B,[],B_name,[]);
%$    ts3 = ts1-ts2;
%$    t(1) = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ if length(t)>1
%$    t(2) = dassert(ts3.vobs,2);
%$    t(3) = dassert(ts3.nobs,10);
%$    t(4) = dassert(ts3.data,[A(1:5,1)-B(1:5), A(1:5,2)-B(1:5) ; NaN(5,2)],1e-15);
%$    t(5) = dassert(ts3.name,{'minus(A1;B1)';'minus(A2;B1)'});
%$ end
%$ T = all(t);
%@eof:3

%@test:4
%$ ts1 = dseries(ones(3,1));
%$ ts2 = ts1-1;
%$ ts3 = 2-ts1;
%$ t(1) = isequal(ts2.data, zeros(3,1));
%$ t(2) = isequal(ts3.data, ts1.data);
%$ T = all(t);
%@eof:4

%@test:5
%$ ts1 = dseries(ones(3,2));
%$ ts2 = ts1-1;
%$ ts3 = 2-ts1;
%$ t(1) = isequal(ts2.data, zeros(3,2));
%$ t(2) = isequal(ts3.data, ts1.data);
%$ T = all(t);
%@eof:5

%@test:6
%$ ts1 = dseries(ones(3,2));
%$ ts2 = ts1-ones(3,1);
%$ ts3 = 2*ones(3,1)-ts1;
%$ t(1) = isequal(ts2.data, zeros(3,2));
%$ t(2) = isequal(ts3.data, ts1.data);
%$ T = all(t);
%@eof:6

%@test:7
%$ ts1 = dseries(ones(3,2));
%$ ts2 = ts1-ones(1,2);
%$ ts3 = 2*ones(1,2)-ts1;
%$ t(1) = isequal(ts2.data, zeros(3,2));
%$ t(2) = isequal(ts3.data, ts1.data);
%$ T = all(t);
%@eof:7
