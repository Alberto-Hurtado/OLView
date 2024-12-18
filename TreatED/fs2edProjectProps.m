function project=fs2edProjectProp(labProjectName,inPath,inPropFileName)
% function Project=fs2edProjectProp(labProjectName,inPath,inPropFileName)
% Migrates Project properties from File System to ELSADATA
% F.J. Molina 2019 12

% labProjectName='CALIB2018'
% nargin=1

iarg=3;
if nargin<iarg; inPropFileName=''; end; iarg=iarg-1;
if nargin<iarg; inPath=''; end; iarg=iarg-1;
if nargin<iarg; labProjectName=''; end; iarg=iarg-1;
if isempty(labProjectName);
    error('labProjectName cannot be empty!');
end;
if isempty(inPropFileName); inPropFileName='ProjectProps.xlsx'; end;
if isempty(inPath); inPath=[labpath labProjectName]; end;


% tabfields={'name' 'additionalName' 'description' 'startDate' 'endDate' 'keywords' 'purpose' ...
%     'citationText' 'dataAcknowledgements' 'extIdentifiers' 'dataStatements' 'id'};  %2019-11
tabfields={'name' 'additionalName' 'description' 'startDate' 'endDate' 'keywords' 'purpose' ...
    'citationText' 'dataStatements' 'id'};  %2019-11

% if ~exist(inPath,'dir')
%     dos(['mkdir ' inPath]);
% end
propFile=[inPath '\' inPropFileName]
if ~exist(propFile,'file')
    tab(1,1:length(tabfields))=tabfields;
    tab{2,1}=labProjectName;
    xlswrite(propFile,tab);
end

id=readtab(propFile,labProjectName,'id','txt')
if isempty(id)
        isel = menu(['The id for the project ' labProjectName ' is not written in ' propFile],...
            'Retrieve the id of the project from ED and write it in the props file',...
            'Create the project in ED and write its id in the props file',...
            'Exit');
        asel={'Retrieve the id of object' 'Create object' 'exit' };
        sel=asel{isel}
else
    sel='Use stored id'
end
switch sel
    case 'Retrieve the id of object'
       project = getProjectByName(data,labProjectName);
       id=project.id;
       writetab(propFile,labProjectName,'id',id);
    case 'Create object'
       id = createProject(data);
       writetab(propFile,labProjectName,'id',id);
    case 'Use stored id'
    case 'exit';
    return
end;
project = getProject(data,id)

for ifield=1:length(tabfields)
    fieldname=tabfields{ifield};
    switch fieldname
        case {'startDate' 'endDate'}
            strDate=readtab(propFile,labProjectName,fieldname,'txt');
            project=setfield(project,fieldname,strDate2objDate(strDate));
        case 'dataStatements'    %2019 12
            dataStatements_list=strList2cellList(readtab(propFile,labProjectName,fieldname,'txt'));
            if ~iscell(dataStatements_list)
                dataStatements_list={dataStatements_list};
            end
            if ~isempty(dataStatements_list)
                alldatastatements = getAllDataStatements(data);
                dataStatements = [];
                for iDS=1:length(dataStatements_list)
                    DSname=dataStatements_list{iDS};
                    i1=0;
                    found=false;
                    while i1<length(alldatastatements) & ~found
                        i1=i1+1;
                        found=strcmp(DSname,alldatastatements(i1).name);
                    end
                    if found
                        dataStatements = [dataStatements alldatastatements(i1)];
                    else
                        error(['dataStatement ' DSname ' was not found!'])
                    end
                end
            end
            project=setfield(project,fieldname,dataStatements);
        case 'id'
            %avoid rewriting the existing id in the object
        otherwise
            cellList=strList2cellList(readtab(propFile,labProjectName,fieldname,'txt'));
            project=setfield(project,fieldname,cellList);
    end
end

saveProject(data,project);

acknows=fs2edAcknows(labProjectName,project,inPath)  %2020 03 06
project = getProject(data,id);

extIdentifiers=fs2edExtIdentifiers(labProjectName,project,inPath)  %2020 03 06
project = getProject(data,id);

upFilesURL=fs2edIdentityImage(labProjectName,project,[inPath '\IdentityImage'])  %2020 03 06
project = getProject(data,id);

end

