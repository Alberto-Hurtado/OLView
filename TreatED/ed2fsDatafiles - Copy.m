function [Datafiles,tab]=ed2fsDatafiles(DatafilesRef,outpath)
% function [Datafiles,tab=ed2fsDatafiles(DatafilesRef,outpath)
% Migrates Datafiles set from ELSADATA to File System
% Destination folder outpath will be cleared before migration!
% F.J. Molina 2018 04

iarg=2;
if nargin<iarg; outpath=''; end; iarg=iarg-1;
if isempty(outpath); outpath='Datafiles'; end;

if exist(outpath,'dir')
% if exist([outpath '\DatafilesProps.xlsx'],'file')
%     dos(['del ' outpath '\DatafilesProps.xlsx']);
% end
        dos(['rmdir ' outpath '/s /q']);
else
    if ~isempty(DatafilesRef)
        dos(['mkdir ' outpath]);
    end
end

Datafiles=DatafilesRef;

tabfields={'name' 'roleLabel' 'description'};
tab=cell(length(DatafilesRef)+1,length(tabfields));
tab(1,:)=tabfields;
for idf=1:length(DatafilesRef)
    for ifield=1:length(tabfields)
        tab{idf+1,ifield}=getfield(DatafilesRef(idf),tabfields{ifield});
    end
end

[dum,ifield_name]=find(strcmp(tabfields,'name'));
[dum,I]=sort(tab(2:(length(DatafilesRef)+1),ifield_name)); %orders by name
tab(2:(length(DatafilesRef)+1),:)=tab(1+I,:); %reordered tab
Datafiles=Datafiles(I);
for idf=1:length(DatafilesRef)
    name=tab{idf+1,ifield_name};
    name=simplestr(name)
    if idf==1 
        name_previous=name;
    else
        if strcmp(name,name_previous)
            name=[tab{idf,ifield_name} 'I']; %Avoid duplicated name
        end
    end
%     disp(name);
    Datafiles(idf).name=name;
    tab{idf+1,ifield_name}=name;
    roleLabel=Datafiles(idf).roleLabel;
    roleLabel1=strrep(roleLabel,' ','_');
    if ~exist([outpath '\' roleLabel1],'dir')
        dos(['mkdir ' outpath '\' roleLabel1]);
    end
%     outfile=websave([outpath '\' roleLabel1 '\' Datafiles(idf).name], ...
%         Datafiles(idf).downloadIRI);
    websaveS([outpath '\' roleLabel1 '\' Datafiles(idf).name], ...
        Datafiles(idf).downloadIRI);   %2019 11 13
end

[dum,ifield_roleLabel]=find(strcmp(tabfields,'roleLabel'));
[B,I]=sort(tab(2:(length(Datafiles)+1),ifield_roleLabel)); %orders by roleLabel
tab(2:(length(Datafiles)+1),:)=tab(1+I,:); %reordered tab
Datafiles=Datafiles(I);
if ~isempty(Datafiles)
    xlswrite([outpath '\DatafilesProps.xlsx'],tab)
end

end