function fig=gra(gr,orientation,fig,pos)
%fig=gra(gr,orientation,fig,pos)
%   Multiple-trace graph of ELSA Data Base signals
%   from a gr structure with the following possible fields: 
%
%  gr.grheader    gr.font.grheader  gr.grfooter    gr.font.grfooter  
%  gr.xgrid   gr.xlim    gr.xscale     gr.ygrid    gr.ylim    gr.yscale
%  gr.points{:} % Jul-2004
%  gr.font.axis
%  gr.title    gr.font.title  
%  gr.xlabel   gr.font.xlabel   gr.ylabel    gr.font.ylabel
%  gr.font.legendu
%  gr.font.legendl
%  gr.op.colorlist  gr.op.linewidthlist
%  gr.op.title.format gr.op.title.proplist
%
%  gr.pl{:}.xsig{:}  gr.pl{:}.ysig{:}
%  gr.pl{:}.xpart{:}  gr.pl{:}.ypart{:}      Dec-2001   = ' ';'(Re)';'(Im)';'(Amp)';'(Pha)'
%  gr.pl{:}.color{:} gr.pl{:}.linewidth{:}
%  gr.pl{:}.xgrid   gr.pl{:}.xlim    gr.pl{:}.xscale 
%  gr.pl{:}.ygrid   gr.pl{:}.ylim    gr.pl{:}.yscale
%  gr.pl{:}.points{:} % Jul-2004
%  gr.pl{:}.font.axis
%  gr.pl{:}.title    gr.pl{:}.font.title  
%  gr.pl{:}.xlabel   gr.pl{:}.font.xlabel   gr.pl{:}.ylabel    gr.pl{:}.font.ylabel
%  gr.pl{:}.legendu{icur}   gr.pl{:}.font.legendu
%  gr.pl{:}.legendl{icur}   gr.pl{:}.font.legendl
%  gr.pl{:}.legend_color{ncur}    gr.pl{:}.legend_linewidth{ncur}
%  gr.pl{:}.op.colorlist   gr.pl{:}.op.linewidthlist
%
% SEE ALSO: mgra getsig selst grdef sglpl
%
% EXAMPLES:
%
% s.Project='uWalls';
% s.Structure='Wall 4';
% s.Experiment='w14';
% s.PostProcessing='60';
% s.Signal={'000' '001' '002'};
% sig=getsig(s);
% gr=[];
% gr.pl{1}.ysig=sig(1);
% gr.pl{2}.ysig=sig(2:3);
% gr.pl{3}.ysig=sig([2 2]);
% gra(gr);
% sig1=sst(sig,'Project','newproject');
% sig1=sst(sig1,'Experiment','newexperiment');
% sig1=sst(sig1,'Positions',{{'Level 1'; '2'; '3'; '4'; '5'}});
% gr=[];
% gr.pl{1}.xsig=sig1([2 2]);
% gr.pl{1}.ysig=sig([2 2]);
% gra(gr);
%
%s = [];
%s.Project='Dual Frame';
%s.Structure='Dual Frame CFRP';
%s.Experiment='d08';
%s.PostProcessing='62';
%
%s=struct('Project','Dual Frame','Structure','Dual Frame CFRP', ...
%  'Experiment','d08','PostProcessing','62');
% s.Signal={};
% sig=getsig(s);
% gr=[]; gr.pl{1}.ysig=sig(6:9); gr.pl{1}.xsig=sig(2:5); gra(gr);
%
%s.Experiment='d09';
% sig1=getsig(s);
% gr=[];
% gr.pl{1}.ysig={sig{6} sig1{6}};
% gr.pl{1}.xsig={sig{2} sig1{2}};
% gr.pl{2}.ysig={sig{7} sig1{7}};
% gr.pl{2}.xsig={sig{3} sig1{3}};
% gra(gr);
%
%JM01

iarg=1;
if nargin<iarg; gr=[]; end; iarg=iarg+1;
if nargin<iarg; orientation=[]; end; iarg=iarg+1;
if nargin<iarg; fig=[]; end; iarg=iarg+1;
if nargin<iarg; pos=[]; end; iarg=iarg+1;



