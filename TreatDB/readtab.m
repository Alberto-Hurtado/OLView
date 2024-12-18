function cellvalue=readtab(filename,rowname,columnname,val_type,sheet)
%readtab
%     cellvalue=readtab(filename,rowname,columnname,val_type)
%     From a xls or xslx file, gets the value of the cell
%     in the table that is positioned at the row 'rowname' and the column
%     'columnname'. 
%     val_type=='raw' content is not converted (default).
%     val_type=='txt' content is converted to txt.
%     val_type=='num' content is converted to number.
%
%       Ask also help on    readtit readtable
%
%     EXAMPLE:
%   patroot=[labpath 'SAFE']
%   filename=[patroot '\SAFE_project.xlsx']
%   project='SAFE ELSA'
%   proj_descr=readtab(filename,project,'Description')
%   proj_descr=readtab(filename,{project project},'Description')
%
%  2014   J. Molina

iarg=5;
if nargin<iarg; sheet=''; end; iarg=iarg-1;
if nargin<iarg; val_type=[]; end; iarg=iarg-1;
if isempty(val_type); val_type='raw'; end;

[num,txt,raw] = xlsread(filename,sheet);

switch val_type
    case 'raw'
        tabl=raw;
    case 'num'
        tabl=num;
    case 'txt'
        tabl=txt;
end

rown=rowname;
cellflag=iscell(rown);
if ~cellflag
    rown={rown};
end
cellvalue=cell(size(rown));

for i=1:length(rown)
    
    rownamei=rown{i};
    irow=1;
    if ischar(rownamei)
        while irow<=size(raw,1) & ~strcmp(rownamei,raw{irow,1})
            irow=irow+1;
        end
        if irow>size(raw,1)
            error(sprintf('\n\n     "%s"    NOT FOUND IN  %s!!',rownamei,filename));
        end
        if strcmp(rownamei,raw{irow,1})
            icol=1;
%             while icol<=size(raw,2) & ~strcmp(columnname,raw{1,icol})
            while icol<size(raw,2) & ~strcmp(columnname,raw{1,icol})
                icol=icol+1;
            end
            if strcmp(columnname,raw{1,icol})
                cellv=raw{irow,icol};
            else
                error(['Column name ' columnname ' was not found in first row of ' filename '!']);
            end
        else
            error(['Row name ' rownamei ' was not found in first column of ' filename '!']);
        end;
    else
        while irow<=size(raw,1) & rownamei ~= cell2mat(raw(irow,1))
            irow=irow+1;
        end
        if rownamei == cell2mat(raw(irow,1))
            icol=1;
            while icol<=size(raw,2) & ~strcmp(columnname,raw(1,icol))
                icol=icol+1;
            end
            if strcmp(columnname,raw(1,icol))
                cellv=raw{irow,icol};
            else
                error(['Column name ' columnname ' was not found in first row of ' filename '!']);
            end
        else
            error(['Row name ' rownamei ' wasnot found in first column of ' filename '!']);
        end;
    end
    
    cellvalue{i}=cellv;
    if isnan(cellv)
        cellvalue{i}='';
    end
end

if ~cellflag
    cellvalue=cellvalue{1};
end












