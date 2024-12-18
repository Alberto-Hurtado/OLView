function [upFiles,tab]=fs2edDatafiles(labProjectName,parentObject,inPath,inPropFileName)
% function [upfiles,tab]=fs2edDatafiles(projectName,parentObject,inPath,inPropFileName)
% Migrates a Datafiles set from File System to ELSADATA
% All the files inside of subfolders at inPath will be uploaded to
% ELSADATA. The subfolder name will be used as datafile relation name by
% substituting '_' by blank. The description of the datafile can be
% provided in the properties file inPropFileName.
%
% Subfolder names are added as prefix to the datafile description. %2020 02
%
% F.J. Molina 2019 04



% projectName='CALIB2018'  %for debugging
% project1 = getProjectByName(data,projectName)
% % parentObject=project1.specimens(1)
% parentObject=project1
% nargin=2




iarg=4;
if nargin<iarg; inPropFileName=''; end; iarg=iarg-1;
if nargin<iarg; inPath=''; end; iarg=iarg-1;
if nargin<iarg; parentObject=''; end; iarg=iarg-1;
if nargin<iarg; labProjectName=''; end; iarg=iarg-1;
if isempty(parentObject);
    error('parentObject cannot be empty!');
end;
if isempty(labProjectName);
    error('projectName cannot be empty!');
end;
if isempty(inPropFileName); inPropFileName='DatafilesProps.xlsx'; end;

