function tit=readtit(filenam,testname)
%READTIT
%     TITLE=READTIT(INDEXFILE,TEST) reads the TITLE of
%     a TEST if it listed in an index file
%   
%       Ask also help on    gettitle
%
%     EXAMPLE: 
%   tit=readtit('\\smnt08\users\lab\efardis\efardisp\contents\e_tit.m','e08')
%   settitle(1,tit)
%
%  11/12/96   J. Molina

fid=fopen(filenam,'r');
tittable=setstr(fread(fid)');
fclose(fid);
str=[testname ':'];
pos1=findstr(tittable,str);
if isempty(pos1);
  error([str ' not found in ' filenam '!']);
end;
tit=tittable(pos1+length(str)+1:length(tittable));
pos2=min(find(tit==10 | tit==13)); 
if ~isempty(pos2);
  tit=tit(1:(pos2-1));
end;
tit=deblank(tit);    %6-2-2004
