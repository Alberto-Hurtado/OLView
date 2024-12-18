function sig=putpp(sig)
%sig=putpp(sig)
% Puts all the signals (cell of structures) of a postprocesing
% in the ELSA Data Base.
% Ordered names are assigned to the signals in the form:
%     sig{i}.Name=sprintf('%03d',i-1)
%
% SEE ALSO:  getsig sist2db
%
% EXAMPLES:
% s=struct('Project','uWalls','Structure','Wall 4','Experiment','w14', ...
%        'PostProcessing','60');
% s.Signal={};
% sig=getsig(s);
% putpp(sig);
%
%JM VV 03 
global AUTOMATIC_SEL_TREAT  %4-April-2008
AUTOMATIC_SEL_TREAT

if isempty(AUTOMATIC_SEL_TREAT) %4-April-2008
    AUTOMATIC_SEL_TREAT=0
end
AUTOMATIC_SEL_TREAT

if isempty(sig); return; end;

% To avoid database access:
%for i=1:length(sig);
%  sig{i}.Name=sprintf('%03d',i-1);
%end
%return


%
% Open database
%
Projects = CreateObject ('AcqCtrlDb.Projects');
PutObjectProp(Projects,'DataSourceName','ElsaDB');
%ObjectInfo(Projects)

%
% Open project
%
Projname=sig{1}.Project;
if ~ObjectInvoke(Projects,'ProjectExist',Projname);
    sa = menu(['The project ' Projname ' does not exist' ...
            '. Do you want to create that new project?'],'Ok','Cancel (pp will not be saved)');
    switch sa;
    case 1;
        Project = ObjectInvoke(Projects,'NewProject',Projname);
        PutObjectProp(Project,'Description',sig{1}.Proj_Descr);
        ObjectInvoke(Project,'Save');
    case 2
        return;
    end
else
    Project = ObjectInvoke(Projects,'GetProject',Projname);
    old_descr=GetObjectProp(Project,'Description');
    if ~strcmp(old_descr,sig{1}.Proj_Descr)
        sa = menu(['The current project description is ' old_descr  ...
                '. Do you want to change it by ' sig{1}.Proj_Descr ' ?'],'Ok', ...
            'Cancel (pp will not be saved)');
        switch sa;
        case 1;
            PutObjectProp(Project,'Description',sig{1}.Proj_Descr);
            ObjectInvoke(Project,'Save');
        case 2
            return;
        end        
    end
end;

%
% Open structure
%
Strucname=sig{1}.Structure;
if ~ObjectInvoke(Project,'StructureExist',Strucname);
    sa = menu(['The structure ' Strucname ' does not exist within project '  ...
        Projname '. Do you want to create that new structure?'], ...
      'Ok','Cancel (pp will not be saved)');
    switch sa;
    case 1;
        Structure = ObjectInvoke(Project,'NewStructure',Strucname);
        PutObjectProp(Structure,'Description',sig{1}.Struc_Descr);
        ObjectInvoke(Structure,'Save');
    case 2
        return;
    end
else
    Structure = ObjectInvoke(Project,'GetStructure',Strucname);
    old_descr=GetObjectProp(Structure,'Description');
    if ~strcmp(old_descr,sig{1}.Struc_Descr)
        sa = menu(['The current structure description is ' old_descr  ...
                '. Do you want to change it by ' sig{1}.Struc_Descr ' ?'],'Ok', ...
              'Cancel (pp will not be saved)');
        switch sa;
        case 1;
            PutObjectProp(Structure,'Description',sig{1}.Struc_Descr);
            ObjectInvoke(Structure,'Save');
        case 2
            return;
        end        
    end
end;

%
% Open experiment
%
Expername=sig{1}.Experiment;
if ~ObjectInvoke(Structure,'ExperimentExist',Expername);
    if AUTOMATIC_SEL_TREAT>0
        sa=AUTOMATIC_SEL_TREAT
    else
        sa = menu(['The experiment ' Expername ' does not exist within structure ' ...
                Strucname '. Do you want to create that new experiment?'],'Ok', ...
            'Cancel (pp will not be saved)');
    end
    switch sa;
        case 1;
            Experiment = ObjectInvoke(Structure,'NewExperiment',Expername);
            PutObjectProp(Experiment,'Description',sig{1}.Exp_Descr);
            ObjectInvoke(Experiment,'Save');
        case 2
            return;
    end
