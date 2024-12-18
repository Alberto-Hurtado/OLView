function [props,line]=readprops(filenam,objectname)
%READPROPS
%     {prop1, prop2 ...}=READPROPS(FILE,OBJECTNAME) reads the properties of
%     an object if it listed in the given file.
%     The data lines in the file have this format:
% > actuator_01: 100: a17: 3.862   : 0.0461 : short pier N hor:
% > actuator_03: 100: a21: 3.85057 : 0.0225 : short pier S hor:
% > actuator_05: 100: a04: 3.86317 : 0.12   : short isol hor  :
% > actuator_10: 100: a09: 3.87911 : 0.0262 : tall pier N hor :
%   
%       Ask also help on    readtit
%
%     EXAMPLE: 
%   props=readprops('L:\LAB\RETRO\Calibration\RETRO_load_cells.txt','actuator_12')
%   
%
%  2013   F.J. Molina

fid=fopen(filenam,'r');
table=setstr(fread(fid)');
fclose(fid);
str=['> ' objectname];
pos1=findstr(table,str);
if isempty(pos1);
  error([str ' not found in ' filenam '!']);
end;
line=table(pos1:length(table));
pos2=min(find(line==10 | line==13)); 
if ~isempty(pos2);
  line=line(1:(pos2-1));
end;
line1=line(length(str)+1:length(line));
pos2=findstr(line1,':');
props=cell(1,length(pos2)-1);
for i=1:length(pos2)-1
    props{i}=strtrim(line1(pos2(i)+1:pos2(i+1)-1));
end

