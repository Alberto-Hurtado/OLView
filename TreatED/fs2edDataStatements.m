function dataStatements=fs2edDataStatements(dataStatements_list,inPath,inPropFileName)
% function dataStatements=fs2edDataStatements(dataStatements_list,inPath,inPropFileName)
% Migrates a dataStatements set from File System to ELSADATA
% F.J. Molina 2019 12


% dataStatements_list={'EUROPEAN COMMISSION REUSE AND COPYRIGHT NOTICE © European Union, 1995-2019'}
% dataStatements_list={}
% nargin=1

iarg=3;
if nargin<iarg; inPropFileName=''; end; iarg=iarg-1;
if nargin<iarg; inPath=''; end; iarg=iarg-1;
if nargin<iarg; dataStatements_list=''; end; iarg=iarg-1;
if isempty(inPropFileName); inPropFileName='DataStatementsProps.xlsx'; end;
if isempty(inPath); inPath=[labpath '_GLOBAL_OBJECTS\dataStatements']; end;

tabfields={'name' 'description'  'url'  'id'}; 

% if ~exist(inPath,'dir')
%     dos(['mkdir ' inPath]);
% end
propFile=[inPath '\' inPropFileName]
if ~exist(propFile,'file')
    tab(1,1:length(tabfields))=tabfields;
    tab{2,1}='';
    xlswrite(propFile,tab);
end
if isempty(dataStatements_list)
    [num,txt,raw] = xlsread(propFile);
    dataStatements_list=txt(2:size(txt,1),1) %list of the names
end
for iDS=1:length(dataStatements_list)
    name=dataStatements_list{iDS}
    id=readtab(propFile,name,'id','txt')
    if isempty(id)
        isel = menu(['The id for the dataStatement ' name ' is not written in ' propFile],...
            'Retrieve the id of the dataStatement from ED and write it in the props file',...
            'Create the dataStatement in ED and write its id in the props file',...
            'Exit');
        asel={'Retrieve the id of object' 'Create object' 'exit' };
        sel=asel{isel}
    else
        sel='Use stored id'
    end
    switch sel
        case 'Retrieve the id of object'
            alldatastatements = getAllDataStatements(data);
            i1=0;
            found=false;
            while i1<length(alldatastatements) & ~found
                i1=i1+1;
                found=strcmp(name,alldatastatements(i1).name);
            end
            if found
%                 id=alldatastatements(i1).id;
                object = alldatastatements(i1);
            else
                error(['dataStatement ' name ' was not found!'])
            end
        case 'Create object'
            object = wsdl.data.DataStatement;
%             object.name = name;
%             object.description = readtab(propFile,name,'description','txt');
%             object.url = readtab(propFile,name,'url','txt');
            object.id = createDataStatement(data, object);
        case 'Use stored id'
            alldatastatements = getAllDataStatements(data);
            i1=0;
            found=false;
            while i1<length(alldatastatements) & ~found
                i1=i1+1;
                found=strcmp(id,alldatastatements(i1).id);
            end
            if found
%                 id=alldatastatements(i1).id;
                object = alldatastatements(i1);
            else
                error(['dataStatement id' id ' was not found!'])
            end
        case 'exit'
            return
    end
    object.name = name;
    object.description = readtab(propFile,name,'description','txt');
    object.url = readtab(propFile,name,'url','txt');
    object = object
    saveDataStatement(data,object);
    writetab(propFile,name,'id',object.id);
    dataStatements(iDS)=object;
end

end