function gr=grdef(gr)
%gr=grdef(gr)
%    Fills in the default values of gr structure within function gra.
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
%  gr.op.xylabel.format gr.op.xylabel.proplist
%  gr.op.xylabel2.format gr.op.xylabel2.proplist
%  gr.op.legendu.format gr.op.legendu.proplist
%  gr.op.legendl.format gr.op.legendl.proplist
%
%  gr.pl{:}.xsig{:}  gr.pl{:}.ysig{:}
%  gr.pl{:}.xpart{:}  gr.pl{:}.ypart{:}      Dec-2001    = ' ';'(Re)';'(Im)';'(Amp)';'(Pha)'
%  gr.pl{:}.xdata{:}    gr.pl{:}.ydata{:}   gr.pl{:}.color{:} gr.pl{:}.linewidth{:}
%  gr.pl{:}.xgrid   gr.pl{:}.xlim    gr.pl{:}.xscale     gr.pl{:}.ygrid    gr.pl{:}.ylim    gr.pl{:}.yscale
%  gr.pl{:}.points{:}   % Jul-2004
%  gr.pl{:}.font.axis
%  gr.pl{:}.title    gr.pl{:}.font.title
%  gr.pl{:}.xlabel   gr.pl{:}.font.xlabel   gr.pl{:}.ylabel    gr.pl{:}.font.ylabel
%  gr.pl{:}.legendu{:}   gr.pl{:}.font.legendu
%  gr.pl{:}.legendl{:}   gr.pl{:}.font.legendl
%  gr.pl{:}.legend_color{:}    gr.pl{:}.legend_linewidth{:}
%  gr.pl{:}.op.colorlist gr.pl{:}.op.linewidthlist
%  gr.pl{:}.op.title.format gr.pl{:}.op.title.proplist
%  gr.pl{:}.op.xylabel.format gr.pl{:}.op.xylabel.proplist
%  gr.pl{:}.op.xylabel2.format gr.pl{:}.op.xylabel2.proplist
%  gr.pl{:}.op.legendu.format gr.pl{:}.op.legendu.proplist
%  gr.pl{:}.op.legendl.format gr.pl{:}.op.legendl.proplist
%
% SEE ALSO: gra pldef
%
%JM01

iarg=1;
if nargin<iarg; gr=[]; end; iarg=iarg+1;

fie={'grheader','grfooter','xgrid','xlim','xscale','ygrid','ylim','yscale', ...
    'title','xlabel','ylabel','font','op',   'points'};
for ifie=1:length(fie)
    eval(['if ~isfield(gr,''' fie{ifie} '''); gr.' fie{ifie} '=''''; end;']);