project=getProjectByName(data,labProjectName);

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
            inPath=[labpath labProjectName '\Datafiles' ]
        case 'Specimen'
            inPath=[labpath labProjectName '\Specimens\' parentObject.name '\Datafiles' ]
        case 'Experiment'
            inPath=[labpath labProjectName '\Experiments\' parentObject.name '\Datafiles' ]
    end
end


% tabfields={'name' 'roleLabel' 'description' 'subfolder' 'fileName'};   %2020 01 30
tabfields={'name' 'roleLabel' 'description' 'subfolder'};   %2020 02

tab(1,1:length(tabfields))=tabfields;
if ~exist(inPath,'dir')
    dos(['mkdir ' inPath]);
end
propFile=[inPath '\' inPropFileName]
if ~exist(propFile,'file')
    xlswrite(propFile,tab);
end

%% Re-arrage existing table to the standard order of columns
[num,tab0,raw] = xlsread(propFile);
nDocumentedFiles=size(tab0,1)-1;
docFileFoundVector=false(nDocumentedFiles,1);
[row,iColName] = find(strcmp(tabfields,'name'));
[row,iColRoleLabel] = find(strcmp(tabfields,'roleLabel'));
[row,iColDescription] = find(strcmp(tabfields,'description'));
[row,iColSubfolder] = find(strcmp(tabfields,'subfolder'));
% [row,iColFileName] = find(strcmp(tabfields,'fileName'));
if nDocumentedFiles>0
    [row,iColName0] = find(strcmp(tab0(1,:),'name'));
    [row,iColRoleLabel0] = find(strcmp(tab0(1,:),'roleLabel'));
    [row,iColDescription0] = find(strcmp(tab0(1,:),'description'));
    [row,iColSubfolder0] = find(strcmp(tab0(1,:),'subfolder'));
%     [row,iColFileName0] = find(strcmp(tab0(1,:),'fileName'));
    if isempty(iColSubfolder0)    % 2020-01-29
        newCol=cell(size(tab0,1),1);
        newCol{1}='subfolder';
        tab0(:,size(tab0,2)+1)=newCol;
        [row,iColSubfolder0] = find(strcmp(tab0(1,:),'subfolder'));
    end
%     if isempty(iColFileName0)    % 2020-01-29
%         newCol=cell(size(tab0,1),1);
%         newCol{1}='fileName';
%         tab0(:,size(tab0,2)+1)=newCol;
%         [row,iColFileName0] = find(strcmp(tab0(1,:),'fileName'));
%     end
    tab = tab0;
    tab(:,[iColName iColRoleLabel iColDescription iColSubfolder]) = ...
        tab0(:,[iColName0 iColRoleLabel0 iColDescription0 iColSubfolder0]);
end

%% delete previous uploaded files
if ~isempty(parentObject.datafiles)
    %     isel = menu(['The object ' parentObject.name ' already has datafiles in ED.'],...
    %         ['Delete all the existing datafiles of object ' parentObject.name ' in ED'],...
    %         ['Keep the existing datafiles of object ' parentObject.name ' in ED'],...
    %         'Exit');
    %     asel={'Delete' 'Keep' 'Exit' };
    %     sel=asel{isel}
    sel='Delete'
    switch sel
        case 'Delete'
            disp(['Deleting all the existing datafiles of object ' parentObject.name ' in ED'])
            for iFile=1:length(parentObject.datafiles)
                dfile=parentObject.datafiles(iFile);
                switch     parentObjectClass
                    case 'Project'
                        delDataFileForProject(data,parentObject.id,dfile);
                    case 'Specimen'
                        delDataFileForSpecimen(data,parentObject.id,dfile);
                    case 'Experiment'
                        delDataFileForExperiment(data,parentObject.id,dfile);
                end
            end
        case 'Exit'
            return
    end
end


%% existing dafile roles
rolesAll=getAllDataFileRelations(data);
roleNamesAll=cell(size(rolesAll));
for iRole=1:size(rolesAll)
    roleNamesAll{iRole}=rolesAll(iRole).name;
end
        
%% upload specified files
upFiles=[];
inPathInfo = dir(inPath);
for iFolder=3:length(inPathInfo)
    if inPathInfo(iFolder).isdir
        folderName=inPathInfo(iFolder).name;
        folderInfo = dir([inPath '\' folderName]);
        roleLabel=strrep(folderName,'_',' ')
        roleLabelED=roleLabel;
        iRole = find(strcmp(roleNamesAll,roleLabelED));
        if isempty(iRole)
            
%             warning(['The datafile relation "' roleLabelED '" was not found in ED!' ...   %elsadata-mirror cannot create DF rel!!
%                 'It will be substituted by datafile relation "Document"!'])
%             roleLabelED='Document'
%             iRole = find(strcmp(roleNamesAll,roleLabelED));

            error(['The datafile relation "' roleLabelED '" was not found in ED!'])  %please create that DF in elsadata-local
            
        end
        role=rolesAll(iRole);
        for iFile=3:length(folderInfo)
            if folderInfo(iFile).isdir                    %this is a subfolder
                subfolderName=folderInfo(iFile).name
                workingPath=[inPath '\' folderName '\' subfolderName];
                subfolderInfo = dir(workingPath);
                for iFileSub=3:length(subfolderInfo)
                    if ~strcmp(subfolderInfo(iFileSub).name,'Thumbs.db')
                        fileName=subfolderInfo(iFileSub).name;
                        lastDate=subfolderInfo(iFileSub).date(1:11);
%                         name=[subfolderName '##' fileName];  %subfolder is coded as a prefix in the name
                        name=fileName; 
                        irow=size(tab,1)+1;
                        if size(tab,1)>1
                            i1 = find(strcmp(tab(2:size(tab,1),iColName),name));
                            if ~isempty(i1)
                                if strcmp(tab(i1+1,iColRoleLabel),roleLabel)
                                    if strcmp(tab(i1+1,iColSubfolder),subfolderName)
                                        docFileFoundVector(i1) = true;
                                        irow=i1+1;
                                    end
                                end
                            end
                        end
                        tab{irow,iColName}=name;
                        tab{irow,iColRoleLabel}=roleLabel;
                        tab{irow,iColSubfolder}=subfolderName;
%                         tab{irow,iColFileName}=fileName;
%                         description = tab{irow,iColDescription};
                        description = [subfolderName '##' tab{irow,iColDescription}];  %subfolder is coded as a prefix in the description
%                         description = cellList2strList({subfolderName tab{irow,iColDescription}});
                        upFile=uploadFile(name,workingPath,fileName,description,lastDate, ...
                            role,parentObject.id,parentObjectClass);
                        upFiles=[upFiles(:); upFile];
                    end
                end
            else
                subfolderName='';
                workingPath=[inPath '\' folderName '\' subfolderName];
                if ~strcmp(folderInfo(iFile).name,'Thumbs.db')
                    fileName=folderInfo(iFile).name;
                    lastDate=folderInfo(iFile).date(1:11);
                    name=fileName;
                    irow=size(tab,1)+1;
                    if size(tab,1)>1
                        i1 = find(strcmp(tab(2:size(tab,1),iColName),name));
                        if ~isempty(i1)
                            if strcmp(tab(i1+1,iColRoleLabel),roleLabel)
                                docFileFoundVector(i1) = true;
                                irow=i1+1;
                            end
                        end
                    end
                    tab{irow,iColName}=name;
                    tab{irow,iColRoleLabel}=roleLabel;
                    tab{irow,iColSubfolder}=subfolderName;
%                     tab{irow,iColFileName}=fileName;
                    description = tab{irow,iColDescription};
                    %                 [workingPath1, name1, ext1] = fileparts(fileName);
                    %                 name=[name1 ext1];
                    upFile=uploadFile(name,workingPath,fileName,description,lastDate, ...
                        role,parentObject.id,parentObjectClass);
                    upFiles=[upFiles(:); upFile];
                end
            end
        end
    end
end

ii = find(~docFileFoundVector);
if ~isempty(ii)
    propFileBK=[propFile '_backup_' datestr(now, 'yyyy-mm-dd_MMSS') '.xlsx'];
    display(['The following documented files in previous ' propFile ' were not found'])
    display(['and this list will be back up in ' propFileBK ':'])
    for i=1:length(ii)
        display(tab(ii(i)+1,:));
    end
    xlswrite(propFileBK,tab([1,ii'+1],:));
    tab(ii+1,:)=[];
end
[B,I]=sort(tab(2:size(tab,1),iColRoleLabel)); %orders by roleLabel
tab(2:size(tab,1),:)=tab(1+I,:); %reordered tab
upFiles=upFiles(I);

if exist(propFile,'file')
    dos(['del ' propFile]);
end
xlswrite(propFile,tab)

end



function upFile=uploadFile(name,workingPath,fileName,description,lastDate,role,parentObjectId,parentObjectClass)
% Upload one datafile

fid = fopen([workingPath '\' fileName],'r');
fdata = fread(fid);
fclose(fid);
fdata = uint8(fdata);

upFile = wsdl.data.UploadFile;
upFile.relatedId = parentObjectId;
upFile.relatedRelation = role.id;
upFile.filename = fileName;
upFile.name = name;
upFile.description = description;
upFile.data = fdata;
upFile.lastModifiedDate=datestr(datenum(lastDate,'dd-mm-yyyy'),'yyyy-mm-dd'); %ISO format
switch     parentObjectClass
    case 'Project'
        dataFileId = uploadDataFileForProject(data,upFile);
    case 'Specimen'
        dataFileId = uploadDataFileForSpecimen(data,upFile);
    case 'Experiment'
        dataFileId = uploadDataFileForExperiment(data,upFile);
end

end