if isempty(pos);
  gr=grdef(gr);
  pos=[0 0 1 1];
  if isempty(orientation);
    if length(gr.pl)>1
      orientation='portrait';
    else
      orientation='landscape';
    end 
  end;
  orientation=lower(orientation);
  if orientation=='p'; orientation='portrait'; end;
  if orientation=='l'; orientation='landscape'; end;
  if ~isempty(fig)
    figure(fig);
  else;
    fig=figure;
  end;
  clf reset;
  
  set(fig,'UserData',gr);   %8-3-2002
  
  switch orientation
  case 'landscape'
    margl=.02;  margr=0.12;  margb=.08;  margt=.08;
    set(fig,'units','normalized','position',[.1 .1 .56 .56]);
  case 'portrait'
    margl=.05;  margr=.1;  margb=.06;  margt=.1;
    set(fig,'units','normalized','position',[.1 .1 .4 .8]);
  otherwise
    error(['Orientation ' orientation ' is not valid']);
  end;
  set(fig,'paperorientation',orientation,'papertype','a4letter');
  psi=get(fig,'papersize');
  set(fig,'paperposition',[margl*psi(1) margb*psi(2) ...
      (1-margl-margr)*psi(1) (1-margb-margt)*psi(2)]);
  nam=compact(gr.grheader);
  if size(nam,1)>0; nam=nam(1,:); end;
  set(fig,'name',['gra:' nam]);
else;
  if isempty(fig); fig=gcf; end;
end;
gr.grheader=compact(gr.grheader);
gr.grfooter=compact(gr.grfooter);
if isempty(gr.font.grheader);
  gr.font.grheader=min(16,20*pos(3)*54/max(1,size(gr.grheader,2)));
end;
if isempty(gr.font.grfooter);
  gr.font.grfooter=min(14,20*pos(3)*54/max(1,size(gr.grfooter,2)));
end;

if isempty(gr.font.grfooter); gr.font.grfooter=12; end;
axestemp=axes('position',pos,'fontsize',max(gr.font.grheader,gr.font.grfooter));
set(axestemp,'units','points','visible','off');
posc=get(axestemp,'position');
hhe=gr.font.grheader*size(gr.grheader,1)+10; hfo=gr.font.grfooter*size(gr.grfooter,1);
set(axestemp,'position',[posc(1) posc(2)+hfo posc(3) posc(4)-hfo-hhe]);
text(.5,1,gr.grheader,'horizontalalignment','center',...
    'verticalalignment','bottom','fontsize',gr.font.grheader);
text(.5,0,gr.grfooter,'horizontalalignment','center',...
    'verticalalignment','top','fontsize',gr.font.grfooter);
set(axestemp,'units','normalized');
pos=get(axestemp,'position');

npl=length(gr.pl);
siz1ti=0; siz1xl=0; siz1yl=0;
for ipl=1:npl;
  pospl=[pos(1) pos(2)+pos(4)*(npl-ipl)/npl pos(3) pos(4)/npl];
  gr.pl{ipl}=pldef(gr.pl{ipl},pospl);
  siz1ti=max(siz1ti,size(gr.pl{ipl}.title,1));
  siz1xl=max(siz1xl,size(gr.pl{ipl}.xlabel,1));
  siz1yl=max(siz1yl,size(gr.pl{ipl}.ylabel,1));
end 
gr.pl=sst(gr.pl,'font.axis',min(cell2mat(gst(gr.pl,'font.axis')))); %Common font size
gr.pl=sst(gr.pl,'font.title',min(cell2mat(gst(gr.pl,'font.title'))));
gr.pl=sst(gr.pl,'font.xlabel',min(cell2mat(gst(gr.pl,'font.xlabel'))));
gr.pl=sst(gr.pl,'font.ylabel',min(cell2mat(gst(gr.pl,'font.ylabel'))));
bla=' ';
for ipl=1:npl;
  pospl=[pos(1) pos(2)+pos(4)*(npl-ipl)/npl pos(3) pos(4)/npl];
  for i=(size(gr.pl{ipl}.title,1)+1):siz1ti;
    gr.pl{ipl}.title(i,:)=bla(ones(1,size(gr.pl{ipl}.title,2)));
  end;
  for i=(size(gr.pl{ipl}.xlabel,1)+1):siz1xl;
    gr.pl{ipl}.xlabel(i,:)=bla(ones(1,size(gr.pl{ipl}.xlabel,2)));
  end;
  for i=(size(gr.pl{ipl}.ylabel,1)+1):siz1yl;
    gr.pl{ipl}.ylabel(i,:)=bla(ones(1,size(gr.pl{ipl}.ylabel,2)));
  end;
  sglpl(gr.pl{ipl},pospl,fig);
end
return



function str=compact(str)
str=cellstr(str);
str=char({str{:} '-'});
for i=size(str,1):-1:1;
  if isempty(deblank(str(i,:))); str(i,:)=[]; end;
end
str=str(1:(size(str,1)-1),:);
return

