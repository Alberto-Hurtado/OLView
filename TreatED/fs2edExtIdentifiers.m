function extIdentifiers=fs2edExtIdentifiers(labProjectName,parentObject,inPath,inPropFileName)
% function extIdentifiers=fs2edExtIdentifiers(labProjectName,parentObject,inPath,inPropFileName)
% Migrates an extIdentifiers set from File System to ELSADATA
% F.J. Molina 2019 12

iarg=4;
if nargin<iarg; inPropFileName=''; end; iarg=iarg-1;
if nargin<iarg; inPath=''; end; iarg=iarg-1;
if nargin<iarg; parentObject=''; end; iarg=iarg-1;
if nargin<iarg; labProjectName=''; end; iarg=iarg-1;
if isempty(parentObject);
    error('parentObject cannot be empty!');
end;
if isempty(labProjectName);
    error('labProjectName cannot be empty!');
end;
if isempty(inPropFileName); inPropFileName='ExtIdentifiersProps.xlsx'; end;

project=getProjectByName(data,labProjectName)

if isa(parentObject,'wsdl.data.Project')
    parentObjectClass='Project'
    parentObject=project;
elseif  isa(parentObject,'wsdl.data.Specimen')
    parentObjectClass='Specimen'
    parentObject=getSpecimen(data,parentObject.id);
elseif  isa(parentObject,'wsdl.data.ExperimentalActivity')
    parentObjectClass='Experiment'
    parentObject=getExperiment(data,parentObject.id);
else
    error('parentObject is not Project, Specimen or Experiment!');
end

if isempty(inPath)
    switch parentObjectClass
        case 'Project'
            inPath=[labpath labProjectName];
        case 'Specimen'
            inPath=[labpath labProjectName '\Specimens\' parentObject.name];
        case 'Experiment'
            inPath=[labpath labProjectName '\Experiments\' parentObject.name];
    end
end

tabfields={'idName' 'description' 'idValue' 'url'};

if ~exist(inPath,'dir')
    dos(['mkdir ' inPath]);
end
propFile=[inPath '\' inPropFileName]
if ~exist(propFile,'file')
    tab(1,1:length(tabfields))=tabfields;
    tab{2,1}='';
    xlswrite(propFile,tab);
end
[num,txt,raw] = xlsread(propFile);
EI_list=txt(2:size(txt,1),1); %list of the names
extIdentifiers=[];
for iEI=1:length(EI_list)
    object = wsdl.data.ExternalIdentifier;
    object.idName = EI_list{iEI};
    object.description = readtab(propFile,EI_list{iEI},'description','txt');
    object.idValue = readtab(propFile,EI_list{iEI},'idValue','txt');
    object.url = readtab(propFile,EI_list{iEI},'url','txt');
%     object = object
    extIdentifiers=[extIdentifiers object];
end
parentObject.extIdentifiers=extIdentifiers
switch     parentObjectClass
    case 'Project'
        saveProject(data,parentObject);
    case 'Specimen'
        saveSpecimen(data,parentObject);
    case 'Experiment'
        saveExperiment(data,parentObject);
end

end