function tab=ed2fsProjectProp(object,outpath,outfilename)
% function tab=ed2fsProjectProp(object,outpath,outfilename)
% Migrates Project properties from ELSADATA to File System
% F.J. Molina 2020 02

iarg=3;
if nargin<iarg; outfilename=''; end; iarg=iarg-1;
if nargin<iarg; outpath=''; end; iarg=iarg-1;
if isempty(outfilename); outfilename='ProjectProps.xlsx'; end;
if isempty(outpath)
    error('outpath cannot be empty!!!')
end
disp(outpath);

% tabfields={'name' 'additionalName' 'description' 'startDate' 'endDate' 'keywords' 'purpose' ...
%     'citationText' 'dataAcknowledgements' 'extIdentifiers' 'id'};  %2019-11
tabfields={'name' 'additionalName' 'description' 'startDate' 'endDate' 'keywords' 'purpose' ...
    'citationText' 'dataStatements' 'id'};  %2019-11
% fnames=fieldnames(object);
tab=cell(2,length(tabfields));
tab(1,:)=tabfields;

for ifield=1:length(tabfields)
    fieldname=tabfields{ifield};
    switch fieldname
        case {'startDate' 'endDate'}
            tab{2,ifield}=objDate2strDate(getfield(object,fieldname));    %2019 11
        otherwise
            tab{2,ifield}=cellList2strList(getfield(object,fieldname));   %2019 11
    end
end
if ~exist(outpath,'dir')
    dos(['mkdir ' outpath]);
elseif exist([outpath '\' outfilename],'file')
    dos(['del ' outpath '\' outfilename]);
end
xlswrite([outpath '\' outfilename],tab)

acknows_tab=ed2fsAcknows(object.dataAcknowledgements,outpath)  %2020 03 06
extIdentifiers_tab=ed2fsExtIdentifiers(object.extIdentifiers,outpath)  %2020 03 06
if ~isempty(object.identityImageIris)
    identityImage_downloadIRI=ed2fsIdentityImage(object.identityImageIris{1},[outpath '\IdentityImage'])  %2020 03 06
end

end