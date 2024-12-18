function Experiments=fs2edExperiments(labProjectName,experiments_list,inPath,inPropFileName)
% function Experiments=fs2edExperiments(labProjectName,experiments_list,inPath,inPropFileName)
% Migrates an experiments set from File System to ELSADATA
% F.J. Molina 2019 03


% labProjectName='CALIB2018'
% experiments_list={'b14'}
% nargin=2

iarg=4;
if nargin<iarg; inPropFileName=''; end; iarg=iarg-1;
if nargin<iarg; inPath=''; end; iarg=iarg-1;
if nargin<iarg; experiments_list=''; end; iarg=iarg-1;
if nargin<iarg; labProjectName=''; end; iarg=iarg-1;
if isempty(labProjectName);
    error('labProjectName cannot be empty!');
end;
if isempty(inPropFileName); inPropFileName='ExperimentsProps.xlsx'; end;
if isempty(inPath); inPath=[labpath labProjectName '\Experiments' ]; end;

project = getProjectByName(data,labProjectName);
tabfields={'name' 'description'  'specimens' 'keywords' 'startDate' ...
    'endDate' 'purpose' 'id'}; 

if ~exist(inPath,'dir')
    dos(['mkdir ' inPath]);
end
propFile=[inPath '\' inPropFileName]
if ~exist(propFile,'file')
    tab(1,1:length(tabfields))=tabfields;
    tab{2,1}='';
    xlswrite(propFile,tab);
end
if isempty(experiments_list)
    [num,txt,raw] = xlsread(propFile);
    experiments_list=txt(2:size(txt,1),1);
end
for iex=1:length(experiments_list)
    name=experiments_list{iex}
    id=readtab(propFile,name,'id','txt')
    if isempty(id)
%         isel = menu(['The id for the experiment ' name ' is not written in ' propFile],...
%             'Retrieve the id of the experiment from ED and write it in the props file',...
%             'Create the experiment in ED and write its id in the props file',...
%             'Exit');
%         asel={'Retrieve the id of object' 'Create object' 'exit' };
%         sel=asel{isel}
        sel='Create object'
    else
        sel='Use stored id'
    end
    
%     sel =  'Create object'
    
    switch sel
        case 'Retrieve the id of object'
            i1=0;
            found=false;
            while i1<length(project.experimentalActs) & ~found
                i1=i1+1;
                found=strcmp(name,project.experimentalActs(i1).name);
            end
            if found
                id=project.experimentalActs(i1).id;
                object = getExperiment(data,id);
%                 delExperiment(data,object); %this gives a java error!
%                 serverError: class javax.faces.el.EvaluationException Stardog error on update query!
                for j1=1:length(object.specimens)
                    delExperimentSpecimenRelation(data,object,object.specimens(j1));
                end
            else
                error(['Experiment ' name ' was not found in project ' labProjectName '!'])
            end
        case 'Create object'
            id = createExperimentForProject(data,project.id)
        case 'Use stored id'
            object = getExperiment(data,id);
            for j1=1:length(object.specimens)
                delExperimentSpecimenRelation(data,object,object.specimens(j1));
            end
        case 'exit'
            return
    end
    object = getExperiment(data,id)
    writetab(propFile,name,'id',id);
    
    for ifield=1:length(tabfields)
        fieldname=tabfields{ifield};
        switch fieldname
            case 'specimens'
                cellList=strList2cellList(readtab(propFile,name,fieldname,'txt'));
%                 string=readtab(propFile,name,fieldname,'txt');
%                 i_sep=strfind(string,'##');
%                 i_sep=[i_sep length(string)+1];
%                 cellList={};
%                 for iElement=1:length(i_sep)
                if ~iscell(cellList)
                    cellList={cellList};
                end
                for iElement=1:length(cellList)
                    specimenName=cellList{iElement};
                    i1=0;
                    found=false;
                    while i1<length(project.specimens) & ~found
                        i1=i1+1;
                        found=strcmp(specimenName,project.specimens(i1).name);
                    end
                    if found
%                         saveExperiment(data,object);   %this provoques an ulterior error!
                        createExperimentSpecimenRelation(data,object,project.specimens(i1));
%                         object = getExperiment(data,id);    %this provoques an ulterior error!
                    else
                        error(['Specimen ' specimenName ' was not found in project ' labProjectName '!'])
                    end
                end
            case {'startDate' 'endDate'}
                strDate=readtab(propFile,name,fieldname,'txt');
                object=setfield(object,fieldname,strDate2objDate(strDate));
            case 'id'
                %avoid rewriting the existing id in the object
            otherwise
                cellList=strList2cellList(readtab(propFile,name,fieldname,'txt'));
                object=setfield(object,fieldname,cellList);
%                 object=setfield(object,fieldname,readtab(propFile,name,fieldname,'txt'));
        end
    end
    object=object
    saveExperiment(data,object);
    
    object = getExperiment(data,object.id)
    objectpath=[inPath '\' name]
    if ~exist(objectpath,'dir')
        dos(['mkdir ' objectpath]);
    end
    
    acknows=fs2edAcknows(labProjectName,object,objectpath)  %2020 03 06
    object = getExperiment(data,object.id)
    
    extIdentifiers=fs2edExtIdentifiers(labProjectName,object,objectpath)  %2020 03 06
    object = getExperiment(data,object.id)
    
    upFilesURL=fs2edIdentityImage(labProjectName,object,[objectpath '\IdentityImage'])  %2020 03 06
    object = getExperiment(data,object.id)
    
    %upload dataFiles
    inPathDF=[objectpath '\Datafiles' ]
    
    %there is a problem with DF relations: no new ones can be created
    %2019-11-20
    [upDataFiles,tabDataFiles]=fs2edDatafiles(labProjectName,object,inPathDF)

%%  upload signals
    if ~isempty(object.outputSignals)
%         isel = menu(['The object ' object.name ' already has outputSignals in ED.'],...
%             ['Delete all the existing outputSignals of object ' object.name ' in ED'],...
%             ['Keep the existing outputSignals of object ' object.name ' in ED'],...
%             'Exit');
%         asel={'Delete' 'Keep' 'Exit' };
%         sel=asel{isel}
        sel='Delete'
        switch sel
            case 'Delete'
                for isig=1:length(object.outputSignals)
                    signal=object.outputSignals(isig);
                    delSignal(data,signal);
                end
            case 'Exit'
                object = getExperiment(data,object.id)
                Experiments(iex)=object;
                return
        end
    end
    inPathSig=[objectpath '\Signals' ]
    inPathInfo = dir(inPathSig);
    for iFile=3:length(inPathInfo)
        fn=inPathInfo(iFile).name
        if strcmp(fn([-3:0]+length(fn)),'.csv')
            fid = fopen([inPathSig '\' fn],'r');
            fdata = fread(fid);
            fclose(fid);
            signalsids = uploadOutputSignals(data,object.id,fdata);
        end
    end
    
    object = getExperiment(data,object.id)
    Experiments(iex)=object;
end

end