end
fie={'grheader','grfooter','axis','title','xlabel','ylabel','legendu','legendl'};
for ifie=1:length(fie)
    eval(['if ~isfield(gr.font,''' fie{ifie} '''); gr.font.' fie{ifie} '=[]; end;']);
end
fie={'colorlist','linewidthlist','title','xylabel','xylabel2','legendu','legendl'};
for ifie=1:length(fie)
    eval(['if ~isfield(gr.op,''' fie{ifie} '''); gr.op.' fie{ifie} '=[]; end;']);
end
if ~isfield(gr.op.title,'format'); gr.op.title.format=[]; end;
if ~isfield(gr.op.title,'proplist'); gr.op.title.proplist=[]; end;
if ~isfield(gr.op.xylabel,'format'); gr.op.xylabel.format=[]; end;
if ~isfield(gr.op.xylabel,'proplist'); gr.op.xylabel.proplist=[]; end;
if ~isfield(gr.op.xylabel2,'format'); gr.op.xylabel2.format=[]; end;
if ~isfield(gr.op.xylabel2,'proplist'); gr.op.xylabel2.proplist=[]; end;
if ~isfield(gr.op.legendu,'format'); gr.op.legendu.format=[]; end;
if ~isfield(gr.op.legendu,'proplist'); gr.op.legendu.proplist=[]; end;
if ~isfield(gr.op.legendl,'format'); gr.op.legendl.format=[]; end;
if ~isfield(gr.op.legendl,'proplist'); gr.op.legendl.proplist=[]; end;

if isempty(gr.op.title.format);
%     gr.op.title.format{1}={'%s' ' [%s]' ' (%s:' ' %s)'};
    gr.op.title.format{1}={'%s' ' [%s]' ' (%s)'};  %2022
    gr.op.title.format{2}={'%s:' ' %s'};
    gr.op.title.format{3}={' %s'};
%     gr.op.title.proplist{1}={'Project' 'Structure' 'PostProcessing' 'PostP_Descr'};
    gr.op.title.proplist{1}={'Project' 'Structure' 'PostProcessing'};    %2022
    gr.op.title.proplist{2}={'Experiment' 'Exp_Descr'};
    gr.op.title.proplist{3}={'Positions'};
end;
if isempty(gr.op.xylabel.format);
    gr.op.xylabel.format{1}={'%s# ' '%s' ' %s' ' (%s)' ' %s'};
    gr.op.xylabel.proplist{1}={'Name' 'Description' 'Magnitude' 'Unit' 'Part'};
end;
if isempty(gr.op.xylabel2.format);
    gr.op.xylabel2.format=gr.op.title.format;
    gr.op.xylabel2.proplist=gr.op.title.proplist;
end;
if isempty(gr.op.legendu.format);
    gr.op.legendu.format{1}={'%s' ' [%s]' ' %s' ' %s' '%s# ' ' %s' ' %s' ' (%s)' ' %s' ' %s'};
    gr.op.legendu.proplist{1}={'Project' 'Structure' 'Experiment' ...
        'PostProcessing' 'Name' 'Description' 'Magnitude' 'Unit' 'Part' 'Positions'};
end;
if isempty(gr.op.legendl.format);
    gr.op.legendl.format=gr.op.legendu.format;
    gr.op.legendl.proplist=gr.op.legendu.proplist;
end;

npl=length(gr.pl);
for ipl=1:npl;
    fie={'xgrid','xlim','xscale','ygrid','ylim','yscale', ...
        'xpart','ypart','title','xlabel','ylabel','font','op','points'};
    for ifie=1:length(fie)
        eval(['if ~isfield(gr.pl{ipl},''' fie{ifie} '''); gr.pl{ipl}.' fie{ifie} '=[]; end;']);
    end
    fie={'axis','title','xlabel','ylabel','legendu','legendl'};
    for ifie=1:length(fie)
        eval(['if ~isfield(gr.pl{ipl}.font,''' fie{ifie} '''); gr.pl{ipl}.font.' fie{ifie} '=[]; end;']);
    end
    fie={'colorlist','linewidthlist','title','xylabel','xylabel2','legendu','legendl'};
    for ifie=1:length(fie)
        eval(['if ~isfield(gr.pl{ipl}.op,''' fie{ifie} '''); gr.pl{ipl}.op.' fie{ifie} '=[]; end;']);
    end
    if ~isfield(gr.pl{ipl}.op.title,'format'); gr.pl{ipl}.op.title.format=[]; end;
    if ~isfield(gr.pl{ipl}.op.title,'proplist'); gr.pl{ipl}.op.title.proplist=[]; end;
    if ~isfield(gr.pl{ipl}.op.xylabel,'format'); gr.pl{ipl}.op.xylabel.format=[]; end;
    if ~isfield(gr.pl{ipl}.op.xylabel,'proplist'); gr.pl{ipl}.op.xylabel.proplist=[]; end;
    if ~isfield(gr.pl{ipl}.op.xylabel2,'format'); gr.pl{ipl}.op.xylabel2.format=[]; end;
    if ~isfield(gr.pl{ipl}.op.xylabel2,'proplist'); gr.pl{ipl}.op.xylabel2.proplist=[]; end;
    if ~isfield(gr.pl{ipl}.op.legendu,'format'); gr.pl{ipl}.op.legendu.format=[]; end;
    if ~isfield(gr.pl{ipl}.op.legendu,'proplist'); gr.pl{ipl}.op.legendu.proplist=[]; end;
    if ~isfield(gr.pl{ipl}.op.legendl,'format'); gr.pl{ipl}.op.legendl.format=[]; end;
    if ~isfield(gr.pl{ipl}.op.legendl,'proplist'); gr.pl{ipl}.op.legendl.proplist=[]; end;
    
    if isempty(gr.pl{ipl}.xpart); gr.pl{ipl}.xpart=' '; end;
    if isempty(gr.pl{ipl}.ypart); gr.pl{ipl}.ypart=' '; end;
    if isempty(gr.pl{ipl}.xgrid); gr.pl{ipl}.xgrid=gr.xgrid; end;
    if isempty(gr.pl{ipl}.xlim); gr.pl{ipl}.xlim=gr.xlim; end;
    if isempty(gr.pl{ipl}.xscale); gr.pl{ipl}.xscale=gr.xscale; end;
    if isempty(gr.pl{ipl}.ygrid); gr.pl{ipl}.ygrid=gr.ygrid; end;
    if isempty(gr.pl{ipl}.ylim); gr.pl{ipl}.ylim=gr.ylim; end;
    if isempty(gr.pl{ipl}.yscale); gr.pl{ipl}.yscale=gr.yscale; end;
    if isempty(gr.pl{ipl}.points); gr.pl{ipl}.points=gr.points; end;
    if isempty(gr.pl{ipl}.title); gr.pl{ipl}.title=gr.title; end;
    if isempty(gr.pl{ipl}.xlabel); gr.pl{ipl}.xlabel=gr.xlabel; end;
    if isempty(gr.pl{ipl}.ylabel); gr.pl{ipl}.ylabel=gr.ylabel; end;
    if isempty(gr.pl{ipl}.font.axis); gr.pl{ipl}.font.axis=gr.font.axis; end;
    if isempty(gr.pl{ipl}.font.title); gr.pl{ipl}.font.title=gr.font.title; end;
    if isempty(gr.pl{ipl}.font.xlabel); gr.pl{ipl}.font.xlabel=gr.font.xlabel; end;
    if isempty(gr.pl{ipl}.font.ylabel); gr.pl{ipl}.font.ylabel=gr.font.ylabel; end;
    if isempty(gr.pl{ipl}.font.legendu); gr.pl{ipl}.font.legendu=gr.font.legendu; end;
    if isempty(gr.pl{ipl}.font.legendl); gr.pl{ipl}.font.legendl=gr.font.legendl; end;
    if isempty(gr.pl{ipl}.op.colorlist); gr.pl{ipl}.op.colorlist=gr.op.colorlist; end;
    if isempty(gr.pl{ipl}.op.linewidthlist); gr.pl{ipl}.op.linewidthlist=gr.op.linewidthlist; end;
    if isempty(gr.pl{ipl}.op.title.format); gr.pl{ipl}.op.title.format=gr.op.title.format; end;
    if isempty(gr.pl{ipl}.op.title.proplist); gr.pl{ipl}.op.title.proplist=gr.op.title.proplist; end;
    if isempty(gr.pl{ipl}.op.xylabel.format); gr.pl{ipl}.op.xylabel.format=gr.op.xylabel.format; end;
    if isempty(gr.pl{ipl}.op.xylabel.proplist); gr.pl{ipl}.op.xylabel.proplist=gr.op.xylabel.proplist; end;
    if isempty(gr.pl{ipl}.op.xylabel2.format); gr.pl{ipl}.op.xylabel2.format=gr.op.xylabel2.format; end;
    if isempty(gr.pl{ipl}.op.xylabel2.proplist); gr.pl{ipl}.op.xylabel2.proplist=gr.op.xylabel2.proplist; end;
    if isempty(gr.pl{ipl}.op.legendu.format); gr.pl{ipl}.op.legendu.format=gr.op.legendu.format; end;
    if isempty(gr.pl{ipl}.op.legendu.proplist); gr.pl{ipl}.op.legendu.proplist=gr.op.legendu.proplist; end;
    if isempty(gr.pl{ipl}.op.legendl.format); gr.pl{ipl}.op.legendl.format=gr.op.legendl.format; end;
    if isempty(gr.pl{ipl}.op.legendl.proplist); gr.pl{ipl}.op.legendl.proplist=gr.op.legendl.proplist; end;
    if ~iscell(gr.pl{ipl}.xpart); gr.pl{ipl}.xpart={gr.pl{ipl}.xpart}; end;
    if ~iscell(gr.pl{ipl}.ypart); gr.pl{ipl}.ypart={gr.pl{ipl}.ypart}; end;
    if ~iscell(gr.pl{ipl}.points); gr.pl{ipl}.points={gr.pl{ipl}.points}; end;
    
    %   if ~isfield(gr.pl{ipl},'xsig'); gr.pl{ipl}.xsig=[]; end;
    %   if ~isfield(gr.pl{ipl},'ysig'); gr.pl{ipl}.ysig=[]; end;
    if ~isfield(gr.pl{ipl},'xsig'); gr.pl{ipl}.xsig={}; end;   %2019_10_08
    if ~isfield(gr.pl{ipl},'ysig'); gr.pl{ipl}.ysig={}; end;   %2019_10_08
    
    if ~iscell(gr.pl{ipl}.xsig); gr.pl{ipl}.xsig={gr.pl{ipl}.xsig}; end;   % 4-2-2004
    if ~iscell(gr.pl{ipl}.ysig); gr.pl{ipl}.ysig={gr.pl{ipl}.ysig}; end;
    
    ncur=max(length(gr.pl{ipl}.xsig),length(gr.pl{ipl}.ysig));
    
    if ncur==0
        gr.pl{ipl}={};
    else   %2019_10_08
        
        if length(gr.pl{ipl}.xsig)==1
            gr.pl{ipl}.xsig=gr.pl{ipl}.xsig(ones(ncur,1));
        end
        if length(gr.pl{ipl}.ysig)==1
            gr.pl{ipl}.ysig=gr.pl{ipl}.ysig(ones(ncur,1));
        end
        if length(gr.pl{ipl}.xpart)==1
            gr.pl{ipl}.xpart=gr.pl{ipl}.xpart(ones(ncur,1));
        end
        if length(gr.pl{ipl}.ypart)==1
            gr.pl{ipl}.ypart=gr.pl{ipl}.ypart(ones(ncur,1));
        end
        if length(gr.pl{ipl}.points)==1
            gr.pl{ipl}.points=gr.pl{ipl}.points(ones(ncur,1));
        end
        for icur=1:ncur
            if icur>length(gr.pl{ipl}.xsig)
                gr.pl{ipl}.xsig{icur}=[];
            end
            if isempty(gr.pl{ipl}.xsig{icur})
                gr.pl{ipl}.xsig{icur}=gr.pl{ipl}.ysig{icur};
                gr.pl{ipl}.xsig{icur}.Name='';
                gr.pl{ipl}.xsig{icur}.Description='Sampling Point';
                gr.pl{ipl}.xsig{icur}.Magnitude='';
                gr.pl{ipl}.xsig{icur}.Unit='';
                gr.pl{ipl}.xsig{icur}.Data=(1:length(gr.pl{ipl}.xsig{icur}.Data))';
            end
            if icur>length(gr.pl{ipl}.ysig); gr.pl{ipl}.ysig{icur}=[]; end;
            if isempty(gr.pl{ipl}.ysig{icur})
                gr.pl{ipl}.ysig{icur}=gr.pl{ipl}.xsig{icur};
                gr.pl{ipl}.ysig{icur}.Name='';
                gr.pl{ipl}.ysig{icur}.Description='Sampling Point';
                gr.pl{ipl}.ysig{icur}.Magnitude='';
                gr.pl{ipl}.ysig{icur}.Unit='';
                gr.pl{ipl}.ysig{icur}.Data=(1:length(gr.pl{ipl}.ysig{icur}.Data))';
            end
            pp=gr.pl{ipl}.points{icur};
            if ~isempty(pp)
                gr.pl{ipl}.ysig{icur}.Data=gr.pl{ipl}.ysig{icur}.Data(pp);
                gr.pl{ipl}.xsig{icur}.Data=gr.pl{ipl}.xsig{icur}.Data(pp);
            end
            
            
            fie={'Project' 'Structure' 'Experiment'  'PostP_Descr' 'Exp_Descr'...
                'PostProcessing' 'Name' 'Description' 'Magnitude' 'Unit' 'Part' 'Positions'};
            for ifie=1:length(fie)
                eval(['if ~isfield(gr.pl{ipl}.xsig{icur},''' fie{ifie} '''); gr.pl{ipl}.xsig{icur}.' fie{ifie} '=''''; end;']);
                eval(['if ~isfield(gr.pl{ipl}.ysig{icur},''' fie{ifie} '''); gr.pl{ipl}.ysig{icur}.' fie{ifie} '=''''; end;']);
            end
            if strcmp(gr.pl{ipl}.xsig{icur}.Name,'000'); %Time signal
                gr.pl{ipl}.xsig{icur}.Positions=gr.pl{ipl}.ysig{icur}.Positions;
            end;
            switch gr.pl{ipl}.xpart{icur}
                case '(Re)'
                    gr.pl{ipl}.xdata{icur}=real(gr.pl{ipl}.xsig{icur}.Data);
                case '(Im)'
                    gr.pl{ipl}.xdata{icur}=imag(gr.pl{ipl}.xsig{icur}.Data);
                case '(Amp)'
                    gr.pl{ipl}.xdata{icur}=abs(gr.pl{ipl}.xsig{icur}.Data);
                case '(Pha)'
                    gr.pl{ipl}.xdata{icur}=angle(gr.pl{ipl}.xsig{icur}.Data)*180/pi;
                otherwise
                    gr.pl{ipl}.xdata{icur}=gr.pl{ipl}.xsig{icur}.Data;
            end
            switch gr.pl{ipl}.ypart{icur}
                case '(Re)'
                    gr.pl{ipl}.ydata{icur}=real(gr.pl{ipl}.ysig{icur}.Data);
                case '(Im)'
                    gr.pl{ipl}.ydata{icur}=imag(gr.pl{ipl}.ysig{icur}.Data);
                case '(Amp)'
                    gr.pl{ipl}.ydata{icur}=abs(gr.pl{ipl}.ysig{icur}.Data);
                case '(Pha)'
                    gr.pl{ipl}.ydata{icur}=angle(gr.pl{ipl}.ysig{icur}.Data)*180/pi;
                otherwise
                    gr.pl{ipl}.ydata{icur}=gr.pl{ipl}.ysig{icur}.Data;
            end
            gr.pl{ipl}.xsig{icur}.Part=gr.pl{ipl}.xpart{icur};
            gr.pl{ipl}.ysig{icur}.Part=gr.pl{ipl}.ypart{icur};
        end
        
        if isempty(gr.pl{ipl}.title)
            if ~isempty(gr.pl{ipl}.op.title.proplist) %Common for every curve and for x and y
                for itit=1:length(gr.pl{ipl}.op.title.proplist)
                    gr.pl{ipl}.title{itit}='';
                    for i=1:length(gr.pl{ipl}.op.title.proplist{itit})
                        for icur=1:ncur
                            %             eval(['prox=cellstr(gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.title.proplist{itit}{i} ');']);
                            %             eval(['proy=cellstr(gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.title.proplist{itit}{i} ');']);
                            eval(['prox=gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.title.proplist{itit}{i} ';']);  %2008
                            eval(['proy=gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.title.proplist{itit}{i} ';']);
                            proxy=common(prox,proy);
                            if icur==1;
                                pro=proxy;
                            else;
                                pro=common(pro,proxy);
                            end;
                        end;
                        gr.pl{ipl}.title{itit}=[gr.pl{ipl}.title{itit} ...
                            sprintfcell(gr.pl{ipl}.op.title.format{itit}{i},pro)];
                    end;
                end;
            end;
        end
        gr.pl{ipl}.title=cellstr(gr.pl{ipl}.title);
        
        if isempty(gr.pl{ipl}.xlabel) & isempty(gr.pl{ipl}.ylabel)
            if ~isempty(gr.pl{ipl}.op.xylabel.proplist) %Common for every curve
                for itit=1:length(gr.pl{ipl}.op.xylabel.proplist)
                    gr.pl{ipl}.xlabel{itit}='';  gr.pl{ipl}.ylabel{itit}='';
                    for i=1:length(gr.pl{ipl}.op.xylabel.proplist{itit})
                        for icur=1:ncur
                            %             eval(['prox1=cellstr(gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.xylabel.proplist{itit}{i} ');']);
                            %             eval(['proy1=cellstr(gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.xylabel.proplist{itit}{i} ');']);
                            eval(['prox1=gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.xylabel.proplist{itit}{i} ';']);  %2008
                            eval(['proy1=gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.xylabel.proplist{itit}{i} ';']);
                            if icur==1;
                                prox=prox1; proy=proy1;
                            else;
                                prox=common(prox,prox1); proy=common(proy,proy1);
                            end;
                        end;
                        gr.pl{ipl}.xlabel{itit}=[gr.pl{ipl}.xlabel{itit} ...
                            sprintfcell(gr.pl{ipl}.op.xylabel.format{itit}{i},prox)];
                        gr.pl{ipl}.ylabel{itit}=[gr.pl{ipl}.ylabel{itit} ...
                            sprintfcell(gr.pl{ipl}.op.xylabel.format{itit}{i},proy)];
                    end;
                end;
            end;
            if ~isempty(gr.pl{ipl}.op.xylabel2.proplist) %Common for every curve but different for x and y
                for itit=1:length(gr.pl{ipl}.op.xylabel2.proplist)
                    xlabel2{itit}=''; ylabel2{itit}='';
                    for i=1:length(gr.pl{ipl}.op.xylabel2.proplist{itit})
                        for icur=1:ncur
                            %             eval(['prox1=cellstr(gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.xylabel2.proplist{itit}{i} ');']);
                            %             eval(['proy1=cellstr(gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.xylabel2.proplist{itit}{i} ');']);
                            eval(['prox1=gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.xylabel2.proplist{itit}{i} ';']);  %2008
                            eval(['proy1=gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.xylabel2.proplist{itit}{i} ';']);
                            prox11=complem(prox1,proy1);  proy11=complem(proy1,prox1);
                            if icur==1;
                                prox=prox11; proy=proy11;
                            else;
                                prox=common(prox,prox11); proy=common(proy,proy11);
                            end;
                        end;
                        xlabel2{itit}=[xlabel2{itit} ...
                            sprintfcell(gr.pl{ipl}.op.xylabel2.format{itit}{i},prox)];
                        ylabel2{itit}=[ylabel2{itit} ...
                            sprintfcell(gr.pl{ipl}.op.xylabel2.format{itit}{i},proy)];
                    end;
                end;
                gr.pl{ipl}.xlabel=[gr.pl{ipl}.xlabel(:); xlabel2(:)];
                gr.pl{ipl}.ylabel=[gr.pl{ipl}.ylabel(:); ylabel2(:)];
            end;
        end
        gr.pl{ipl}.xlabel=cellstr(gr.pl{ipl}.xlabel);
        gr.pl{ipl}.ylabel=cellstr(gr.pl{ipl}.ylabel);
        
        if ~isempty(gr.pl{ipl}.op.legendu.proplist) %Different for each curve but common for x and y
            for itit=1:length(gr.pl{ipl}.op.legendu.proplist)
                for icur=1:ncur; gr.pl{ipl}.legendu{icur}{itit}=''; end;
                for i=1:length(gr.pl{ipl}.op.legendu.proplist{itit})
                    for icur=1:ncur
                        %           eval(['prox=cellstr(gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.legendu.proplist{itit}{i} ');']);
                        %           eval(['proy=cellstr(gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.legendu.proplist{itit}{i} ');']);
                        eval(['prox=gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.legendu.proplist{itit}{i} ';']);  %2008
                        eval(['proy=gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.legendu.proplist{itit}{i} ';']);
                        proxy=common(prox,proy);
                        if icur==1;
                            pro=proxy;
                        else;
                            pro=common(pro,proxy);
                        end;
                    end;
                    for icur=1:ncur
                        %           eval(['prox=cellstr(gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.legendu.proplist{itit}{i} ');']);
                        %           eval(['proy=cellstr(gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.legendu.proplist{itit}{i} ');']);
                        eval(['prox=gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.legendu.proplist{itit}{i} ';']);  %2008
                        eval(['proy=gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.legendu.proplist{itit}{i} ';']);
                        proxy1=common(prox,proy);
                        proxy=complem(proxy1,pro);
                        gr.pl{ipl}.legendu{icur}{itit}=[gr.pl{ipl}.legendu{icur}{itit} ...
                            sprintfcell(gr.pl{ipl}.op.legendu.format{itit}{i},proxy)];
                    end;
                end;
            end;
        end;
        
        if ~isempty(gr.pl{ipl}.op.legendl.proplist) %Different for each curve and for x and y
            for itit=1:length(gr.pl{ipl}.op.legendl.proplist)
                for icur=1:ncur; legendlx{icur}=''; legendly{icur}=''; end;
                for i=1:length(gr.pl{ipl}.op.legendl.proplist{itit})
                    for icur=1:ncur
                        %           eval(['prox1=cellstr(gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.legendl.proplist{itit}{i} ');']);
                        %           eval(['proy1=cellstr(gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.legendl.proplist{itit}{i} ');']);
                        eval(['prox1=gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.legendl.proplist{itit}{i} ';']);   %2008
                        eval(['proy1=gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.legendl.proplist{itit}{i} ';']);
                        prox11=complem(prox1,proy1);
                        proy11=complem(proy1,prox1);
                        if icur==1;
                            prox=prox11; proy=proy11;
                        else;
                            prox=common(prox,prox11); proy=common(proy,proy11);
                        end;
                    end;
                    for icur=1:ncur
                        %           eval(['prox1=cellstr(gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.legendl.proplist{itit}{i} ');']);
                        %           eval(['proy1=cellstr(gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.legendl.proplist{itit}{i} ');']);
                        eval(['prox1=gr.pl{ipl}.xsig{icur}.' gr.pl{ipl}.op.legendl.proplist{itit}{i} ';']);  %2008
                        eval(['proy1=gr.pl{ipl}.ysig{icur}.' gr.pl{ipl}.op.legendl.proplist{itit}{i} ';']);
                        prox11=complem(prox1,proy1);  proy11=complem(proy1,prox1);
                        prox1=complem(prox11,prox);  proy1=complem(proy11,proy);
                        legendlx{icur}=[legendlx{icur} sprintfcell(gr.pl{ipl}.op.legendl.format{itit}{i},prox1)];
                        legendly{icur}=[legendly{icur} sprintfcell(gr.pl{ipl}.op.legendl.format{itit}{i},proy1)];
                    end;
                    for icur=1:ncur
                        if ~isempty(legendly{icur}) & ~isempty(legendlx{icur})
                            gr.pl{ipl}.legendl{icur}{itit}=[sprintfcell('%s',legendly{icur}) ...
                                sprintfcell('/%s',legendlx{icur})];
                        else
                            gr.pl{ipl}.legendl{icur}{itit}=[sprintfcell('%s',legendly{icur}) ...
                                sprintfcell('%s',legendlx{icur})];
                        end
                    end;
                end;
            end;
        end;
    end  %2019_10_08
end;

titcom={};    %2019_10_08
for ipl=1:npl;  %Common header but different titles
    if ~isempty(gr.pl{ipl})     %2019_10_08
        if isempty(titcom)      %2019_10_08
            titcom=gr.pl{ipl}.title;
        else
            titcom=common(gr.pl{ipl}.title,titcom);
        end;
    end     %2019_10_08
end;
if isempty(gr.grheader)
    gr.grheader=titcom;
    if ~isempty(gr.pl{1})     %2019_10_08
        gr.pl{1}.title=complem(gr.pl{1}.title,titcom);
    end
end;
for ipl=2:npl;
    if ~isempty(gr.pl{ipl})     %2019_10_08
        gr.pl{ipl}.title=complem(gr.pl{ipl}.title,titcom);
    end
end;

return


function textf=sprintfcell(format,text)
if iscell(text);
    if length(text)==1
        if iscell(text{1}); text=text{1}; end
    end
    for i=1:length(text);
        if isempty(text{i}); text{i}=''; end
    end
    textf=sprintf(format,text{:});
    if isempty(sprintf('%s',text{:})); textf=''; end;
else
    textf=sprintf(format,text);
    if isempty(text); textf=''; end;
end
return

