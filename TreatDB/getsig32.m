function sig=getsig(s)
%sig=getsig(s)
%     Gets a cell of signal structures from a common postprocessing
%     in ELSA Data Base.
%
% SEE ALSO:  repsig selst putpp gra sist2db
%
% EXAMPLES:
% s=struct('Project','uWalls','Structure','Wall 4','Experiment','w14', ...
%        'PostProcessing','60');
% s.Signal={'000' '001' '002'};
% sig=getsig(s)
% repsig(sig);
%
% s.Signal={};
% sig=getsig(s)
% repsig(sig);
%
%JM01

if length(s)>1
  for i1=1:length(s)
    if iscell(s)
      sig{i1}=getsig(s{i1});
    else
      sig{i1}=getsig(s(i1));
    end
  end
  return
else
  if iscell(s)
    sig{1}=getsig(s{1});
    return
  end
end

Projects = CreateObject ('AcqCtrlDb.Projects');
PutObjectProp(Projects,'DataSourceName','ElsaDB');
Project = ObjectInvoke(Projects,'GetProject',s.Project);
Structure = ObjectInvoke(Project,'GetStructure',s.Structure);
Experiment = ObjectInvoke(Structure,'GetExperiment',s.Experiment);
PostProcessing = ObjectInvoke(Experiment,'GetPostProcessing',s.PostProcessing);
if ~isfield(s,'Signal'); s.Signal={}; end;
if isempty(s.Signal);
  s.Signal=ObjectInvoke(PostProcessing,'ListSignal');
end;
s.Signal=cellstr(s.Signal);

for i=1:length(s.Signal)
  Signal = ObjectInvoke(PostProcessing,'GetSignal',s.Signal{i});
  sig{i}=s;
  sig{i}=rmfield(sig{i},'Signal');
  sig{i}.Name=s.Signal{i};
  sig{i}.Description=GetObjectProp(Signal,'Description');
  sig{i}.Magnitude=GetObjectProp(Signal,'Magnitude');
  sig{i}.Unit=GetObjectProp(Signal,'Unit');
  sig{i}.Positions=GetObjectProp(Signal,'Positions');
%  sig{i}.Data=GetObjectProp(Signal,'Data')';
  sig{i}.Data=double(GetObjectProp(Signal,'Data')');
  sig{i}.PostP_Descr=GetObjectProp(PostProcessing,'Description');
  sig{i}.Exp_Descr=GetObjectProp(Experiment,'Description');
  sig{i}.Struc_Descr=GetObjectProp(Structure,'Description');
  sig{i}.Proj_Descr=GetObjectProp(Project,'Description');
%  disp(sig{i});
  ReleaseObject(Signal)
end;

ReleaseObject(Projects)
ReleaseObject(Project)
ReleaseObject(Structure)
ReleaseObject(Experiment)
ReleaseObject(PostProcessing)

if length(s.Signal)==1;
  sig=sig{1};
end

