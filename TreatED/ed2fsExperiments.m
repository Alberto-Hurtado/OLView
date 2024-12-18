function [Experiments,tab] = ed2fsExperiments(ExperimentsRef,outpath)
% function [Experiments,tab] = ed2fsExperiments(ExperimentsRef,outpath)
% Migrates Experiments set from ELSADATA to File System
% Destination folder outpath will be cleared before migration!
% F.J. Molina 2018 04

iarg=2;
if nargin<iarg; outpath=''; end; iarg=iarg-1;
% if isempty(outpath); outpath='SLABSTRESS_FS\Experiments'; end;
if isempty(outpath)
    error('outpath cannot be empty!!!')
end

disp(outpath);
if exist(outpath,'dir')
    dos(['rmdir ' outpath '/s /q']);
else
    if ~isempty(ExperimentsRef)
        dos(['mkdir ' outpath]);
    end
end

% tabfields={'name' 'description' 'keywords' 'startDate' 'endDate' ...
%     'specimens' 'setupName' 'nature' 'id'};
tabfields={'name' 'description' 'keywords' 'startDate' 'endDate' ...
    'specimens' 'nature' 'id'};
tab=cell(length(ExperimentsRef),length(tabfields));
tab(1,:)=tabfields;
for iob=1:length(ExperimentsRef)
    object=getExperiment(data,ExperimentsRef(iob).id);
    Experiments(iob)=object;
    for ifield=1:length(tabfields)
        fieldname=tabfields{ifield};
        switch fieldname
            case {'startDate' 'endDate'}
                tab{1+iob,ifield}=objDate2strDate(getfield(object,fieldname));   %2019 11
            case 'nature'
                string=getfield(getfield(object,fieldname),'Value');
                tab{1+iob,ifield}=string;
            otherwise
                tab{1+iob,ifield}=cellList2strList(getfield(object,fieldname));   %2019 11
        end
    end
end

[dum,ifield_name]=find(strcmp(tabfields,'name'));
[dum,I]=sort(tab(2:(length(ExperimentsRef)+1),ifield_name)); %orders by name
tab(2:(length(ExperimentsRef)+1),:)=tab(1+I,:); %reordered tab
Experiments=Experiments(I);
for iob=1:length(ExperimentsRef)
    object=getExperiment(data,ExperimentsRef(iob).id);
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
    Experiments(iob).name=name;
    tab{1+iob,ifield_name}=name;
    dos(['mkdir ' outpath '\' name]);

    acknows_tab=ed2fsAcknows(object.dataAcknowledgements,[outpath '\' name])  %2020 03 06
    extIdentifiers_tab=ed2fsExtIdentifiers(object.extIdentifiers,[outpath '\' name])  %2020 03 06
    if ~isempty(object.identityImageIris)
        identityImage_downloadIRI=ed2fsIdentityImage(object.identityImageIris{1},[outpath '\' name '\IdentityImage'])  %2020 03 06
    end

    [Datafiles,dataf_tab]=ed2fsDatafiles(Experiments(iob).datafiles, ...
        [outpath '\' name '\Datafiles']);
    ed2fsSignals(Experiments(iob).outputSignals, ...
        [outpath '\' name '\Signals']);
end

if exist([outpath '\ExperimentsProps.xlsx'],'file')
    dos(['del ' outpath '\ExperimentsProps.xlsx']);
end
xlswrite([outpath '\ExperimentsProps.xlsx'],tab)

end