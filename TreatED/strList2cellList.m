function cellList=strList2cellList(strList,forceCell)
% function cellList=strList2cellList(strList)
% Converts a formatted list string into a cell of strings
% F.J. Molina 2019 11

if nargin<2
    forceCell=0; %for lists of 1 element, gives back the input string
end

cellList=strList;
if ~isempty(strList)
    i_sep=strfind(strList,'##');
    if ~isempty(i_sep) || forceCell
        i_sep=[i_sep length(strList)+1];
        cellList={};
        for iElement=1:length(i_sep)
            if iElement==1
                cellList{iElement}=strList(1:i_sep(iElement)-1);
            else
                cellList{iElement}=strList(i_sep(iElement-1)+2:i_sep(iElement)-1);
            end
        end
    end
end


