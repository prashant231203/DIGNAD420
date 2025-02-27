function [P,H0inv,Hpinv] = rlrpostr(xtx,xty,yty,Ptld,H0invtld,Hpinvtld,Ui,Vi)
% [P,H0inv,Hpinv] = rlrpostr(xtx,xty,yty,Ptld,H0tld,Hptld,Ui,Vi)
%
%    Exporting random Bayesian posterior matrices with linear restrictions
%    See Waggoner and Zha's Gibbs sampling paper
%
% xtx:  X'X: k-by-k where k=ncoef
% xty:  X'Y: k-by-nvar
% yty:  Y'Y: nvar-by-nvar
% Ptld: cell(nvar,1), linear transformation for random walk prior for the ith equation
% H0invtld: cell(nvar,1), transformed inv covaraince for free parameters in A0(:,i).
% Hpinvtld: cell(nvar,1), transformed inv covaraince for free parameters in A+(:,i);
% Ui: nvar-by-1 cell.  In each cell, nvar-by-qi orthonormal basis for the null of the ith
%           equation contemporaneous restriction matrix where qi is the number of free parameters.
%           With this transformation, we have ai = Ui*bi or Ui'*ai = bi where ai is a vector
%           of total original parameters and bi is a vector of free parameters. When no
%           restrictions are imposed, we have Ui = I.  There must be at least one free
%           parameter left for the ith equation.  Imported from dnrprior.m.
% Vi: nvar-by-1 cell.  In each cell, k-by-ri orthonormal basis for the null of the ith
%           equation lagged restriction matrix where k (ncoef) is a total number of RHS variables and
%           ri is the number of free parameters. With this transformation, we have fi = Vi*gi
%           or Vi'*fi = gi where fi is a vector of total original parameters and gi is a
%           vector of free parameters. There must be at least one free parameter left for
%           the ith equation.  Imported from dnrprior.m.
%-----------------
% P: cell(nvar,1).  In each cell, posterior linear transformation for random walk prior for the ith equation % tld: tilda
% H0inv: cell(nvar,1).  In each cell, posterior inverse of covariance inv(H0) for the ith equation,
%           resembling old SpH in the exponent term in posterior of A0, but not divided by T yet.
% Hpinv: cell(nvar,1).  In each cell, posterior inv(Hp) for the ith equation.
%
% Tao Zha, February 2000
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

nvar = size(yty,1);

P = cell(nvar,1); % tld: tilda
H0inv = cell(nvar,1);  % posterior inv(H0), resemble old SpH, but not divided by T yet.
Hpinv = cell(nvar,1);  % posterior inv(Hp).


for n=1:nvar       % one for each equation
   Hpinv{n} = Vi{n}'*xtx*Vi{n} + Hpinvtld{n};
   P1 = Vi{n}'*xty*Ui{n} + Hpinvtld{n}*Ptld{n};
   P{n} = Hpinv{n}\P1;
   H0inv{n} =  Ui{n}'*yty*Ui{n} + H0invtld{n} + Ptld{n}'*Hpinvtld{n}*Ptld{n} ...
                   - P1'*(Hpinv{n}\P1);
end
