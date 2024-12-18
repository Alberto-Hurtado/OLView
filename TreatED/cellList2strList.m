function strList=cellList2strList(cellList)
% function strList=cellList2strList(cellList)
% Converts a cell of strings (or object array) in an only formatted string
% F.J. Molina 2019 11

if ~isstr(cellList)
    strList='';
    for iElement=1:length(cellList)
        if iscell(cellList)
            element=cellList{iElement};   %cell
        else
            element=cellList(iElement);   %array
        end
        if isstr(element)
            strElement=element;
        else
            strElement=element.name;   % elsadata object
        end
        if iElement<length(cellList)
            strList=[strList strElement '##'];
        else
            strList=[strList strElement];
        end
    end
else
    strList=cellList;
end


