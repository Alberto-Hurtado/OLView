function upFilesURL=fs2edIdentityImage(labProjectName,parentObject,inPath)
% function upFilesURL=fs2edIdentityImage(projectName,parentObject,inPath)
% Assigns an IdentityImages set at inPath from File System to an ELSADATA parent object
%
% F.J. Molina 2019 12



% projectName='SLABSTRESS'  %for debugging
% parentObject=getProjectByName(data,projectName)
% nargin=2




% iarg=4;
% if nargin<iarg; inPropFileName=''; end; iarg=iarg-1;
iarg=3;
if nargin<iarg; inPath=''; end; iarg=iarg-1;
if nargin<iarg; parentObject=''; end; iarg=iarg-1;
if nargin<iarg; labProjectName=''; end; iarg=iarg-1;
% function [upFilesURL,tab]=fs2edIdentityImages(labProjectName,parentObject,inPath,inPropFileName)
if isempty(parentObject);
    error('parentObject cannot be empty!');
end;
if isempty(labProjectName);
    error('projectName cannot be empty!');
end;
% if isempty(inPropFileName); inPropFileName='IdentityImagesProps.xlsx'; end;

project=getProjectByName(data,labProjectName);

if isa(parentObject,'wsdl.data.Project')
    parentObjectClass='Project'
    parentObject=getProject(data,project.id)
elseif  isa(parentObject,'wsdl.data.Specimen')
    parentObjectClass='Specimen'
    parentObject=getSpecimen(data,parentObject.id)
elseif  isa(parentObject,'wsdl.data.ExperimentalActivity')
    parentObjectClass='Experiment'
    parentObject=getExperiment(data,parentObject.id)
else
    error('parentObject is not Project, Specimen or Experiment!');
end

if isempty(inPath)
    switch parentObjectClass
        case 'Project'
            inPath=[labpath labProjectName '\IdentityImage' ];
        case 'Specimen'
            inPath=[labpath labProjectName '\Specimens\' parentObject.name '\IdentityImage' ];
        case 'Experiment'
            inPath=[labpath labProjectName '\Experiments\' parentObject.name '\IdentityImage' ];
    end
end


if ~exist(inPath,'dir')
    dos(['mkdir ' inPath]);
end

% tabfields={'name' 'description' 'id'};
% tab(1,1:length(tabfields))=tabfields;
% propFile=[inPath '\' inPropFileName]
% if ~exist(propFile,'file')
%     xlswrite(propFile,tab);
% end
% [num,tab0,raw] = xlsread(propFile);
% nDocumentedFiles=size(tab0,1)-1;
% documentedFileFound=false(nDocumentedFiles,1);
% 
% [row,iColName] = find(strcmp(tabfields,'name'));
% [row,iColDescription] = find(strcmp(tabfields,'description'));
% [row,iColId] = find(strcmp(tabfields,'id'));
% if nDocumentedFiles>0
%     [row,iColName0] = find(strcmp(tab0(1,:),'name'));
%     [row,iColDescription0] = find(strcmp(tab0(1,:),'description'));
%     [row,iColId0] = find(strcmp(tab0(1,:),'id'));
%     tab = tab0;
%     tab(:,[iColName iColDescription iColId ]) = ...
%         tab0(:,[iColName0 iColDescription0 iColId0 ]);
% end


if ~isempty(parentObject.identityImageIris)
%     isel = menu(['The object ' parentObject.name ' already has IdentityImages in ED.'],...
%         ['Delete all the existing IdentityImages of object ' parentObject.name ' in ED'],...
%         ['Keep the existing IdentityImages of object ' parentObject.name ' in ED'],...
%         'Exit');
%     asel={'Delete' 'Keep' 'Exit' };
%     sel=asel{isel}
    sel='Delete';
    switch sel
        case 'Delete'
            switch     parentObjectClass
                case 'Project'
                    delIdentityImageForProject(data,parentObject.id);
                    parentObject=getProject(data,parentObject.id);
                case 'Specimen'
                    delIdentityImageForSpecimen(data,parentObject.id); %2020 03 06 this functions does not make the delete!
                    parentObject=getSpecimen(data,parentObject.id);
                case 'Experiment'
                    delIdentityImageForExperiment(data,parentObject.id);
                    parentObject=getExperiment(data,parentObject.id);
            end
        case 'Exit'
            return
    end
end




upFilesURL={};
inPathInfo = dir(inPath);
upFile = wsdl.data.UploadFile;
upFile.relatedId = parentObject.id;
nImages=0;
for iFile=3:length(inPathInfo)
    fileName=inPathInfo(iFile).name;
%     if ~strcmp(fileName,'Thumbs.db') & ~strcmp(fileName,inPropFileName)
    if ~strcmp(fileName,'Thumbs.db')
        nImages = nImages + 1;
        if nImages > 1
            error('Current CDV version allows for only one Icon!!')
        end
        fid = fopen([inPath '\' fileName],'r');
        fdata = fread(fid);
        fclose(fid);
        fdata = uint8(fdata);
        lastDate=inPathInfo(iFile).date(1:11);
%         if size(tab,1)<2
%             irow=size(tab,1)+1;
%             tab{irow,iColName}=fileName;
%             tab{irow,iColDescription}='';
%         else
%             i1 = find(strcmp(tab(2:size(tab,1),iColName),fileName));
%             if ~isempty(i1)
%                 documentedFileFound(i1) = true;
%                 irow=i1+1;
%             else
%                 irow=size(tab,1)+1;
%                 tab{irow,iColName}=fileName;
%                 tab{irow,iColDescription}='';
%             end
%         end
%         if isempty(tab{irow,iColDescription})
%             tab{irow,iColDescription}=fileName;
%         end
        upFile.filename = fileName;
        [path1, name1, ext1] = fileparts(fileName);
        upFile.name = name1;
%         upFile.description = tab{irow,iColDescription};
        upFile.description = fileName;
        upFile.data = fdata;
        upFile.lastModifiedDate=datestr(datenum(lastDate,'dd-mm-yyyy'),'yyyy-mm-dd') %ISO format
        switch     parentObjectClass
            case 'Project'
                iconURL  = uploadIdentityImageForProject(data,upFile)
            case 'Specimen'
                iconURL  = uploadIdentityImageForSpecimen(data,upFile)
            case 'Experiment'
                iconURL  = uploadIdentityImageForExperiment(data,upFile)
        end
        upFilesURL={upFilesURL{:} iconURL};
%         tab{irow,iColId}=iconURL;
    end
end

switch     parentObjectClass
    case 'Project'
        parentObject=getProject(data,parentObject.id)
    case 'Specimen'
        parentObject=getSpecimen(data,parentObject.id)
    case 'Experiment'
        parentObject=getExperiment(data,parentObject.id)
end

% ii = find(~documentedFileFound);
% if ~isempty(ii)
%     propFileBK=[propFile '_backup_' datestr(now, 'yyyy-mm-dd_MMSS') '.xlsx'];
%     display(['The following documented files in ' propFile ' were not found'])
%     display(['and this list will be back up in ' propFileBK ':'])
%     for i=1:length(ii)
%         display(tab(ii(i)+1,:));
%     end
%     xlswrite(propFileBK,tab([1,ii'+1],:));
%     tab(ii+1,:)=[];
% end

% [B,I]=sort(tab(2:size(tab,1),iColId)); %orders by id
% tab(2:size(tab,1),:)=tab(1+I,:); %reordered tab
% upFilesURL=upFilesURL(I);

% if exist(propFile,'file')
%     dos(['del ' propFile]);
% end
% xlswrite(propFile,tab)

end

