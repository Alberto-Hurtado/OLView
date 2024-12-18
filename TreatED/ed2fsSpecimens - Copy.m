function [Specimens,tab]=ed2fsSpecimens(SpecimensRef,outpath)
% function [Specimens,tab]=ed2fsSpecimens(SpecimensRef,outpath)
% Migrates Specimens set from ELSADATA to File System
% Destination folder outpath will be cleared before migration!
% F.J. Molina 2018 04

iarg=2;
if nargin<iarg; outpath=''; end; iarg=iarg-1;
if isempty(outpath); outpath='Specimens'; end;

disp(outpath);
if exist(outpath,'dir')
    dos(['rmdir ' outpath '/s /q']);
else
    if ~isempty(SpecimensRef)
        dos(['mkdir ' outpath]);
    end
end

tabfields={'name' 'description' 'keywords' 'purpose' 'experimentalActs' ...
    'startDate' 'endDate' 'id'};
tab=cell(length(SpecimensRef),length(tabfields));
tab(1,:)=tabfields;
for iob=1:length(SpecimensRef)
    object=getSpecimen(data,SpecimensRef(iob).id);
    Specimens(iob)=object;
    for ifield=1:length(tabfields)
        fieldname=tabfields{ifield};
        switch fieldname
            case {'startDate' 'endDate'}
                tab{1+iob,ifield}=objDate2strDate(getfield(object,fieldname));
            otherwise
                tab{1+iob,ifield}=cellList2strList(getfield(object,fieldname));
        end
    end
    name=object.name;
    name=simplestr(name);
    disp(name);
    dos(['mkdir ' outpath '\' name]);
    [Datafiles,dataf_tab]=ed2fsDatafiles(object.datafiles, ...
        [outpath '\' name '\Datafiles']);
end
if exist([outpath '\SpecimensProps.xlsx'],'file')
    dos(['del ' outpath '\SpecimensProps.xlsx']);
end
xlswrite([outpath '\SpecimensProps.xlsx'],tab)

end