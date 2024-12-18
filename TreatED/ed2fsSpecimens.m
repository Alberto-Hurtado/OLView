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
                tab{1+iob,ifield}=objDate2strDate(getfield(object,fieldname));   %2019 11
            otherwise
                tab{1+iob,ifield}=cellList2strList(getfield(object,fieldname));   %2019 11
        end
    end
end

[dum,ifield_name]=find(strcmp(tabfields,'name'));
[dum,I]=sort(tab(2:(length(SpecimensRef)+1),ifield_name)); %orders by name
tab(2:(length(SpecimensRef)+1),:)=tab(1+I,:); %reordered tab
Specimens=Specimens(I);
for iob=1:length(SpecimensRef)
    object=getSpecimen(data,SpecimensRef(iob).id);
    name=tab{1+iob,ifield_name};
    name=simplestr(name);
    if iob==1
        name_previous=name;
    else
        if strcmp(name,name_previous)
            name=[tab{iob,ifield_name} 'I']; %Avoid duplicated name
        end
    end
    disp(name);
    Specimens(iob).name=name;
    tab{1+iob,ifield_name}=name;
    dos(['mkdir ' outpath '\' name]);

    acknows_tab=ed2fsAcknows(object.dataAcknowledgements,[outpath '\' name])  %2020 03 06
    extIdentifiers_tab=ed2fsExtIdentifiers(object.extIdentifiers,[outpath '\' name])  %2020 03 06
    if ~isempty(object.identityImageIris)
        identityImage_downloadIRI=ed2fsIdentityImage(object.identityImageIris{1},[outpath '\' name '\IdentityImage'])  %2020 03 06
    end

    [Datafiles,dataf_tab]=ed2fsDatafiles(Specimens(iob).datafiles, ...
        [outpath '\' name '\Datafiles']);
end

if exist([outpath '\SpecimensProps.xlsx'],'file')
    dos(['del ' outpath '\SpecimensProps.xlsx']);
end
xlswrite([outpath '\SpecimensProps.xlsx'],tab)

end