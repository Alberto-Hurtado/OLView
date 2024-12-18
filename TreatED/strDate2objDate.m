function objDate=strDate2objDate(strDate,fmt)
% function objDate=strDate2objDate(strDate,fmt)
% Converts a formatted string date into an object date
% F.J. Molina 2019 11

iarg=2;
if nargin<iarg; fmt=''; end; iarg=iarg-1;
if isempty(fmt);
    fmt='dd/mm/yyyy'; %This format is assumed by excel if declared as text
end;

if isempty(strDate)
    objDate=[]
else
            DateNumber = datenum(strDate,fmt);
            strDate = datestr(DateNumber,'dd/mm/yyyy');
            strDate2 = datestr(DateNumber,'yyyy-mm-dd'); %ISO format
            objDate = data.getCdvDate(strDate,strDate2);
end
