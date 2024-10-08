function scaleout = fn_imcerrgraph(imf,firstl,firsth,nvar,imstp,xlab,ylab,indxGimfml,xTick,indx_num)
% scaleout = fn_imcerrgraph(imf,firstl,firsth,nvar,imstp,xlab,ylab,indxGimfml,xTick)
%     imcerrgraph: impulse, c (column: shock 1 to N), 1 error band, graph
%
%  imf:  imstp-by-nvar^2 matrix of impulse responses.  Column (responses to 1st shock, responses to 2nd shock
%            etc), Row (impusle steps),
%  firstl: lower band
%  highth: high band
%  nvar: number of variables
%  imstp:  number of steps of impulse responses
%  xlab,ylab:   labels
%  indxGimfml:  1, graph; 0, no graph
%  xTick:  optional.  Eg: [12 24 36].
%  indx_num: 0: no number on either axis (default), 1: number on both x-axis and y-axis.
%---------------
%  scaleout: column 1 represents maximums; column 2 minimums.  Rows: nvar variables.
%
%  See fn_imcgraph, fn_imc2errgraph, imrerrgraph
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


if nargin < 9, xTick = []; end
if nargin < 10, indx_num = 0; end

t = 1:imstp;
temp1=zeros(nvar,1);
temp2=zeros(nvar,1);
maxval=zeros(nvar,1);
minval=zeros(nvar,1);
for i = 1:nvar
	for j = 1:nvar
		temp1(j)=max(firsth(:,(j-1)*nvar+i));
		temp2(j)=min(firstl(:,(j-1)*nvar+i));
	end
   maxval(i)=max(temp1);
   minval(i)=min(temp2);
end

scaleout = [maxval(:) minval(:)];

%--------------
%  Column j: Shock 1 to N; Row i: Responses to
%-------------
if indxGimfml
   %figure
   rowlabel = 1;
   for i = 1:nvar
      columnlabel = 1;

      if minval(i)<0
         if maxval(i)<=0
            yt=[minval(i) 0];
         else
            yt=[minval(i) 0 maxval(i)];
         end
      else % (minval(i) >=0)
         if maxval(i) > 0
            yt=[0 maxval(i)];
         else % (identically zero responses)
            yt=[-1 0 1];
         end
      end

      scale=[1 imstp minval(i) maxval(i)];
      for j = 1:nvar
         k1=(i-1)*nvar+j;
         k2=(j-1)*nvar+i;
         subplot(nvar,nvar,k1)
         plot(t,imf(:,k2),t,[firstl(:,k2) firsth(:,k2)],'--',...
                                    t,zeros(length(imf(:,k2)),1),'-');

         set(gca,'XTick',xTick)
         set(gca,'YTick',yt)
         grid

         axis(scale);   % put limits on both axes.
         %set(gca,'YLim',[minval(i) maxval(i)])
         if (indx_num==0)     % no numbers on axes
            set(gca,'XTickLabel',' ');
            set(gca,'YTickLabel',' ');
%        elseif (indx_num==1)   %numbers on x-axis.
%           if i<nvar
%              set(gca,'XTickLabelMode','manual','XTickLabel',[])
%           end
         else   % put numbers on both axes
            if i<nvar
               set(gca,'XTickLabelMode','manual','XTickLabel',[])
            end
            if j>1
               set(gca,'YTickLabel',' ');
            end
         end

         if rowlabel == 1
            %title(['x' num2str(j)])
            %title(eval(['x' num2str(j)]))
            title(char(xlab(j)))
         end
         if columnlabel == 1
            %ylabel(['x' num2str(i)])
            %ylabel(eval(['x' num2str(i)]))
            ylabel(char(ylab(i)))
         end
         columnlabel = 0;
      end
      rowlabel = 0;
   end
end
