function project=fs2edProjectProp(projectShortName,inpath,infilename)
% function Project=fs2edProjectProp(projectShortName,inpath,infilename)
% Migrates Project properties from File System to ELSADATA
% F.J. Molina 2019 03

% projectShortName='CALIB2018'
% nargin=1

iarg=3;
if nargin<iarg; infilename=''; end; iarg=iarg-1;
if nargin<iarg; inpath=''; end; iarg=iarg-1;
if nargin<iarg; projectShortName=''; end; iarg=iarg-1;
if isempty(projectShortName);
    error('projectShortName cannot be empty!');
end;
if isempty(infilename); infilename='ProjectProps.xlsx'; end;
if isempty(inpath); inpath=[labpath projectShortName]; end;


% [num,txt,raw] = xlsread(propFile);
tabfields={'shortName' 'name' 'description' 'startDate' 'endDate' 'keywords' 'purpose' 'id'};

if ~exist(inpath,'dir')
    dos(['mkdir ' inpath]);
end
propFile=[inpath '\' infilename]
if ~exist(propFile,'file')
    tab(1,1:length(tabfields))=tabfields;
    tab{2,1}=projectShortName;
    xlswrite(propFile,tab);
end

id=readtab(propFile,projectShortName,'id','txt')
if isempty(id)
        isel = menu(['The id for the project ' projectShortName ' is not written in ' propFile],...
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
       project = getProjectByName(data,projectShortName);
       id=project.id;
       writetab(propFile,projectShortName,'id',id);
    case 'Create object'
       id = createProject(data);
       writetab(propFile,projectShortName,'id',id);
    case 'Use stored id'
    case 'exit';
    return
end;
project = getProject(data,id)

for ifield=1:length(tabfields)
    fieldname=tabfields{ifield};
    switch fieldname
%         case {'experimentalActs' 'specimens' 'datafiles' ...
%                 'participants' 'identityImageIris' ...
%                 'intellectualPropertyOwners' 'dataRights'}
%             % This content is not collected here
        case 'keywords'
            string=readtab(propFile,projectShortName,fieldname,'txt');
            i_sep=strfind(string,'##');
            i_sep=[i_sep length(string)+1];
            list={};
            for iElement=1:length(i_sep)
                if iElement==1
                    list{iElement}=string(1:i_sep(iElement)-1);
                else
                    list{iElement}=string(i_sep(iElement-1)+2:i_sep(iElement)-1);
                end
            end
            project=setfield(project,fieldname,list);
        case {'startDate' 'endDate'}
            DateString=readtab(propFile,projectShortName,fieldname,'txt')
            DateNumber = datenum(DateString,'dd/mm/yyyy') %This format is assumed by excel if declared as text
            DateString2 = datestr(DateNumber,'yyyy-mm-dd') %ISO format
            CdvDateObj = data.getCdvDate(DateString,DateString2)
            project=setfield(project,fieldname,CdvDateObj)
        case 'id'
            %avoid rewriting the existing id
        otherwise
            project=setfield(project,fieldname,readtab(propFile,projectShortName,fieldname,'txt'));
    end
end
    %upload also dataFiles here
%     fs2edDatafiles('project',spcpath]);

saveProject(data,project);
project = getProject(data,id);

end