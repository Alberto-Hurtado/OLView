function [Experiments,tab]= ...
    ed2fsExperiments(ExperimentsRef,outpath)
% function [Experiments,tab]= ...
%     ed2fsExperiments(ExperimentsRef,outpath)
% Migrates Experiments set from ELSADATA to File System
% F.J. Molina 2018 04


% ExperimentsRef=ExperimentsRef(1:2)

iarg=2;
if nargin<iarg; outpath=''; end; iarg=iarg-1;
if isempty(outpath); outpath='Experiments'; end;

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
            case 'keywords'
                list=getfield(object,fieldname);
                string='';
                for iElement=1:length(list)
                    if iElement<length(list)
                        string=[string list{iElement} '##'];
                    else
                        string=[string list{length(list)}];
                    end
                end
                tab{iob+1,ifield}=string;
            case {'startDate' 'endDate'}
                %             string=getfield(getfield(Experiment,fieldname),'formattedDate_ISO');
                string=getfield(getfield(object,fieldname),'formattedDate');
                tab{iob+1,ifield}=string;
            case 'nature'
                string=getfield(getfield(object,fieldname),'Value');
                tab{iob+1,ifield}=string;
            case 'specimens'
                list=getfield(object,fieldname);
                string='';
                for iElement=1:length(list)
                    if iElement<length(list)
                        string=[string list(iElement).name '##'];
                    else
                        string=[string list(iElement).name];
                    end
                end
                tab{iob+1,ifield}=string;
            otherwise
                tab{iob+1,ifield}=getfield(object,fieldname);
        end
    end
end

[dum,ifield_name]=find(strcmp(tabfields,'name'));
[dum,I]=sort(tab(2:(length(ExperimentsRef)+1),ifield_name)); %orders by name
tab(2:(length(ExperimentsRef)+1),:)=tab(1+I,:); %reordered tab
Experiments=Experiments(I);
for iob=1:length(ExperimentsRef)
    name=tab{iob+1,ifield_name};
    name=strrep(name,' ','_');
    name=strrep(name,',','-');
    name=strrep(name,'&','-');
    name=strrep(name,'%','-');
    name=strrep(name,'\','-');
    name=strrep(name,'{','-');
    name=strrep(name,'}','-');
    name=strrep(name,'<','-');
    name=strrep(name,'>','-');
    name=strrep(name,'*','-');
    name=strrep(name,'?','-');
    name=strrep(name,'/','-');
    name=strrep(name,'!','-');
    name=strrep(name,'''','-');
    name=strrep(name,'"','-');
    name=strrep(name,':','-');
    name=strrep(name,'|','-');
    name=strrep(name,'#','-');
    name=strrep(name,'@','-');
    name=strrep(name,'^','-');
    if iob==1 
        name_previous=name;
    else
        if strcmp(name,name_previous)
            name=[tab{iob,ifield_name} 'I']; %Avoid duplicated experiment name
        end
    end
    disp(name);
    Experiments(iob).name=name;
    tab{iob+1,ifield_name}=name;
    dos(['mkdir ' outpath '\' name]);
%     xlswrite([outpath '\' name '\ExperimentProps.xlsx'], ...
%         tab([1 iex+1],:))
    dataf_tab=ed2fsDatafiles(Experiments(iob).datafiles, ...
        [outpath '\' name '\Datafiles']);
    sig=Experiments(iob).outputSignals;
    ed2fsSignals(Experiments(iob).outputSignals, ...
        [outpath '\' name '\Signals']);
end

if exist([outpath '\ExperimentsProps.xlsx'],'file')
    dos(['del ' outpath '\ExperimentsProps.xlsx']);
end
xlswrite([outpath '\ExperimentsProps.xlsx'],tab)

end