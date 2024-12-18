function strDate=objDate2strDate(objDate)
% function objDate=strDate2objDate(strDate)
% Converts an object date into a formatted string date
% F.J. Molina 2019 11

if isempty(objDate)
    strDate=[];
else
%             string=getfield(getfield(project,fieldname),'formattedDate_ISO');
    strDate=getfield(objDate,'formattedDate');%This format is assumed by excel if declared as text
end
