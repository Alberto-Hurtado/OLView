function [Projects,tab]=ed2fsProjects(ProjectsRef,outpath)
% function [Projects,tab]=ed2fsProjects(ProjectsRef,outpath)
% Migrates Projects set from ELSADATA to File System
% F.J. Molina 2018 04

iarg=2;
if nargin<iarg; outpath=''; end; iarg=iarg-1;
if isempty(outpath); outpath='Projects_FS'; end;

if exist(outpath,'dir')
    %     dos(['rmdir ' outpath '/s /q']);
else
    if ~isempty(ProjectsRef)
        dos(['mkdir ' outpath]);
    end
end

% tabfields={'shortName' 'name' 'description' 'endDate' 'startDate' ...
%  'keywords' 'purpose' 'id'};
% tabfields={'name' 'additionalName' 'description' 'startDate' 'endDate' 'keywords' 'purpose' ...
%     'citationText' 'dataAcknowledgements' 'extIdentifiers' 'id'};  %2019-11
tabfields={'name' 'additionalName' 'description' 'startDate' 'endDate' 'keywords' 'purpose' ...
    'citationText' 'dataStatements' 'id'};  %2020-02
tab=cell(length(ProjectsRef)+1,length(tabfields));
tab(1,:)=tabfields;
for iob=1:length(ProjectsRef)
    object=getProject(data,ProjectsRef(iob).id);
    Projects(iob)=object;
%     for ifield=1:length(tabfields)
%         tab{iob+1,ifield}=getfield(object,tab{1,ifield});
%     end
    for ifield=1:length(tabfields)
        fieldname=tabfields{ifield};
        switch fieldname
            case {'startDate' 'endDate'}
                tab{iob+1,ifield}=objDate2strDate(getfield(object,fieldname));    %2019 11
            otherwise
                tab{iob+1,ifield}=cellList2strList(getfield(object,fieldname));   %2019 11
        end
    end
    disp(sprintf('\n'));
    disp(outpath);
    disp(object.name);
    name=strrep(object.name,' ','_');
    dos(['mkdir ' outpath '\' name]);
    ed2fsProjectProps(object,[outpath '\' name]);
%     ed2fsExtIdentifiers(object.extIdentifiers,[outpath '\' name])    %included in ed2fsProjectProps
%     ed2fsAcknows(object.dataAcknowledgements,[outpath '\' name])    %included in ed2fsProjectProps
%     ed2fsIdentityImages(object.i         %included in ed2fsProjectProps
    
    ed2fsDatafiles(object.datafiles,[outpath '\' name '\Datafiles']);
    ed2fsSpecimens(object.specimens,[outpath '\' name '\Specimens']);
    ed2fsExperiments(object.experimentalActs,[outpath ...
        '\' name '\Experiments']);
end
if exist([outpath '\ProjectsProps.xlsx'],'file')
    dos(['del ' outpath '\ProjectsProps.xlsx']);
end
if ~isempty(ProjectsRef)
    xlswrite([outpath '\ProjectsProps.xlsx'],tab)
end

end