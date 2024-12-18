function sig=putpp(sig)
%sig=putpp(sig)
% Puts all the signals (cell of structures) of a postprocesing
% in the ELSA Data Base.
% Ordered names are assigned to the signals in the form:
%     sig{i}.Name=sprintf('%03d',i-1)
%
% SEE ALSO:  put_treat putdocu
%
% EXAMPLES:
% s=struct('Project','uWalls','Structure','Wall 4','Experiment','w14', ...
%        'PostProcessing','60');
% s.Signal={};
% sig=getsig(s);
% putpp(sig);
%
%JM 2012 MATLAB 7.14.0.739 R2012a 64-bit
global AUTOMATIC_SEL_TREAT  %4-April-2008
AUTOMATIC_SEL_TREAT

if isempty(AUTOMATIC_SEL_TREAT) %4-April-2008
    AUTOMATIC_SEL_TREAT=0
end
AUTOMATIC_SEL_TREAT

if isempty(sig); return; end;

%
% Open database
%
Projects =  actxserver('AcqCtrlDb.Projects')
Projects.DataSourceName = 'ElsaDB';

%
% Open project
%
Projname=sig{1}.Project;
if ~Projects.ProjectExist(Projname);
    sa = menu(['The project ' Projname ' does not exist' ...
            '. Do you want to create that new project?'],'Ok','Cancel (pp will not be saved)');
    switch sa;
    case 1;
        Project =  Projects.NewProject(Projname)
        Project.Description = sig{1}.Proj_Descr;
        Project.Save;
    case 2
        return;
    end
else
    Project = Projects.GetProject(Projname);
    old_descr=Project.Description;
    if ~strcmp(old_descr,sig{1}.Proj_Descr)
        sa = menu(['The current project description is ' old_descr  ...
                '. Do you want to change it by ' sig{1}.Proj_Descr ' ?'],'Ok', ...
            'Cancel (pp will not be saved)');
        switch sa;
        case 1;
            Project.Description = sig{1}.Proj_Descr;
            Project.Save;
        case 2
            return;
        end        
    end
end;

%
% Open structure
%
Strucname=sig{1}.Structure;
if ~Project.StructureExist(Strucname);
    if AUTOMATIC_SEL_TREAT>0
        sa=AUTOMATIC_SEL_TREAT
    else
        sa = menu(['The structure ' Strucname ' does not exist within project '  ...
            Projname '. Do you want to create that new structure?'], ...
            'Ok','Cancel (pp will not be saved)');
    end
    switch sa;
    case 1;
        Structure = Project.NewStructure(Strucname);
        Structure.Description=sig{1}.Struc_Descr;
        Structure.Save;
    case 2
        return;
    end
else
    Structure = Project.GetStructure(Strucname);
    old_descr=Structure.Description;
    if ~strcmp(old_descr,sig{1}.Struc_Descr)
        if AUTOMATIC_SEL_TREAT>0
            sa=AUTOMATIC_SEL_TREAT
        else
            sa = menu(['The current structure description is ' old_descr  ...
                '. Do you want to change it by ' sig{1}.Struc_Descr ' ?'],'Ok', ...
                'Cancel (pp will not be saved)');
        end
        switch sa;
        case 1;
            Structure.Description=sig{1}.Struc_Descr;
            Structure.Save;
        case 2
            return;
        end        
    end
end;

%
% Open experiment
%
Expername=sig{1}.Experiment;
if ~Structure.ExperimentExist(Expername);
    if AUTOMATIC_SEL_TREAT>0
        sa=AUTOMATIC_SEL_TREAT
    else
        sa = menu(['The experiment ' Expername ' does not exist within structure ' ...
                Strucname '. Do you want to create that new experiment?'],'Ok', ...
            'Cancel (pp will not be saved)');
    end
    switch sa;
        case 1;
            Experiment = Structure.NewExperiment(Expername);
            Experiment.Description=sig{1}.Exp_Descr;
            Experiment.Save;
        case 2
            return;
    end
else;
        Experiment = Structure.GetExperiment(Expername);
        old_descr=Experiment.Description;
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
                Experiment.Description=sig{1}.Exp_Descr;
                Experiment.Save;
            case 2
                return;
            end        
        end
end;
%
% Open Postprocessing
%
PPname=sig{1}.PostProcessing;
if Experiment.PostProcessingExist(PPname);
    if AUTOMATIC_SEL_TREAT>0
        sa=AUTOMATIC_SEL_TREAT
    else
    sa = menu(['The postprocessing ' PPname ' already exists within experiment ' ...
        Expername '. Do you want to replace that old postprocessing?'],'Ok', ...
      'Cancel (pp will not be saved)');
    end
    switch sa;
    case 1;
        OldPostProcessing = Experiment.GetPostProcessing(PPname);
        OldPostProcessing.Delete;
        OldPostProcessing.release;
    case 2
        return;
    end
end;
PostProcessing = Experiment.NewPostProcessing(PPname);
PostProcessing.Description=sig{1}.PostP_Descr;
PostProcessing.Save;

%
% Save the signals
%
for i=1:length(sig);
    sig{i}.Name=sprintf('%03d',i-1);
    if max(abs(imag(sig{i}.Data)))==0;   %Real signals
        Signal = PostProcessing.NewSignal(sig{i}.Name);
        Signal.Description=sig{i}.Description;
        Signal.Magnitude=sig{i}.Magnitude;
        Signal.Unit=sig{i}.Unit;
        Signal.Positions=sig{i}.Positions;    
        Signal.Data=single(sig{i}.Data); 
        Signal.Save;
        Signal.release;
    else                                 %Complex signals
        Signal = PostProcessing.NewSignal([sig{i}.Name 're']);
        Signal.Description=sig{i}.Description;
        Signal.Magnitude=sig{i}.Magnitude;
        Signal.Unit=sig{i}.Unit;
        Signal.Positions=sig{i}.Positions;     
        Signal.Data=single(sig{i}.Data); 
        Signal.Save;
        Signal.release;
        
        Signal = PostProcessing.NewSignal([sig{i}.Name 'im']);
        Signal.Description=sig{i}.Description;
        Signal.Magnitude=sig{i}.Magnitude;
        Signal.Unit=sig{i}.Unit;
        Signal.Positions=sig{i}.Positions;    
        Signal.Data=single(sig{i}.Data); 
        Signal.Save;
        Signal.release;
    end
end
savedsignals=length(PostProcessing.ListSignal)

PostProcessing.release;
Experiment.release;
Structure.release;
Project.release;
Projects.release;



