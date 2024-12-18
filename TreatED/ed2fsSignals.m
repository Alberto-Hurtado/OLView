function tab=ed2fsSignals(Signals,outpath)
% function tab=ed2fsSignals(Signals,outpath)
% Migrates Signals set from ELSADATA to File System
% F.J. Molina 2018 04

iarg=2;
if nargin<iarg; outpath=''; end; iarg=iarg-1;
if isempty(outpath); outpath='Signals'; end;

if length(Signals)==0
    return
end

tabfields={'groupName';'name';'description'; ...
    'magnitude.typeName';'magnitude.unitName'; ...
    'additionalNotes'};
tab=cell(length(tabfields),length(Signals));

% if exist(outpath,'dir')
%     dos(['rmdir ' outpath '/s /q']);
% end
if ~exist(outpath,'dir')
    dos(['mkdir ' outpath]);
end

for isig=1:length(Signals)
    sig=Signals(isig);
%     sig.magnitudeName=sig.magnitude.type.name;
    if isempty(sig.magnitude)
        sig.magnitude = data.getMagnitude;
    end
    for ifield=1:length(tabfields)
        tab{ifield,isig}=eval(['sig.' tabfields{ifield,1}]);
    end
end
[B,I]=sort(tab(1,:)); %orders by group name
groupName1=tab{1,I(1)};
Igroup=1;
for iI=1:length(I)
    if ~strcmp(groupName1,tab{1,I(iI)})
        Igroup=[Igroup; iI];
        groupName1=tab{1,I(iI)};
    end
end
ngroups=length(Igroup);
Igroup1=[Igroup; length(I)+1];
for igroup=1:ngroups
    grouplength=Igroup1(igroup+1)-Igroup1(igroup);
    group_tabcell=cell(length(tabfields),grouplength);
    group_tabcell= ...
        tab(:,I(Igroup1(igroup):Igroup1(igroup+1)-1));
    for ii=1:grouplength
        isig=I(Igroup1(igroup)+ii-1);
%         s=webread(Signals(isig).downloadIRI);
        s=webreadS(Signals(isig).downloadIRI);  %2019-11-19
        s1=strrep(char(s'),'Infinity','Inf');  %2019-04-30
%         s1=strrep(char(s),'Infinity','Inf');
        values=eval( [ '[' s1 ']' ] )';
        if ii==1
            group_tabmatrix=zeros(length(values),grouplength);
        end
        group_tabmatrix(1:length(values),ii)=values;
    end
    groupName_split=strsplit(group_tabcell{1,1});
    groupNam=groupName_split{1};
    fileName=[outpath '\' groupNam '.csv'];
    fid = fopen(fileName, 'W');
    [nrows,ncols]=size(group_tabcell);
    for irow=1:nrows
        for icol=1:ncols-1
            strOKcoma=group_tabcell{irow,icol};
%             if ~isempty(strOKcoma)
%                 strOKcoma=strrep(group_tabcell{irow,icol},',',';');
%             end
            if ~isempty(find(strOKcoma==','))
                strOKcoma=['"' strOKcoma '"'];
            end
            fprintf(fid,'%s,',strOKcoma);
        end
        fprintf(fid,'%s\n',group_tabcell{irow,ncols});
    end
    [nrows,ncols]=size(group_tabmatrix);
    for irow=1:nrows
        for icol=1:ncols-1
            fprintf(fid,'%.10g,',group_tabmatrix(irow,icol));
        end
        fprintf(fid,'%.10g\n',group_tabmatrix(irow,ncols));
    end
    fclose(fid);
end

end

