function sglpl(pl,pos,fig)
%function sglpl(pl,pos,fig)
%   Single-trace plot of curves
%   from a pl structure with the following possible fields: 
%
%  pl.xdata{ncur}    pl.ydata{ncur}   pl.color{ncur} pl.linewidth{ncur}
%  pl.xgrid   pl.xlim    pl.xscale     pl.ygrid    pl.ylim    pl.yscale
%  pl.font.axis
%  pl.title    pl.font.title  
%  pl.xlabel   pl.font.xlabel   pl.ylabel    pl.font.ylabel
%  pl.legendu{icur}   pl.font.legendu
%  pl.legendl{icur}   pl.font.legendl
%  pl.legend_color{ncur}    pl.legend_linewidth{ncur}
%
% SEE ALSO: gra pldef
%
% EXAMPLES:
%
% pl=[];
% pl.xdata={1:100 1:100 1:100}; 
% pl.ydata={rand(1,100) rand(1,100) rand(1,100)}; 
% sglpl(pl)
%
%JM01

iarg=1;
if nargin<iarg; pl=[]; end; iarg=iarg+1;
if nargin<iarg; pos=[]; end; iarg=iarg+1;
if nargin<iarg; fig=[]; end; iarg=iarg+1;
if nargin<iarg; op=[]; end; iarg=iarg+1;

if isempty(fig); fig=gcf; end;
if isempty(pos);
  pos=[0 0 1 1];
  pl=pldef(pl,pos);
end;
ncur=length(pl.ydata);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        principal axes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%haxes=axes('position',[pos(1)+.15*pos(3) pos(2)+.12*pos(4) ...
%    .64*pos(3) .74*pos(4)],'drawmode','fast');
% haxes=axes('position',[pos(1) pos(2) 0.79*pos(3) pos(4)],'drawmode','fast');
% 2016: Warning: The DrawMode property will be removed in a future release. Use the
% SortMethod property instead. 'childorder'
haxes=axes('position',[pos(1) pos(2) 0.79*pos(3) pos(4)],'SortMethod','childorder');

set(haxes,'units','points');
posc=get(haxes,'position');
hyl=pl.font.ylabel*size(pl.ylabel,1)+get(haxes,'fontsize')*2;
hxl=pl.font.xlabel*size(pl.xlabel,1)+get(haxes,'fontsize')*2.5;
hti=pl.font.title*(size(pl.title,1)+1.5);
set(haxes,'position',[posc(1)+30+hyl posc(2)+hxl posc(3)-30-hyl posc(4)-hxl-hti]);
set(haxes,'units','normalized');
pos1=get(haxes,'position');
hold on;
for icur=1:ncur
  hline=plot(pl.xdata{icur},pl.ydata{icur},pl.color{icur});
  set(hline,'LineWidth',pl.linewidth{icur});
end; 
hold off;
set(haxes,'FontSize',pl.font.axis,'XGrid',pl.xgrid,'XScale',pl.xscale, ...
  'YGrid',pl.ygrid,'YScale',pl.yscale);
if ~isempty(pl.xlim); set(haxes,'XLim',pl.xlim); end;
if ~isempty(pl.ylim); set(haxes,'YLim',pl.ylim); end;
title(compact(pl.title),'FontSize',pl.font.title);
xlabel(compact(pl.xlabel),'FontSize',pl.font.xlabel);
ylabel(compact(pl.ylabel),'FontSize',pl.font.ylabel,'verticalalignment','bottom');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         legend on the right hand
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%hax2=axes('position',[pos(1)+.82*pos(3) pos(2)+.30*pos(4) ...
%    .16*pos(3) .56*pos(4)]);
hax2=axes('position',[pos1(1)+1.03*pos1(3) pos1(2)+0.20*pos1(4) ...
    pos(1)+pos(3)-pos1(1)-1.06*pos1(3) 0.77*pos1(4)]);
hold on;
if ncur>1
  for icur=1:ncur;
    text(.5,(0.99-(icur-1)/ncur),compact(pl.legendu{icur}),...
      'horizontalalignment','center',...
      'verticalalignment','bottom',...
      'fontsize',pl.font.legendu);
    text(.5,(0.99-(icur-1)/ncur),compact(pl.legendl{icur}),...
      'horizontalalignment','center',...
      'verticalalignment','top',...
      'fontsize',pl.font.legendl);
    hline=plot([0 1],(0.99-(icur-1)/ncur)*[1 1],pl.legend_color{icur});
    set(hline,'LineWidth',pl.legend_linewidth{icur});
  end;
end
hold off;
axis([0 1 0 1]);
set(hax2,'visible','off');

axes(haxes)
return





function str=compact(str)
str=cellstr(str);
str=char({str{:} '-'});
for i=size(str,1):-1:1;
  if isempty(deblank(str(i,:))); str(i,:)=[]; end;
end
str=str(1:(size(str,1)-1),:);
return


