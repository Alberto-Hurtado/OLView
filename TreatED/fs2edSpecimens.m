function Specimens=fs2edSpecimens(labProjectName,specimens_list,inPath,inPropFileName)
% function Specimens=fs2edSpecimens(labProjectName,specimens_list,inPath,inPropFileName)
% Migrates a specimens set from File System to ELSADATA
% F.J. Molina 2019 03


% labProjectName='CALIB2018'  %for debugging
% specimens_list={'actuator-03a' 'actuator-01'}
% nargin=2

iarg=4;
if nargin<iarg; inPropFileName=''; end; iarg=iarg-1;
if nargin<iarg; inPath=''; end; iarg=iarg-1;
if nargin<iarg; specimens_list=''; end; iarg=iarg-1;
if nargin<iarg; labProjectName=''; end; iarg=iarg-1;
if isempty(labProjectName);
    error('labProjectName cannot be empty!');
end;
if isempty(inPropFileName); inPropFileName='SpecimensProps.xlsx'; end;
if isempty(inPath); inPath=[labpath labProjectName '\Specimens' ]; end;

project = getProjectByName(data,labProjectName);
tabfields={'name' 'description' 'keywords' 'purpose' 'startDate' 'endDate' 'id'};

if ~exist(inPath,'dir')
    dos(['mkdir ' inPath]);
end
propFile=[inPath '\' inPropFileName]
if ~exist(propFile,'file')
    tab(1,1:length(tabfields))=tabfields;
    tab{2,1}='';
    xlswrite(propFile,tab);
end
if isempty(specimens_list)
    [num,txt,raw] = xlsread(propFile);
    specimens_list=txt(2:size(txt,1),1);
end
for isp=1:length(specimens_list)
    name=specimens_list{isp}
    id=readtab(propFile,name,'id','txt')
    if isempty(id)
%         isel = menu(['The id for the specimen ' name ' is not written in ' propFile],...
%             'Retrieve the id of the specimen from ED and write it in the props file',...
%             'Create the specimen in ED and write its id in the props file',...
%             'Exit');
%         asel={'Retrieve the id of object' 'Create object' 'exit' };
%         sel=asel{isel}
        sel='Create object'
    else
        sel='Use stored id'
    end
    switch sel
        case 'Retrieve the id of object'
            i1=0;
            found=false;
            while i1<length(project.specimens) & ~found
                i1=i1+1;
                found=strcmp(name,project.specimens(i1).name);
            end
            if found
                id=project.specimens(i1).id
            else
                error(['Specimen ' name ' was not found in project ' labProjectName '!'])
            end
        case 'Create object'
            id = createSpecimenForProject(data,project.id)
        case 'exit';
            return
    end;
    object = getSpecimen(data,id);
    writetab(propFile,name,'id',id);
    for ifield=1:length(tabfields)
        fieldname=tabfields{ifield};
        switch fieldname
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
%     object=object
    saveSpecimen(data,object);
    
    object = getSpecimen(data,object.id);
    objectpath=[inPath '\' name]
    if ~exist(objectpath,'dir')
        dos(['mkdir ' objectpath]);
    end
    
    acknows=fs2edAcknows(labProjectName,object,objectpath)  %2020 03 06
    object = getSpecimen(data,object.id);
    
    extIdentifiers=fs2edExtIdentifiers(labProjectName,object,objectpath)  %2020 03 06
    object = getSpecimen(data,object.id);
    
    upFilesURL=fs2edIdentityImage(labProjectName,object,[objectpath '\IdentityImage'])  %2020 03 06
    object = getSpecimen(data,object.id);
    
    %upload dataFiles
    inPathDF=[objectpath '\Datafiles' ];
    [upDataFiles,tabDataFiles]=fs2edDatafiles(labProjectName,object,inPathDF);
    
    object = getSpecimen(data,object.id)
    Specimens(isp)=object;
end

end