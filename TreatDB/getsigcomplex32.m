function sig=getsigcomplex(s)
%sig=getsigcomplex(s)
%     Gets a cell of signal structures from a complex postprocessing
%     in ELSA Data Base.
%
% SEE ALSO:  getsig repsig selst putpp gra sist2db 
%
% EXAMPLES:
% s=struct('Project','PsChar','Structure','P15t','Experiment','r040', ...
%        'PostProcessing','82');
% s.Signal={'001' '002im' '002re' '003re' '006'};
% sig=getsigcomplex(s)
% repsig(sig);

% s.Signal={};
% sig=getsigcomplex(s)
% repsig(sig);
%
% JM/VV 03


if length(s)>1
    for i1=1:length(s)
        if iscell(s)
            sig{i1}=getsigcomplex(s{i1});
        else
            sig{i1}=getsigcomplex(s(i1));
        end
    end
    return
else
    if iscell(s)
        sig{1}=getsigcomplex(s{1});
        return
    end
end

Projects = CreateObject ('AcqCtrlDb.Projects');
PutObjectProp(Projects,'DataSourceName','ElsaDB');
Project = ObjectInvoke(Projects,'GetProject',s.Project);
Structure = ObjectInvoke(Project,'GetStructure',s.Structure);
Experiment = ObjectInvoke(Structure,'GetExperiment',s.Experiment);
PostProcessing = ObjectInvoke(Experiment,'GetPostProcessing',s.PostProcessing);
signalDB=ObjectInvoke(PostProcessing,'ListSignal');
signalDB=cellstr(signalDB);
if ~isfield(s,'Signal'); s.Signal={}; end;
if isempty(s.Signal);
    s.Signal=signalDB
else
    s.Signal=cellstr(s.Signal);
end;



% s.Signal={'003' '001re' '000im' '000re' '006im' '004' '005re' '005im' };
signalcplx={};
i=length(s.Signal);
while i>0
    ni=s.Signal{i}; niend=ni((length(ni)-1):length(ni)); nistart=ni(1:(length(ni)-2));
    if i>1 & strcmp(niend,'im')
        if  strcmp([nistart 're'],s.Signal{i-1});
            signalcplx={nistart signalcplx{:}};
            i=i-1;
        else
            signalcplx={ni signalcplx{:}};
        end
    elseif i>1 & strcmp(niend,'re')
        if  strcmp([nistart 'im'],s.Signal{i-1})
            signalcplx={nistart signalcplx{:}};
            i=i-1;
        else
            signalcplx={ni signalcplx{:}};
        end
    else
        signalcplx={ni signalcplx{:}};
    end
    i=i-1;
end
signalcplx

for ii=1:length(signalcplx);
    for jj=1:length(signalDB);
        exists1=strcmp(signalcplx{ii}, signalDB{jj}); 
        ttt=strcmp(signalcplx{ii},'000');
        if(exists1==1 & ii>0)|ttt==1;
            Signal = ObjectInvoke(PostProcessing,'GetSignal',s.Signal{ii});
        else
            Signal = ObjectInvoke(PostProcessing,'GetSignal',[signalcplx{ii} 're']);
        end
        
        sig{ii}=s;
        sig{ii}=rmfield(sig{ii},'Signal');
        sig{ii}.Name=signalcplx{ii};
        sig{ii}.Description=GetObjectProp(Signal,'Description');
        sig{ii}.Magnitude=GetObjectProp(Signal,'Magnitude');
        sig{ii}.Unit=GetObjectProp(Signal,'Unit');
        sig{ii}.Positions=GetObjectProp(Signal,'Positions');
        sig{ii}.PostP_Descr=GetObjectProp(PostProcessing,'Description');
        sig{ii}.Exp_Descr=GetObjectProp(Experiment,'Description');
        sig{ii}.Struc_Descr=GetObjectProp(Structure,'Description');
        sig{ii}.Proj_Descr=GetObjectProp(Project,'Description');
        exists=0;
    end
    for jj=1:length(signalDB);
        exists=strcmp(signalcplx{ii}, signalDB{jj});
        if exists==1;    
            sig{ii}.Data=double(GetObjectProp(Signal,'Data')');
            
        else
            cc=strcmp([signalcplx{ii} 're'], signalDB{jj});
            if cc==1;             
                sigre= ObjectInvoke(PostProcessing,'GetSignal',[signalcplx{ii} 're']);
                sigim= ObjectInvoke(PostProcessing,'GetSignal',[signalcplx{ii} 'im']);
                sigreData= double(GetObjectProp(sigre,'Data')');
                sigimData= double(GetObjectProp(sigim,'Data')');
                sig{ii}.Data= complex(sigreData, sigimData);
                
            end
        end        
    end
    ReleaseObject(Signal)
end  

ReleaseObject(Projects)
ReleaseObject(Project)
ReleaseObject(Structure)
ReleaseObject(Experiment)
ReleaseObject(PostProcessing)

if length(s.Signal)==1;
    sig=sig{1};
end

