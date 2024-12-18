function [upFiles,tab]=fs2edDatafiles(labProjectName,parentObject,inPath,inPropFileName)
% function [upfiles,tab]=fs2edDatafiles(projectName,parentObject,inPath,inPropFileName)
% Migrates a Datafiles set from File System to ELSADATA
% All the files inside of subfolders at inPath will be uploaded to
% ELSADATA. The subfolder name will be used as datafile relation name by
% substituting '_' by blank. The description of the datafile can be
% provided in the properties file inPropFileName.
%
% Subfolder names are added as prefix to the file description. %2020 01
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
            inPath=[labpath labProjectName '\Datafiles' ];
        case 'Specimen'
            inPath=[labpath labProjectName '\Specimens\' parentObject.name '\Datafiles' ];
        case 'Experiment'
            inPath=[labpath labProjectName '\Experiments\' parentObject.name '\Datafiles' ];
    end
end


% tabfields={'name' 'description' 'roleLabel' 'roleLabelDescription'};
tabfields={'name' 'roleLabel' 'description'};

tab(1,1:length(tabfields))=tabfields;
if ~exist(inPath,'dir')
    dos(['mkdir ' inPath]);
end
propFile=[inPath '\' inPropFileName]
if ~exist(propFile,'file')
    xlswrite(propFile,tab);
end
[num,tab0,raw] = xlsread(propFile);
nDocumentedFiles=size(tab0,1)-1;
documentedFileFound=false(nDocumentedFiles,1);

[row,iColName] = find(strcmp(tabfields,'name'));
[row,iColDescription] = find(strcmp(tabfields,'description'));
[row,iColRoleLabel] = find(strcmp(tabfields,'roleLabel'));
% [row,iColRoleLabelDescription] = find(strcmp(tabfields,'roleLabelDescription'));
if nDocumentedFiles>0
    [row,iColName0] = find(strcmp(tab0(1,:),'name'));
    [row,iColDescription0] = find(strcmp(tab0(1,:),'description'));
    [row,iColRoleLabel0] = find(strcmp(tab0(1,:),'roleLabel'));
%     [row,iColRoleLabelDescription0] = find(strcmp(tab0(1,:),'roleLabelDescription'));
    tab = tab0;
%     tab(:,[iColName iColDescription iColRoleLabel iColRoleLabelDescription]) = ...
%         tab0(:,[iColName0 iColDescription0 iColRoleLabel0 iColRoleLabelDescription0]);
    tab(:,[iColName iColRoleLabel iColDescription ]) = ...
        tab0(:,[iColName0 iColRoleLabel0 iColDescription0 ]);
end


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


upFiles=[];
inPathInfo = dir(inPath);
upFile = wsdl.data.UploadFile;
upFile.relatedId = parentObject.id;
for iFolder=3:length(inPathInfo)
    if inPathInfo(iFolder).isdir
        roleLabelFolder=inPathInfo(iFolder).name;
        rolePath=[inPath '\' roleLabelFolder];
        roleInfo = dir(rolePath);
        roleLabelOriginal=strrep(roleLabelFolder,'_',' ')
        roleLabelED=roleLabelOriginal;
        roles=getAllDataFileRelations(data);
        roleNames=cell(size(roles));
        for iRole=1:size(roles)
            roleNames{iRole}=roles(iRole).name;
        end
        iRole = find(strcmp(roleNames,roleLabelED));
        if isempty(iRole)
%             %             isel = menu(['The datafile relation "' roleLabel '" was not found in ED.'],...
%             %                 ['Create the new datafile relation ' roleLabel ' in ED'],...
%             %                 'Exit');
%             %             asel={'Create role' 'Exit' };
%             isel = menu(['The datafile relation "' roleLabel '" was not found in ED.' ...
%                 'You may create it by using function createDFRel'],...
%                 'Exit');
%             asel={ 'Exit' };
%             sel=asel{isel}
%             switch sel
%                 %                 case 'Create role'
%                 %                     relation=data.getBasic;
%                 %                     relation.name=roleLabel;
%                 %                     i1 = find(strcmp(tab(2:size(tab,1),iColRoleLabel),roleLabel));
%                 %                     relation.description=tab{i1+1,iColRoleLabelDescription}
%                 %                     if isempty(relation.description)
%                 %                         relation.description=roleLabel;  % Temporary solution!
%                 %                         display('A temporary description is given to the new data relation!')
%                 %                         display(relation)
%                 %                     end
%                 %                     iRoleParent = find(strcmp(roleNames,'Data file'));
%                 %                     parentRelationId=roles(iRoleParent).id;
%                 %                     id = createDataFileRelation(data,relation,parentRelationId);
%                 %                     roles=getAllDataFileRelations(data);
%                 %                     roleNames=cell(size(roles));
%                 %                     for iRole=1:size(roles)
%                 %                         roleNames{iRole}=roles(iRole).name;
%                 %                     end
%                 %                     iRole = find(strcmp(roleNames,roleLabel));
%                 case 'Exit'
%                     return
%             end
            warning(['The datafile relation "' roleLabelED '" was not found in ED!' ...
                'It will be substituted by datafile relation "Document"!'])
            roleLabelED='Document'
            iRole = find(strcmp(roleNames,roleLabelED));
        end
        role=roles(iRole);
        upFile.relatedRelation = role.id;
        for iFile=3:length(roleInfo)
            if ~roleInfo(iFile).isdir & ~strcmp(roleInfo(iFile).name,'Thumbs.db')
                fileName=roleInfo(iFile).name;
                fid = fopen([rolePath '\' fileName],'r');
                fdata = fread(fid);
                fclose(fid);
                fdata = uint8(fdata);
                lastDate=roleInfo(iFile).date(1:11);
                if size(tab,1)<2
                    irow=size(tab,1)+1;
                    tab{irow,iColName}=fileName;
                    tab{irow,iColDescription}='';
                else
                    i1 = find(strcmp(tab(2:size(tab,1),iColName),fileName));
                    if ~isempty(i1)
                        documentedFileFound(i1) = true;
                        irow=i1+1;
                    else
                        irow=size(tab,1)+1;
                        tab{irow,1}=fileName;
                        tab{irow,iColDescription}='';
                    end
                end
                description = tab{irow,iColDescription};
                tab{irow,iColRoleLabel}=roleLabelOriginal;
%                 tab{irow,iColRoleLabelDescription}=role.description;
                
                upFile.filename = fileName;
                [path1, name1, ext1] = fileparts(fileName);
                upFile.name = name1;
                upFile.description = description;
                upFile.data = fdata;
                upFile.lastModifiedDate=datestr(datenum(lastDate,'dd-mm-yyyy'),'yyyy-mm-dd'); %ISO format
                %                 upFile.lastModifiedDate=strDate2objDate(lastDate,'dd-mm-yyyy');  %Gives error
                %                 upFile.lastModifiedDate='';        % Temporary solution!!
%                 fprintf(' > Uploading [%s] --[%s]--> [%s]\n', role.id, fileName, parentObject.id);
                
                
                %                 upFile = data.getUploadFile(fdata,description,fileName,lastDate, ...
                %                     parentObject.id,role.id);
                switch     parentObjectClass
                    case 'Project'
                        dataFileId = uploadDataFileForProject(data,upFile);
                    case 'Specimen'
                        dataFileId = uploadDataFileForSpecimen(data,upFile);
                    case 'Experiment'
                        dataFileId = uploadDataFileForExperiment(data,upFile);
                end
                upFiles=[upFiles(:); upFile];
            end
        end
    end
end

ii = find(~documentedFileFound);
if ~isempty(ii)
    propFileBK=[propFile '_backup_' datestr(now, 'yyyy-mm-dd_MMSS') '.xlsx'];
    display(['The following documented files in ' propFile ' were not found'])
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

