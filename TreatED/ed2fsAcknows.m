function tab=ed2fsAcknows(acknows,outpath,outfilename)
% function tab=ed2fsAcknows(acknows,outpath,outfilename)
% Migrates acknows  of an object from ELSADATA to File System
% F.J. Molina 2020 02

iarg=3;
if nargin<iarg; outfilename=''; end; iarg=iarg-1;
if nargin<iarg; outpath=''; end; iarg=iarg-1;
if isempty(outfilename); outfilename='AcknowsProps.xlsx'; end;
if isempty(outpath)
    error('outpath cannot be empty!!!')
end
disp(outpath);

% tabfields={'name' 'description' 'referencedEntities' 'reference' 'url'};
% %'referencedEntities' should be a Organisation object.
tabfields={'name' 'description' 'reference' 'url'};
tab=cell(length(acknows),length(tabfields));
tab(1,:)=tabfields;

for iob=1:length(acknows)
    object = acknows(iob);
    for ifield=1:length(tabfields)
        fieldname=tabfields{ifield};
%         switch fieldname
%             otherwise
                tab{1+iob,ifield}=cellList2strList(getfield(object,fieldname));  
%         end
    end
end

if ~exist(outpath,'dir')
    dos(['mkdir ' outpath]);
elseif exist([outpath '\' outfilename],'file')
    dos(['del ' outpath '\' outfilename]);
end
xlswrite([outpath '\' outfilename],tab);

end

