function fig=mgra(m,orientation,fig)
%fig=mgra(m,orientation,fig)
%   Matrix of graphs of ELSA Data Base signals
%   from a m structure with the following possible fields:
%
%  m.mheader    m.font.mheader  m.mfooter    m.font.mfooter
%
%  m.gr{:}.grheader    m.gr{:}.font.grheader  m.gr{:}.grfooter    m.gr{:}.font.grfooter
%  m.gr{:}.xgrid   m.gr{:}.xlim    m.gr{:}.xscale     m.gr{:}.ygrid    m.gr{:}.ylim    m.gr{:}.yscale
%  m.gr{:}.font.axis
%  m.gr{:}.title    m.gr{:}.font.title
%  m.gr{:}.xlabel   m.gr{:}.font.xlabel   m.gr{:}.ylabel    m.gr{:}.font.ylabel
%  m.gr{:}.font.legendu
%  m.gr{:}.font.legendl
%  m.gr{:}.op.colorlist  m.gr{:}.op.linewidthlist
%  m.gr{:}.op.title.format m.gr{:}.op.title.proplist
%
%  m.gr{:}.pl{:}.xsig{:}  m.gr{:}.pl{:}.ysig{:}
%  m.gr{:}.pl{:}.color{ncur} m.gr{:}.pl{:}.linewidth{ncur}
%  m.gr{:}.pl{:}.xgrid   m.gr{:}.pl{:}.xlim    m.gr{:}.pl{:}.xscale
%  m.gr{:}.pl{:}.ygrid   m.gr{:}.pl{:}.ylim    m.gr{:}.pl{:}.yscale
%  m.gr{:}.pl{:}.font.axis
%  m.gr{:}.pl{:}.title    m.gr{:}.pl{:}.font.title
%  m.gr{:}.pl{:}.xlabel   m.gr{:}.pl{:}.font.xlabel   m.gr{:}.pl{:}.ylabel    m.gr{:}.pl{:}.font.ylabel
%  m.gr{:}.pl{:}.legendu{icur}   m.gr{:}.pl{:}.font.legendu
%  m.gr{:}.pl{:}.legendl{icur}   m.gr{:}.pl{:}.font.legendl
%  m.gr{:}.pl{:}.legend_color{ncur}    m.gr{:}.pl{:}.legend_linewidth{ncur}
%  m.gr{:}.pl{:}.op.colorlist   m.gr{:}.pl{:}.op.linewidthlist
%
%
% SEE ALSO: gra getsig selst
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
% gr.pl{1}.ysig=sig(2);
% m=[]; m.gr={gr gr;gr gr};
% mgra(m);
%
%JM01
%
%  8-4-2002: If m.gr is a matrix of figure numbers, multiple graph is built from
%  the single graphs of those figures. Example:
%
% gra(gr,[],1); gra(gr,[],2);
% m=[]; m.gr=[1; 2]; mgra(m);


iarg=1;
if nargin<iarg; m=[]; end; iarg=iarg+1;
if nargin<iarg; orientation=[]; end; iarg=iarg+1;
if nargin<iarg; fig=[]; end; iarg=iarg+1;

if ~iscell(m.gr)    %8-3-2002
    figmatrix=m.gr; m.gr={};
    [nrow,ncol]=size(figmatrix);
    for row=1:nrow;
        for col=1:ncol;
            m.gr{row,col}=get(figmatrix(row,col),'UserData');
        end
    end
end


if ~isfield(m,'mheader'); m.mheader=''; end;
if ~isfield(m,'mfooter'); m.mfooter=''; end;
if ~isfield(m,'font'); m.font=''; end;
if ~isfield(m,'points'); m.points=[]; end;  %2013
if ~isfield(m,'xlim'); m.xlim=[]; end;  %2013
if ~isfield(m,'ylim'); m.ylim=[]; end;  %2013
if ~isfield(m.font,'mheader'); m.font.mheader=''; end;
if ~isfield(m.font,'mfooter'); m.font.mfooter=''; end;
[nrow,ncol]=size(m.gr);
for row=1:nrow;
    for col=1:ncol;
        if ~isfield(m.gr{row,col},'points'); m.gr{row,col}.points=[]; end; %2013
        if isempty(m.gr{row,col}.points); m.gr{row,col}.points=m.points; end; %2013
        if ~isfield(m.gr{row,col},'xlim'); m.gr{row,col}.xlim=[]; end; %2013
        if isempty(m.gr{row,col}.xlim); m.gr{row,col}.xlim=m.xlim; end; %2013
        if ~isfield(m.gr{row,col},'ylim'); m.gr{row,col}.ylim=[]; end; %2013
        if isempty(m.gr{row,col}.ylim); m.gr{row,col}.ylim=m.ylim; end; %2013
        m.gr{row,col}=grdef(m.gr{row,col});
    end
