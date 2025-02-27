function [fhat,xhat,fcount,retcode] = csminit(fcn,x0,f0,g0,badg,H0,varargin)
% [fhat,xhat,fcount,retcode] = csminit(fcn,x0,f0,g0,badg,H0,...
%                                       P1,P2,P3,P4,P5,P6,P7,P8)
% retcodes: 0, normal step.  5, largest step still improves too fast.
% 4,2 back and forth adjustment of stepsize didn't finish.  3, smallest
% stepsize still improves too slow.  6, no improvement found.  1, zero
% gradient.
%---------------------
% Modified 7/22/96 to omit variable-length P list, for efficiency and compilation.
% Places where the number of P's need to be altered or the code could be returned to
% its old form are marked with ARGLIST comments.
%
% Fixed 7/17/93 to use inverse-hessian instead of hessian itself in bfgs
% update.
%
% Fixed 7/19/93 to flip eigenvalues of H to get better performance when
% it's not psd.
% NOTE:  The display on screen can be turned off by seeting dispIndx=0 in this
%         function.  This option is used for the loop operation.  T. Zha, 2 May 2000

%
% Copyright (C) 1997-2012 Christopher A. Sims
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

dispIndx = 0;   % 1: turn on all the diplays on the screen; 0: turn off (Added by T. Zha)

%
%tailstr = ')';
%for i=nargin-6:-1:1
%   tailstr=[ ',P' num2str(i)  tailstr];
%end

%ANGLE = .01;  % when output of this variable becomes negative, we have wrong analytical graident
ANGLE = .005;  % works for identified VARs and OLS
%THETA = .1;   % works for OLS or other nonlinear functions
THETA = .3; %(0<THETA<.5) THETA near .5 makes long line searches, possibly fewer iterations.
          % workds for identified VARs
FCHANGE = 1000;
MINLAMB = 1e-9;
% fixed 7/15/94
% MINDX = .0001;
% MINDX = 1e-6;
MINDFAC = .01;
fcount=0;
lambda=1;
xhat=x0;
f=f0;
fhat=f0;
g = g0;
gnorm = norm(g);
%
if (gnorm < 1.e-12) & ~badg % put ~badg 8/4/94
   retcode =1;
   dxnorm=0;
   % gradient convergence
else
   % with badg true, we don't try to match rate of improvement to directional
   % derivative.  We're satisfied just to get some improvement in f.
   %
   %if(badg)
   %   dx = -g*FCHANGE/(gnorm*gnorm);
   %  dxnorm = norm(dx);
   %  if dxnorm > 1e12
   %     disp('Bad, small gradient problem.')
   %     dx = dx*FCHANGE/dxnorm;
   %   end
   %else
   % Gauss-Newton step;
   %---------- Start of 7/19/93 mod ---------------
   %[v d] = eig(H0);
   %toc
   %d=max(1e-10,abs(diag(d)));
   %d=abs(diag(d));
   %dx = -(v.*(ones(size(v,1),1)*d'))*(v'*g);
%      toc
   dx = -H0*g;
%      toc
   dxnorm = norm(dx);
   if dxnorm > 1e12
      if dispIndx, disp('Near-singular H problem.'), end
      dx = dx*FCHANGE/dxnorm;
   end
   dfhat = dx'*g0;
   %end
   %
   %
   if ~badg
      % test for alignment of dx with gradient and fix if necessary
      a = -dfhat/(gnorm*dxnorm);
      if a<ANGLE
         dx = dx - (ANGLE*dxnorm/gnorm+dfhat/(gnorm*gnorm))*g;
         dfhat = dx'*g;
         dxnorm = norm(dx);
         if dispIndx, disp(sprintf('Correct for low angle: %g',a)), end
      end
   end
   if dispIndx, disp(sprintf('Predicted improvement: %18.9f',-dfhat/2)), end
   %
   % Have OK dx, now adjust length of step (lambda) until min and
   % max improvement rate criteria are met.
   done=0;
   factor=3;
   shrink=1;
   lambdaMin=0;
   lambdaMax=inf;
   lambdaPeak=0;
   fPeak=f0;
   lambdahat=0;
   while ~done
      if size(x0,2)>1
         dxtest=x0+dx'*lambda;
      else
         dxtest=x0+dx*lambda;
      end
      % home
      f = eval([fcn '(dxtest,varargin{:})']);
      %ARGLIST
      %f = feval(fcn,dxtest,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13);
      % f = feval(fcn,x0+dx*lambda,P1,P2,P3,P4,P5,P6,P7,P8);
      if dispIndx, disp(sprintf('lambda = %10.5g; f = %20.7f',lambda,f )), end
      %debug
      %disp(sprintf('Improvement too great? f0-f: %g, criterion: %g',f0-f,-(1-THETA)*dfhat*lambda))
      if f<fhat
         fhat=f;
         xhat=dxtest;
         lambdahat = lambda;
      end
      fcount=fcount+1;
      shrinkSignal = (~badg & (f0-f < max([-THETA*dfhat*lambda 0]))) | (badg & (f0-f) < 0) ;
      growSignal = ~badg & ( (lambda > 0)  &  (f0-f > -(1-THETA)*dfhat*lambda) );
      if  shrinkSignal  &   ( (lambda>lambdaPeak) | (lambda<0) )
         if (lambda>0) & ((~shrink) | (lambda/factor <= lambdaPeak))
            shrink=1;
            factor=factor^.6;
            while lambda/factor <= lambdaPeak
               factor=factor^.6;
            end
            %if (abs(lambda)*(factor-1)*dxnorm < MINDX) | (abs(lambda)*(factor-1) < MINLAMB)
            if abs(factor-1) < MINDFAC
               if abs(lambda)<4
                  retcode = 2;
               else
                  retcode=7;
               end
               done=1;
            end
         end
         if (lambda<lambdaMax) & (lambda>lambdaPeak)
            lambdaMax=lambda;
         end
         lambda=lambda/factor;
         if abs(lambda) < MINLAMB
            if (lambda > 0) & (f0 <= fhat)
               % try going against gradient, which may be inaccurate
               lambda = -lambda*factor^6
            else
               if lambda < 0
                  retcode = 6;
               else
                  retcode = 3;
               end
               done = 1;
            end
         end
      elseif  (growSignal & lambda>0) |  (shrinkSignal & ((lambda <= lambdaPeak) & (lambda>0)))
         if shrink
            shrink=0;
            factor = factor^.6;
            %if ( abs(lambda)*(factor-1)*dxnorm< MINDX ) | ( abs(lambda)*(factor-1)< MINLAMB)
            if abs(factor-1) < MINDFAC
               if abs(lambda)<4
                  retcode = 4;
               else
                  retcode=7;
               end
               done=1;
            end
         end
         if ( f<fPeak ) & (lambda>0)
            fPeak=f;
            lambdaPeak=lambda;
            if lambdaMax<=lambdaPeak
               lambdaMax=lambdaPeak*factor*factor;
            end
         end
         lambda=lambda*factor;
         if abs(lambda) > 1e20;
            retcode = 5;
            done =1;
         end
      else
         done=1;
         if factor < 1.2
            retcode=7;
         else
            retcode=0;
         end
      end
   end
end
if dispIndx, disp(sprintf('Norm of dx %10.5g', dxnorm)), end
