function [datafiles,tab]=ed2fsDatafiles(datafilesRef,outpath,outPropFileName)
% function [datafiles,tab=ed2fsDatafiles(datafilesRef,outpath,outPropFileName)
% Migrates datafiles set from ELSADATA to File System
% Destination folder outpath will be cleared before migration!
%
% Subfolder names are added as prefix to the datafile name. %2020 01
%
% F.J. Molina 2018 04

iarg=3;
if nargin<iarg; outPropFileName=''; end; iarg=iarg-1;
if nargin<iarg; outpath=''; end; iarg=iarg-1;
if isempty(outPropFileName); outPropFileName='DatafilesProps.xlsx'; end;
if isempty(outpath); outpath='Datafiles'; end;

if exist(outpath,'dir')
    dos(['rmdir ' outpath '/s /q']);
end
if ~isempty(datafilesRef)
    dos(['mkdir ' outpath]);
end

%% fill in table of datafiles properties
% tabfields={'name' 'roleLabel' 'description' 'subfolder' 'fileName'};   %2020 01 30
tabfields={'name' 'roleLabel' 'description' 'subfolder'};   %2020 02
tab=cell(length(datafilesRef)+1,length(tabfields));
tab(1,:)=tabfields;
[row,iColName] = find(strcmp(tabfields,'name'));
[row,iColRoleLabel] = find(strcmp(tabfields,'roleLabel'));
[row,iColDescription] = find(strcmp(tabfields,'description'));
[row,iColSubfolder] = find(strcmp(tabfields,'subfolder'));
% [row,iColFileName] = find(strcmp(tabfields,'fileName'));
for idf=1:length(datafilesRef)
    tab{idf+1,iColName}=getfield(datafilesRef(idf),'name');
    tab{idf+1,iColRoleLabel}=getfield(datafilesRef(idf),'roleLabel');
%     tab{idf+1,iColDescription}=getfield(datafilesRef(idf),'description');
    tab{idf+1,iColDescription}=getfield(datafilesRef(idf),'description');
    tab{idf+1,iColRoleLabel}=getfield(datafilesRef(idf),'roleLabel');
    descriptionED=getfield(datafilesRef(idf),'description');
    cellDescription=strList2cellList(descriptionED,1);
    switch length(cellDescription)
        case 2
        subfolderName=cellDescription{1}; %name is composed of subfolderName
        description=cellDescription{2}; 
        case 1
        subfolderName = ''; 
        description=cellDescription{1}; 
        case 0
        subfolderName = ''; 
        description=''; 
    end        
    tab{idf+1,iColSubfolder}=subfolderName;
    tab{idf+1,iColDescription}=description;
%     fileName=simplestr(fileName);  %replaces extrange characters
%     tab{idf+1,iColFileName}=description;
end


datafiles=datafilesRef;

% [dum,iColName]=find(strcmp(tabfields,'name'));
[dum,I]=sort(tab(2:(length(datafilesRef)+1),iColName)); %orders by name
tab(2:(length(datafilesRef)+1),:)=tab(1+I,:); %reordered tab
datafiles=datafiles(I);
for idf=1:length(datafilesRef)
    roleLabelED = tab{idf+1,iColRoleLabel};
    subfolderName = tab{idf+1,iColSubfolder};
    name=tab{idf+1,iColName};
    folderName = strrep(roleLabelED,' ','_');
%     fileName = tab{idf+1,iColFileName};
%     fileName = name;
    if idf>1 
        if strcmp(name,tab{idf,iColName}) && strcmp(roleLabelED,tab{idf,iColRoleLabel}) && ...
                strcmp(subfolderName,tab{idf,iColSubfolder})
            name=[tab{idf,iColName} 'I']; %Avoid duplicated name
%             fileName=[tab{idf,iColFileName} 'I']; %Avoid duplicated name
        end
    end
%     datafiles(idf).name=name;
    tab{idf+1,iColName}=name;
%     tab{idf+1,iColFileName}=fileName;
    workingPath = [outpath '\' folderName];
    if ~exist(workingPath,'dir')
        dos(['mkdir ' workingPath]);
        disp(workingPath)
    end
    if ~isempty(subfolderName)
        workingPath = [workingPath '\' subfolderName];
        if ~exist(workingPath,'dir')
            dos(['mkdir ' workingPath]);
            disp(workingPath)
        end
    end
%     outfile=websave([outpath '\' roleLabel1 '\' datafiles(idf).name], ...
%         datafiles(idf).downloadIRI);
%     websaveS([workingPath '\' fileName],datafiles(idf).downloadIRI);   %2019 11 13
    websaveS([workingPath '\' name],datafiles(idf).downloadIRI);   %2019 11 13
end

% [dum,iColRoleLabel]=find(strcmp(tabfields,'roleLabel'));
[B,I]=sort(tab(2:(length(datafiles)+1),iColRoleLabel)); %orders by roleLabel
tab(2:(length(datafiles)+1),:)=tab(1+I,:); %reordered tab
datafiles=datafiles(I);
if ~isempty(datafiles)
    xlswrite([outpath '\' outPropFileName],tab)
end

end