end
ngr=prod(size(m.gr));
if ngr>1 & isempty(m.mheader)  %Common mheader but different grheaders
    heacom={};    %2019_10_08
    for igr=1:ngr;
        if ~isempty(m.gr{igr})     %2019_10_08
            %     if igr==1
            if isempty(heacom)      %2019_10_08
                heacom=m.gr{igr}.grheader;
            else
                heacom=common(m.gr{igr}.grheader,heacom);
            end;
        end     %2019_10_08
    end;
    m.mheader=heacom;
    for igr=1:ngr;
        if ~isempty(m.gr{igr})     %2019_10_08
            m.gr{igr}.grheader=complem(m.gr{igr}.grheader,heacom);
        end
    end;
end
m.mheader=compact(m.mheader);
m.mfooter=compact(m.mfooter);

if isempty(m.font.mheader); m.font.mheader=16; end;
if isempty(m.font.mfooter); m.font.mfooter=14; end;


if isempty(orientation);
    orientation='portrait';
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
if strcmp(orientation,'landscape');
    %   margl=.02;  margr=0.12;  margb=.08;  margt=.08;
    %   margl=.05;  margr=0.05;  margb=.05;  margt=.1;  %2009 Jan Zapico
    margl=.07;  margr=0.05;  margb=.05;  margt=.1;  %2013
    set(fig,'units','normalized','position',[.1 .1 .56 .56]);
else;
    margl=.05;  margr=.1;  margb=.06;  margt=.1;  %2017
    %   margl=.1;  margr=.05;  margb=.05;  margt=.05;   %2009 Jan Zapico
    %   margl=.3;  margr=.05;  margb=.05;  margt=.05;   %2013
    set(fig,'units','normalized','position',[.1 .1 .4 .8]);
end;
set(fig,'paperorientation',orientation,'papertype','A4');
psi=get(fig,'papersize');
set(fig,'paperposition',[margl*psi(1) margb*psi(2) ...
    (1-margl-margr)*psi(1) (1-margb-margt)*psi(2)]);

% set(fig,'PaperPositionMode','auto')    %2013

nam=compact(m.mheader);
if size(nam,1)>0; nam=nam(1,:); end;
set(fig,'name',['mgra:' nam]);
axestemp=axes('position',[0 0 1 1],'fontsize',max(m.font.mheader,m.font.mfooter));
set(axestemp,'units','points','visible','off');
posc=get(axestemp,'position');
hhe=m.font.mheader*size(m.mheader,1)+10; hfo=m.font.mfooter*size(m.mfooter,1);
set(axestemp,'position',[posc(1) posc(2)+hfo posc(3) posc(4)-hfo-hhe]);
text(.5,1,m.mheader,'horizontalalignment','center',...
    'verticalalignment','bottom','fontsize',m.font.mheader);
text(.5,0,m.mfooter,'horizontalalignment','center',...
    'verticalalignment','top','fontsize',m.font.mfooter);
set(axestemp,'units','normalized');
pos=get(axestemp,'position');

wn=pos(3)/ncol;
hn=pos(4)/nrow;
for row=1:nrow;
    for col=1:ncol;
        if ~isempty(m.gr{row,col})
            posgr=[pos(1)+wn*(col-1) pos(2)+hn*(nrow-row) wn hn];
            gra(m.gr{row,col},'',fig,posgr);
        end;
    end;
end;
return



function str=compact(str)
str=cellstr(str);
str=char({str{:} '-'});
for i=size(str,1):-1:1;
    if isempty(deblank(str(i,:))); str(i,:)=[]; end;
end
str=str(1:(size(str,1)-1),:);
return