else;
        Experiment = ObjectInvoke(Structure,'GetExperiment',Expername);
        old_descr=GetObjectProp(Experiment,'Description');
        if ~strcmp(old_descr,sig{1}.Exp_Descr)
            if AUTOMATIC_SEL_TREAT>0
                sa=AUTOMATIC_SEL_TREAT
            else
                sa = menu(['The current experiment description is ' old_descr  ...
                        '. Do you want to change it by ' sig{1}.Exp_Descr ' ?'], ...
                    'Ok','Cancel (pp will not be saved)');
            end
            switch sa;
            case 1;
                PutObjectProp(Experiment,'Description',sig{1}.Exp_Descr);
                ObjectInvoke(Experiment,'Save');
            case 2
                return;
            end        
        end
end;
%
% Open Postprocessing
%
PPname=sig{1}.PostProcessing;
if ObjectInvoke(Experiment,'PostProcessingExist',PPname);
    if AUTOMATIC_SEL_TREAT>0
        sa=AUTOMATIC_SEL_TREAT
    else
    sa = menu(['The postprocessing ' PPname ' already exists within experiment ' ...
        Expername '. Do you want to replace that old postprocessing?'],'Ok', ...
      'Cancel (pp will not be saved)');
    end
    switch sa;
    case 1;
        OldPostProcessing = ObjectInvoke(Experiment,'GetPostProcessing',PPname);
        ObjectInvoke(OldPostProcessing,'Delete')
        ReleaseObject(OldPostProcessing)
    case 2
        return;
    end
end;
PostProcessing = ObjectInvoke(Experiment,'NewPostProcessing',PPname);
PutObjectProp(PostProcessing,'Description',sig{1}.PostP_Descr);
ObjectInvoke(PostProcessing,'Save')

%
% Save the signals
%
for i=1:length(sig);
    sig{i}.Name=sprintf('%03d',i-1);
    if max(abs(imag(sig{i}.Data)))==0;   %Real signals
       
        Signal = ObjectInvoke(PostProcessing,'NewSignal',sig{i}.Name);
        PutObjectProp(Signal,'Description',sig{i}.Description);
        PutObjectProp(Signal,'Magnitude',sig{i}.Magnitude);
        PutObjectProp(Signal,'Unit',sig{i}.Unit);
        PutObjectProp(Signal,'Positions',sig{i}.Positions);
        PutObjectProp(Signal,'Data',single(sig{i}.Data));
        ObjectInvoke(Signal,'Save');
        ReleaseObject(Signal)
    else                                 %Complex signals
        Signal = ObjectInvoke(PostProcessing,'NewSignal',[sig{i}.Name 're']);
        PutObjectProp(Signal,'Description',sig{i}.Description);
        PutObjectProp(Signal,'Magnitude',sig{i}.Magnitude);
        PutObjectProp(Signal,'Unit',sig{i}.Unit);
        PutObjectProp(Signal,'Positions',sig{i}.Positions);
        PutObjectProp(Signal,'Data',single(real(sig{i}.Data)));
        ObjectInvoke(Signal,'Save');
        ReleaseObject(Signal)
        
        Signal = ObjectInvoke(PostProcessing,'NewSignal',[sig{i}.Name 'im']);
        PutObjectProp(Signal,'Description',sig{i}.Description);
        PutObjectProp(Signal,'Magnitude',sig{i}.Magnitude);
        PutObjectProp(Signal,'Unit',sig{i}.Unit);
        PutObjectProp(Signal,'Positions',sig{i}.Positions);
        PutObjectProp(Signal,'Data',single(imag(sig{i}.Data)));
        ObjectInvoke(Signal,'Save');
        ReleaseObject(Signal)
    end
end
savedsignals=length(ObjectInvoke(PostProcessing,'ListSignal'))

ReleaseObject(PostProcessing)
ReleaseObject(Experiment)
ReleaseObject(Structure)
ReleaseObject(Project)
ReleaseObject(Projects)



