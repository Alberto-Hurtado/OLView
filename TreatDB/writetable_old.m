function [status,msg] = writetable(filename,rowname,columnname,cellvalue)
%writetable
%     [status,msg] = writetable(filename,rowname,columnname,cellvalue)
%     From a xls or xslx file, modifies the value of the cell
%     in the table that is positioned at the row 'rowname' and the column
%     'columnname'. 
%
%       Ask also help on    readtable readtit
%
%     EXAMPLE:
%   patroot=[labpath 'SAFE']
%   filename=[patroot '\SAFE_project.xlsx']
%   project='SAFE ELSA'
%   proj_descr='Seismic testing of shear walls'
%   writetable(filename,project,'Description',proj_descr)
%   writetable(filename,{'SAFE ELSA' 'SAFE ELSA1'},'Description',proj_descr)
%   writetable(filename,{'SAFE ELSA' 'SAFE ELSA1'},'Description',{proj_descr '--'})
%
%  2014   J. Molina


[num,txt,raw] = xlsread(filename);

rown=rowname;
cellflag=iscell(rown);
if ~cellflag
    rown={rown};
end
if ~iscell(cellvalue)
    cellvalue={cellvalue};
end

for i=1:length(rown)
    
    cellv=cellvalue{min(i,length(cellvalue))};
    rownamei=rown{i};
    irow=1;
    if ischar(rownamei)
        while irow<=size(raw,1) & ~strcmp(rownamei,raw(irow,1))
            irow=irow+1;
        end
        if strcmp(rownamei,raw(irow,1))
            icol=1;
            while icol<=size(raw,2) & ~strcmp(columnname,raw(1,icol))
                icol=icol+1;
            end
            if strcmp(columnname,raw(1,icol))
                raw{irow,icol}=cellv;
            else
                error(['Column name ' columnname ' was not found in first row of ' filename '!']);
            end
        else
            error(['Row name ' rownamei ' wasnot found in first column of ' filename '!']);
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
                raw{irow,icol}=cellv;
            else
                error(['Column name ' columnname ' was not found in first row of ' filename '!']);
            end
        else
            error(['Row name ' rownamei ' wasnot found in first column of ' filename '!']);
        end;
    end
        
end


[status,msg] = xlswrite(filename,raw);











