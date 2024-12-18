function pl=pldef(pl,pos)
%pl=pldef(pl,pos)
%    Fills in the default values of pl structure within function sglpl.
%
%  pl.xdata{ncur}    pl.ydata{ncur}   pl.color{ncur} pl.linewidth{ncur}
%  pl.xgrid   pl.xlim    pl.xscale     pl.ygrid    pl.ylim    pl.yscale
%  pl.font.axis
%  pl.title    pl.font.title  
%  pl.xlabel   pl.font.xlabel   pl.ylabel    pl.font.ylabel
%  pl.legendu{icur}   pl.font.legendu
%  pl.legendl{icur}   pl.font.legendl
%  pl.legend_color{ncur}    pl.legend_linewidth{ncur}
%  pl.op.colorlist pl.op.linewidthlist
%
% SEE ALSO: sglpl gra grdef
% 
%JM01

iarg=1;
if nargin<iarg; pl=[]; end; iarg=iarg+1;
if nargin<iarg; pos=[]; end; iarg=iarg+1;

fie={'xdata','ydata','color','linewidth','xgrid', ...
    'xlim','xscale','ygrid','ylim','yscale', ...
    'title','xlabel','ylabel','legendu','legendl', ...
    'legend_color','legend_linewidth','font','op'};
for ifie=1:length(fie)
  eval(['if ~isfield(pl,''' fie{ifie} '''); pl.' fie{ifie} '=''''; end;']);
end
if ~isfield(pl.font,'axis'); pl.font.axis=''; end;
if ~isfield(pl.font,'title'); pl.font.title=''; end;
if ~isfield(pl.font,'xlabel'); pl.font.xlabel=''; end;
if ~isfield(pl.font,'ylabel'); pl.font.ylabel=''; end;
if ~isfield(pl.font,'legendu'); pl.font.legendu=''; end;
if ~isfield(pl.font,'legendl'); pl.font.legendl=''; end;
if ~isfield(pl.op,'colorlist'); pl.op.colorlist=''; end;
if ~isfield(pl.op,'linewidthlist'); pl.op.linewidthlist=''; end;

if isempty(pl.op.colorlist);
  pl.op.colorlist={'b-' 'r-' 'g-' 'k-' 'm-' 'b:' 'r:' 'g:' 'k:' 'm:'};
end;
colorlist=pl.op.colorlist;
lendefcol=length(colorlist);
if isempty(pl.op.linewidthlist);
%  pl.op.linewidthlist={0.5};
  pl.op.linewidthlist={1};   %2015
end;
linewidthlist=pl.op.linewidthlist;
lendeflw=length(linewidthlist);

ncur=length(pl.ydata);

if length(pl.color)<ncur;
  for icur=(length(pl.color)+1):ncur;
    pl.color{icur}=colorlist{1+mod(icur-1,lendefcol)};
  end;
end;
if length(pl.linewidth)<ncur;
  for icur=(length(pl.linewidth)+1):ncur;
    pl.linewidth{icur}=linewidthlist{1+mod(icur-1,lendeflw)};
  end;
end;
if isempty(pl.xgrid);pl.xgrid='on'; end;
if isempty(pl.ygrid);pl.ygrid='on'; end;
if isempty(pl.xscale);pl.xscale='linear'; end;
if isempty(pl.yscale);pl.yscale='linear'; end;
if length(pl.legendu)<ncur;
  for icur=(length(pl.legendu)+1):ncur;
    pl.legendu{icur}='';
  end;
end;
if length(pl.legendl)<ncur;
  for icur=(length(pl.legendl)+1):ncur;
    pl.legendl{icur}='';
  end;
end;
pl.title=compact(pl.title);
pl.xlabel=compact(pl.xlabel);
pl.ylabel=compact(pl.ylabel);
  for icur=1:ncur;
    pl.legendu{icur}=compact(pl.legendu{icur});
    pl.legendl{icur}=compact(pl.legendl{icur});
  end;

if isempty(pl.font.axis);pl.font.axis=min(12,16*pos(3)); end;
if isempty(pl.font.title);
  pl.font.title=min(16,20*pos(3)*54/max(1,size(pl.title,2)));
end;
fsiz=min(10,27*pos(3)*30/max(1,size(pl.xlabel,2)));
fsiz=min(fsiz,27*pos(4)*30/max(1,size(pl.ylabel,2)));
if isempty(pl.font.xlabel);pl.font.xlabel=fsiz; end;
if isempty(pl.font.ylabel);pl.font.ylabel=fsiz; end;
fsizu=8; fsizl=8;
for icur=1:ncur;
  fsizu=min(fsizu,19*pos(3)*15/max(1,size(pl.legendu{icur},2)));
  fsizl=min(fsizl,19*pos(3)*15/max(1,size(pl.legendl{icur},2)));
end;
if isempty(pl.font.legendu);pl.font.legendu=fsizu; end;
if isempty(pl.font.legendl);pl.font.legendl=fsizl; end;


if length(pl.legend_color)<ncur;
  pl.legend_color=pl.color;
end;
if length(pl.legend_linewidth)<ncur;
  pl.legend_linewidth=pl.linewidth;
end;


function str=compact(str)
str=cellstr(str);
str=char({str{:} '-'});
for i=size(str,1):-1:1;
  if isempty(deblank(str(i,:))); str(i,:)=[]; end;
end
str=str(1:(size(str,1)-1),:);
return





